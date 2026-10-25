import 'dart:io';

import 'package:postgres/postgres.dart';

import '../config/env.dart';

class Database {
  Database._();
  static Database? _instance;
  static Database get instance => _instance ??= Database._();

  Pool? _pool;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final endpoint = Endpoint(
      host: Env.dbHost,
      port: Env.dbPort,
      database: Env.dbName,
      username: Env.dbUser,
      password: Env.dbPassword,
    );

    _pool = Pool.withEndpoints(
      [endpoint],
      settings: PoolSettings(
        maxConnectionCount: 10,
        sslMode: SslMode.disable,
        connectTimeout: const Duration(seconds: 10),
        queryTimeout: const Duration(seconds: 30),
      ),
    );

    _initialized = true;
    stdout.writeln('[DB] Pool connected to PostgreSQL at ${Env.dbHost}:${Env.dbPort}/${Env.dbName}');
  }

  Pool get pool {
    if (_pool == null || !_initialized) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _pool!;
  }

  Future<Result> query(
    String sql, {
    Map<String, dynamic>? parameters,
  }) async {
    return pool.execute(Sql.named(sql), parameters: parameters);
  }

  Future<T> transaction<T>(
    Future<T> Function(TxSession session) action,
  ) async {
    return pool.runTx(action);
  }

  Future<void> close() async {
    await _pool?.close();
    _pool = null;
    _initialized = false;
    stdout.writeln('[DB] Pool closed');
  }
}
