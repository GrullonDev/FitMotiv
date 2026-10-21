import 'dart:io';

import 'package:postgres/postgres.dart';

import '../config/env.dart';

class Database {
  Database._();
  static Database? _instance;
  static Database get instance => _instance ??= Database._();

  Connection? _connection;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _connection = await Connection.open(
      Endpoint(
        host: Env.dbHost,
        port: Env.dbPort,
        database: Env.dbName,
        username: Env.dbUser,
        password: Env.dbPassword,
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.disable,
        connectTimeout: const Duration(seconds: 10),
        queryTimeout: const Duration(seconds: 30),
      ),
    );

    _initialized = true;
    stdout.writeln('[DB] Connected to PostgreSQL at ${Env.dbHost}:${Env.dbPort}/${Env.dbName}');
  }

  Connection get connection {
    if (_connection == null || !_initialized) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _connection!;
  }

  Future<Result> query(
    String sql, {
    Map<String, dynamic>? parameters,
  }) async {
    return connection.execute(Sql.named(sql), parameters: parameters);
  }

  Future<T> transaction<T>(
    Future<T> Function(TxSession session) action,
  ) async {
    return connection.runTx(action);
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    _initialized = false;
    stdout.writeln('[DB] Connection closed');
  }
}
