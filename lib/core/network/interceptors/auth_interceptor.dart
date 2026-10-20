import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fit_motiv/core/services/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;
  final _pendingRequests = <Completer<void>>[];

  static const _noAuthPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
    '/workouts',
    '/quotes',
    '/nutrition/meals',
    '/nutrition/recipes',
    '/health',
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    final needsAuth = !_noAuthPaths.any((p) => path.contains(p)) ||
        path.contains('/progress') ||
        path.contains('/users/me') ||
        path.contains('/nutrition/water');

    if (needsAuth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final path = err.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      final completer = Completer<void>();
      _pendingRequests.add(completer);
      await completer.future;

      final token = await _tokenStorage.getAccessToken();
      if (token != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      }
      handler.next(err);
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _tokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      final response = await _dio.post(
        '${err.requestOptions.baseUrl.replaceAll(RegExp(r'/api$'), '')}/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      final responseData = data is Map<String, dynamic>
          ? (data['data'] is Map<String, dynamic> ? data['data'] : data)
          : <String, dynamic>{};

      final newAccessToken = responseData['access_token'] as String?;
      final newRefreshToken = responseData['refresh_token'] as String?;

      if (newAccessToken != null && newRefreshToken != null) {
        await _tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        for (final completer in _pendingRequests) {
          completer.complete();
        }
        _pendingRequests.clear();

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(err.requestOptions);
        handler.resolve(retryResponse);
        return;
      }

      await _tokenStorage.clearTokens();
      handler.next(err);
    } catch (_) {
      await _tokenStorage.clearTokens();
      for (final completer in _pendingRequests) {
        completer.completeError(err);
      }
      _pendingRequests.clear();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
