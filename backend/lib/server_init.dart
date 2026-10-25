import 'dart:async';
import 'dart:io';

import 'core/config/env.dart';
import 'core/database/database.dart';
import 'core/database/migrator.dart';
import 'database/seeds/seed_data.dart';

Completer<void>? _initCompleter;

Future<void> ensureInitialized() async {
  if (_initCompleter != null) {
    return _initCompleter!.future;
  }

  _initCompleter = Completer<void>();

  try {
    stdout.writeln('[Server] Loading environment...');
    Env.load();

    if (Env.jwtSecret == 'change-me-in-production') {
      stderr.writeln(
        '[FATAL] JWT_SECRET is set to the default value. '
        'Generate a strong secret: openssl rand -base64 64',
      );
      throw StateError(
        'JWT_SECRET must be set to a secure value. '
        'Cannot start with default secret.',
      );
    }

    stdout.writeln('[Server] Connecting to database...');
    await Database.instance.initialize();

    stdout.writeln('[Server] Running migrations...');
    final migrator = Migrator(Database.instance);
    await migrator.run();

    stdout.writeln('[Server] Seeding data...');
    final seeder = SeedData(Database.instance);
    await seeder.run();

    stdout.writeln('[Server] Initialization complete');
    _initCompleter!.complete();
  } catch (e) {
    _initCompleter!.completeError(e);
    _initCompleter = null;
    rethrow;
  }
}
