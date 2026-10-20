import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'package:fit_motiv/core/network/interceptors/auth_interceptor.dart';
import 'package:fit_motiv/core/services/token_storage.dart';

class NetworkDI {
  static void init(GetIt sl) {
    sl.registerLazySingleton<TokenStorage>(() => TokenStorage());

    sl.registerLazySingleton<Dio>(
      () => _createDio(sl<TokenStorage>()),
      instanceName: 'mainDio',
    );
  }

  static Dio _createDio(TokenStorage tokenStorage) {
    final dio = Dio();

    dio.options.baseUrl = _getApiBaseUrl();
    dio.options.connectTimeout = Duration(seconds: _getTimeoutSeconds());
    dio.options.receiveTimeout = Duration(seconds: _getTimeoutSeconds());
    dio.options.sendTimeout = Duration(seconds: _getTimeoutSeconds());
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';

    dio.interceptors.add(
      AuthInterceptor(tokenStorage: tokenStorage, dio: dio),
    );

    if (_isLoggingEnabled()) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (object) =>
              print('[API HTTP]: $object'), // ignore: avoid_print
        ),
      );
    }

    return dio;
  }

  static String _getApiBaseUrl() {
    final isProd = dotenv.env['ENVIRONMENT'] == 'production';
    final baseUrl = isProd
        ? dotenv.env['PROD_API_URL'] ?? 'https://api.tuapp.com'
        : dotenv.env['DEV_API_URL'] ?? 'http://localhost:8080';

    return baseUrl.endsWith('/api') ? baseUrl : '$baseUrl/api';
  }

  static int _getTimeoutSeconds() {
    final isProd = dotenv.env['ENVIRONMENT'] == 'production';
    final timeoutStr = isProd
        ? dotenv.env['PROD_TIMEOUT_SECONDS'] ?? '15'
        : dotenv.env['DEV_TIMEOUT_SECONDS'] ?? '30';

    return int.tryParse(timeoutStr) ?? (isProd ? 15 : 30);
  }

  static bool _isLoggingEnabled() {
    final isProd = dotenv.env['ENVIRONMENT'] == 'production';
    final loggingStr = isProd
        ? dotenv.env['PROD_ENABLE_LOGGING'] ?? 'false'
        : dotenv.env['DEV_ENABLE_LOGGING'] ?? 'true';

    return loggingStr.toLowerCase() == 'true';
  }
}
