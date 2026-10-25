import 'dart:async';
import 'dart:io';

import 'package:postgres/postgres.dart';

import '../config/env.dart';

class Database {
  Database._();
  static Database? _instance;
  static Database get instance => _instance ??= Database._();

  late Pool _pool;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _pool = Pool.withEndpoints(
      [
        Endpoint(
          host: Env.dbHost,
          port: Env.dbPort,
          database: Env.dbName,
          username: Env.dbUser,
          password: Env.dbPassword,
        ),
      ],
      settings: PoolSettings(
        maxConnectionCount: 10,
        connectTimeout: const Duration(seconds: 10),
        queryTimeout: const Duration(seconds: 30),
        sslMode: SslMode.disable,
      ),
    );

    _initialized = true;
    stdout.writeln(
      '[DB] Pool connected to PostgreSQL at ${Env.dbHost}:${Env.dbPort}/${Env.dbName}',
    );
  }

  Future<Result> query(
    String sql, {
    Map<String, dynamic>? parameters,
  }) async {
    return _pool.execute(Sql.named(sql), parameters: parameters);
  }

  Future<T> transaction<T>(
    Future<T> Function(TxSession session) action,
  ) async {
    return _pool.runTx(action);
  }

  Future<void> close() async {
    await _pool.close();
    _initialized = false;
    stdout.writeln('[DB] Pool closed');
  }
}
