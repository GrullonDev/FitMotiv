import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Enum para definir los diferentes flavors/entornos de la aplicación
enum AppFlavor { dev, prod }

/// Clase singleton que maneja la configuración de la aplicación
/// según el flavor/entorno actual
class AppConfig {

  AppConfig._internal();
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._internal();

  AppFlavor _flavor = AppFlavor.dev;
  bool _isInitialized = false;

  /// Inicializa la configuración con el flavor especificado
  /// y carga las variables de entorno
  Future<void> initialize({required AppFlavor flavor}) async {
    _flavor = flavor;

    try {
      await dotenv.load(fileName: '.env');
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading .env file: $e');
      // En caso de error, continúa con valores por defecto
      _isInitialized = true;
    }
  }

  /// Obtiene el flavor actual
  AppFlavor get flavor => _flavor;

  /// Verifica si la configuración ha sido inicializada
  bool get isInitialized => _isInitialized;

  /// Obtiene la URL base del API según el flavor actual
  String get apiBaseUrl {
    if (!_isInitialized) {
      throw Exception(
        'AppConfig no ha sido inicializado. Llama a initialize() primero.',
      );
    }

    switch (_flavor) {
      case AppFlavor.dev:
        return dotenv.env['DEV_API_URL'] ?? 'http://localhost:8000';
      case AppFlavor.prod:
        return dotenv.env['PROD_API_URL'] ?? 'https://api.tuapp.com/api';
    }
  }

  /// Indica si estamos en modo desarrollo
  bool get isDevelopment => _flavor == AppFlavor.dev;

  /// Indica si estamos en modo producción
  bool get isProduction => _flavor == AppFlavor.prod;

  /// Obtiene el nombre del entorno como string
  String get environmentName {
    switch (_flavor) {
      case AppFlavor.dev:
        return 'Development';
      case AppFlavor.prod:
        return 'Production';
    }
  }

  /// Configuración para timeouts de HTTP según el entorno
  Duration get httpTimeout {
    return isDevelopment
        ? const Duration(seconds: 30)
        : const Duration(seconds: 15);
  }

  /// Configuración para logging según el entorno
  bool get enableLogging => isDevelopment;

  /// URL completa para endpoints específicos
  String getApiUrl(String endpoint) {
    final baseUrl = apiBaseUrl;
    // Asegurar que no haya doble slash
    final cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    return '$cleanBaseUrl/$cleanEndpoint';
  }
}
