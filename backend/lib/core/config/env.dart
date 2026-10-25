import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Env {
  Env._();

  static late final DotEnv _dotEnv;
  static bool _initialized = false;

  static void load() {
    if (_initialized) return;
    _dotEnv = DotEnv(includePlatformEnvironment: true);
    final envFile = File('.env');
    if (envFile.existsSync()) {
      _dotEnv.load(['.env']);
    }
    _initialized = true;
  }

  static String get(String key, {String defaultValue = ''}) {
    if (!_initialized) load();
    return _dotEnv[key] ?? Platform.environment[key] ?? defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return int.tryParse(get(key)) ?? defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    final value = get(key).toLowerCase();
    return value == 'true' || value == '1';
  }

  // Database
  static String get dbHost => get('DB_HOST', defaultValue: 'localhost');
  static int get dbPort => getInt('DB_PORT', defaultValue: 5432);
  static String get dbName => get('DB_NAME', defaultValue: 'fitmotiv');
  static String get dbUser => get('DB_USER', defaultValue: 'fitmotiv_user');
  static String get dbPassword => get('DB_PASSWORD', defaultValue: 'fitmotiv_dev_password');

  // JWT
  static String get jwtSecret =>
      get('JWT_SECRET', defaultValue: 'change-me-in-production');
  static int get accessTokenExpiryMinutes =>
      getInt('ACCESS_TOKEN_EXPIRY_MINUTES', defaultValue: 15);
  static int get refreshTokenExpiryDays =>
      getInt('REFRESH_TOKEN_EXPIRY_DAYS', defaultValue: 30);

  // Server
  static int get port => getInt('PORT', defaultValue: 8080);
  static String get host => get('HOST', defaultValue: '0.0.0.0');

  // Rate limiting
  static int get maxLoginAttempts =>
      getInt('MAX_LOGIN_ATTEMPTS', defaultValue: 5);
  static int get loginLockoutMinutes =>
      getInt('LOGIN_LOCKOUT_MINUTES', defaultValue: 15);
}
