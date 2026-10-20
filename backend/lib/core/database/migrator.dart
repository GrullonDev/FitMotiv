import 'dart:io';

import 'package:postgres/postgres.dart';

import 'database.dart';

class Migrator {
  Migrator(this._db);
  final Database _db;

  Future<void> run() async {
    await _ensureMigrationsTable();
    final applied = await _getAppliedMigrations();
    final pending = _allMigrations
        .where((m) => !applied.contains(m.version))
        .toList()
      ..sort((a, b) => a.version.compareTo(b.version));

    if (pending.isEmpty) {
      stdout.writeln('[Migrator] All migrations are up to date');
      return;
    }

    for (final migration in pending) {
      stdout.writeln('[Migrator] Applying migration ${migration.version}: ${migration.name}');
      await _db.transaction((tx) async {
        await tx.execute(migration.sql);
        await tx.execute(
          Sql.named(
            'INSERT INTO _migrations (version, name) VALUES (@version, @name)',
          ),
          parameters: {
            'version': migration.version,
            'name': migration.name,
          },
        );
      });
      stdout.writeln('[Migrator] Applied ${migration.version}');
    }
  }

  Future<void> _ensureMigrationsTable() async {
    await _db.query('''
      CREATE TABLE IF NOT EXISTS _migrations (
        version TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        applied_at TIMESTAMPTZ DEFAULT now()
      )
    ''');
  }

  Future<Set<String>> _getAppliedMigrations() async {
    final result = await _db.query('SELECT version FROM _migrations');
    return result.map((row) => row[0] as String).toSet();
  }

  static final List<_Migration> _allMigrations = [
    _Migration(
      version: '001',
      name: 'create_users_and_profiles',
      sql: '''
        CREATE EXTENSION IF NOT EXISTS "pgcrypto";

        CREATE TABLE IF NOT EXISTS users (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          email TEXT NOT NULL UNIQUE,
          password_hash TEXT NOT NULL,
          is_active BOOLEAN DEFAULT true,
          is_verified BOOLEAN DEFAULT false,
          failed_login_attempts INTEGER DEFAULT 0,
          locked_until TIMESTAMPTZ,
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);

        CREATE TABLE IF NOT EXISTS profiles (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
          full_name TEXT NOT NULL DEFAULT '',
          username TEXT UNIQUE,
          bio TEXT DEFAULT '',
          fitness_goal TEXT DEFAULT '',
          activity_level TEXT DEFAULT '',
          age INTEGER DEFAULT 0,
          height DOUBLE PRECISION DEFAULT 0.0,
          weight DOUBLE PRECISION DEFAULT 0.0,
          avatar_url TEXT DEFAULT '',
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles (user_id);
        CREATE INDEX IF NOT EXISTS idx_profiles_username ON profiles (username);
      ''',
    ),
    _Migration(
      version: '002',
      name: 'create_refresh_tokens',
      sql: '''
        CREATE TABLE IF NOT EXISTS refresh_tokens (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          token_hash TEXT NOT NULL UNIQUE,
          expires_at TIMESTAMPTZ NOT NULL,
          revoked BOOLEAN DEFAULT false,
          created_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens (user_id);
        CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token_hash ON refresh_tokens (token_hash);
      ''',
    ),
    _Migration(
      version: '003',
      name: 'create_workouts_and_exercises',
      sql: '''
        CREATE TABLE IF NOT EXISTS workouts (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID REFERENCES users(id) ON DELETE CASCADE,
          name TEXT NOT NULL,
          description TEXT DEFAULT '',
          duration INTEGER DEFAULT 0,
          difficulty TEXT DEFAULT 'Beginner',
          category TEXT DEFAULT 'General',
          equipment TEXT[] DEFAULT '{}',
          is_public BOOLEAN DEFAULT false,
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_workouts_category ON workouts (category);
        CREATE INDEX IF NOT EXISTS idx_workouts_is_public ON workouts (is_public);

        CREATE TABLE IF NOT EXISTS exercises (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          workout_id UUID NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
          name TEXT NOT NULL,
          description TEXT DEFAULT '',
          category TEXT DEFAULT 'General',
          seconds INTEGER,
          reps INTEGER,
          rest_seconds INTEGER DEFAULT 15,
          sort_order INTEGER DEFAULT 0,
          image_url TEXT DEFAULT '',
          created_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_exercises_workout_id ON exercises (workout_id);
      ''',
    ),
    _Migration(
      version: '004',
      name: 'create_progress_tables',
      sql: '''
        CREATE TABLE IF NOT EXISTS workout_sessions (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          workout_id UUID REFERENCES workouts(id) ON DELETE SET NULL,
          workout_name TEXT NOT NULL,
          duration_minutes INTEGER DEFAULT 0,
          calories_burned INTEGER DEFAULT 0,
          notes TEXT DEFAULT '',
          completed_at TIMESTAMPTZ DEFAULT now(),
          created_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_workout_sessions_user_id ON workout_sessions (user_id);
        CREATE INDEX IF NOT EXISTS idx_workout_sessions_completed_at ON workout_sessions (completed_at);

        CREATE TABLE IF NOT EXISTS weight_log (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          weight DOUBLE PRECISION NOT NULL,
          notes TEXT DEFAULT '',
          recorded_at TIMESTAMPTZ DEFAULT now(),
          created_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_weight_log_user_id ON weight_log (user_id);

        CREATE TABLE IF NOT EXISTS goals (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          title TEXT NOT NULL,
          description TEXT DEFAULT '',
          target_value DOUBLE PRECISION DEFAULT 0,
          current_value DOUBLE PRECISION DEFAULT 0,
          unit TEXT DEFAULT '',
          icon TEXT DEFAULT 'flag',
          is_completed BOOLEAN DEFAULT false,
          deadline TIMESTAMPTZ,
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS idx_goals_user_id ON goals (user_id);
      ''',
    ),
    _Migration(
      version: '005',
      name: 'create_nutrition_tables',
      sql: '''
        CREATE TABLE IF NOT EXISTS meal_plans (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT DEFAULT '',
          calories TEXT DEFAULT '',
          icon TEXT DEFAULT 'restaurant',
          badge_text TEXT DEFAULT '',
          image_url TEXT DEFAULT '',
          is_recommended BOOLEAN DEFAULT false,
          is_public BOOLEAN DEFAULT true,
          created_by UUID REFERENCES users(id),
          created_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE TABLE IF NOT EXISTS recipes (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT DEFAULT '',
          time TEXT DEFAULT '',
          calories TEXT DEFAULT '',
          category TEXT DEFAULT 'General',
          image_url TEXT DEFAULT '',
          rating DOUBLE PRECISION DEFAULT 0,
          ingredients TEXT[] DEFAULT '{}',
          instructions TEXT DEFAULT '',
          is_public BOOLEAN DEFAULT true,
          created_by UUID REFERENCES users(id),
          created_at TIMESTAMPTZ DEFAULT now()
        );

        CREATE TABLE IF NOT EXISTS water_log (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          glasses INTEGER DEFAULT 0,
          date DATE DEFAULT CURRENT_DATE,
          created_at TIMESTAMPTZ DEFAULT now(),
          UNIQUE(user_id, date)
        );

        CREATE INDEX IF NOT EXISTS idx_water_log_user_date ON water_log (user_id, date);
      ''',
    ),
    _Migration(
      version: '006',
      name: 'create_quotes_table',
      sql: '''
        CREATE TABLE IF NOT EXISTS quotes (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          text TEXT NOT NULL,
          author TEXT DEFAULT '',
          category TEXT DEFAULT 'general',
          created_at TIMESTAMPTZ DEFAULT now()
        );
      ''',
    ),
  ];
}

class _Migration {
  const _Migration({
    required this.version,
    required this.name,
    required this.sql,
  });

  final String version;
  final String name;
  final String sql;
}
