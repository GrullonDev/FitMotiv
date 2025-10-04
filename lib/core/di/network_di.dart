import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../network/services/api_service.dart';

/// Core network dependency injection configuration
/// This class provides generic network services that can be used across all modules
/// Follows the Dependency Injection principle and helps maintain
/// a clean separation of concerns for network operations
class NetworkDI {
  static void init(GetIt sl) {
    // Register Dio instance for general API communication
    sl.registerLazySingleton<Dio>(() => _createDio(), instanceName: 'mainDio');

    // Register ApiService
    sl.registerLazySingleton<ApiService>(
      () => ApiService(
        dio: sl<Dio>(instanceName: 'mainDio'),
        baseUrl: _getApiBaseUrl(),
      ),
    );
  }

  /// Create configured Dio instance for general API communication
  static Dio _createDio() {
    final dio = Dio();

    // Base configuration
    dio.options.baseUrl = _getApiBaseUrl();
    dio.options.connectTimeout = Duration(seconds: _getTimeoutSeconds());
    dio.options.receiveTimeout = Duration(seconds: _getTimeoutSeconds());
    dio.options.sendTimeout = Duration(seconds: _getTimeoutSeconds());

    // Add logging interceptor in development
    if (_isLoggingEnabled()) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (object) => print('[API HTTP]: $object'), // ignore: avoid_print
        ),
      );
    }

    return dio;
  }

  /// Get base URL for the API
  static String _getApiBaseUrl() {
    final isProd = dotenv.env['ENVIRONMENT'] == 'production';
    final baseUrl = isProd
        ? dotenv.env['PROD_API_URL'] ?? 'https://api.tuapp.com'
        : dotenv.env['DEV_API_URL'] ?? 'http://localhost:8000';

    // Add /api suffix if not present
    return baseUrl.endsWith('/api') ? baseUrl : '$baseUrl/api';
  }

  /// Get timeout configuration
  static int _getTimeoutSeconds() {
    final isProd = dotenv.env['ENVIRONMENT'] == 'production';
    final timeoutStr = isProd ? dotenv.env['PROD_TIMEOUT_SECONDS'] ?? '15' : dotenv.env['DEV_TIMEOUT_SECONDS'] ?? '30';

    return int.tryParse(timeoutStr) ?? (isProd ? 15 : 30);
  }

  /// Check if logging is enabled
  static bool _isLoggingEnabled() {
    final isProd = dotenv.env['ENVIRONMENT'] == 'production';
    final loggingStr = isProd
        ? dotenv.env['PROD_ENABLE_LOGGING'] ?? 'false'
        : dotenv.env['DEV_ENABLE_LOGGING'] ?? 'true';

    return loggingStr.toLowerCase() == 'true';
  }
}
