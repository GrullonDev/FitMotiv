import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Enum para definir los diferentes flavors/entornos de la aplicación
enum AppFlavor { dev, prod }

/// Clase singleton que maneja la configuración de la aplicación
/// según el flavor/entorno actual.
///
/// Cada flavor carga su propio archivo .env:
///   - dev  → .env.dev  (conecta al proyecto Supabase de desarrollo)
///   - prod → .env.prod (conecta al proyecto Supabase de producción)
///
/// Esto permite que la rama develop y main del proyecto se conecten
/// a proyectos Supabase diferentes automáticamente.
class AppConfig {
  AppConfig._internal();
  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? (_instance = AppConfig._internal());

  AppFlavor _flavor = AppFlavor.dev;
  bool _isInitialized = false;

  /// Inicializa la configuración con el flavor especificado
  /// y carga el archivo .env correspondiente al entorno
  Future<void> initialize({required AppFlavor flavor}) async {
    _flavor = flavor;

    final envFileName = _getEnvFileName(flavor);

    try {
      await dotenv.load(fileName: envFileName);
      _isInitialized = true;
      debugPrint('✅ AppConfig initialized: $environmentName environment');
      debugPrint('📁 Loaded env file: $envFileName');
      if (isDevelopment) {
        debugPrint('🔗 Supabase URL: $supabaseUrl');
      }
    } catch (e) {
      debugPrint('⚠️ Error loading $envFileName: $e');

      // Fallback: intentar cargar .env genérico
      try {
        await dotenv.load(fileName: '.env');
        debugPrint('📁 Loaded fallback .env');
      } catch (_) {
        debugPrint('⚠️ No .env files found. Using empty defaults.');
      }
      _isInitialized = true;
    }
  }

  /// Retorna el nombre del archivo .env según el flavor
  String _getEnvFileName(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return '.env.dev';
      case AppFlavor.prod:
        return '.env.prod';
    }
  }

  /// Obtiene el flavor actual
  AppFlavor get flavor => _flavor;

  /// Verifica si la configuración ha sido inicializada
  bool get isInitialized => _isInitialized;

  /// Obtiene la URL base del API según el flavor actual
  String get apiBaseUrl {
    _ensureInitialized();

    switch (_flavor) {
      case AppFlavor.dev:
        return dotenv.env['API_URL'] ?? 'http://localhost:8000';
      case AppFlavor.prod:
        return dotenv.env['API_URL'] ?? 'https://api.fitmotiv.com/api';
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
    return isDevelopment ? const Duration(seconds: 30) : const Duration(seconds: 15);
  }

  /// Configuración para logging según el entorno
  bool get enableLogging => isDevelopment;

  /// URL completa para endpoints específicos
  String getApiUrl(String endpoint) {
    final baseUrl = apiBaseUrl;
    // Asegurar que no haya doble slash
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

    return '$cleanBaseUrl/$cleanEndpoint';
  }

  // ─────────────────────────────────────────────
  // Supabase Configuration
  // ─────────────────────────────────────────────

  /// URL del proyecto Supabase (dev o prod según el flavor)
  String get supabaseUrl {
    _ensureInitialized();
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  /// Anon Key del proyecto Supabase (dev o prod según el flavor)
  String get supabaseAnonKey {
    _ensureInitialized();
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  /// Helper para verificar que la configuración fue inicializada
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('AppConfig no ha sido inicializado. Llama a initialize() primero.');
    }
  }
}
