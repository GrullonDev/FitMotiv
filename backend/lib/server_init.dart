import 'dart:io';

import 'core/config/env.dart';
import 'core/database/database.dart';
import 'core/database/migrator.dart';
import 'database/seeds/seed_data.dart';

bool _initialized = false;

Future<void> ensureInitialized() async {
  if (_initialized) return;
  _initialized = true;

  stdout.writeln('[Server] Loading environment...');
  Env.load();

  if (Env.jwtSecret == 'change-me-in-production') {
    stderr.writeln(
      '[WARNING] JWT_SECRET is set to the default value. '
      'Generate a strong secret: openssl rand -base64 64',
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
}
