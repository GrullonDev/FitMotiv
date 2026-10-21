import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';

import '../../../core/config/env.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/jwt_service.dart';
import '../../../core/utils/password_hasher.dart';

class AuthRepository {
  AuthRepository(this._db);
  final Database _db;

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String username = '',
    String bio = '',
    String fitnessGoal = '',
    String activityLevel = '',
    int age = 0,
    double height = 0.0,
    double weight = 0.0,
  }) async {
    final normalizedEmail = email.toLowerCase();
    final passwordHash = PasswordHasher.hash(password);

    // Use INSERT ... ON CONFLICT to avoid revealing whether email exists
    return _db.transaction((tx) async {
      final userResult = await tx.execute(
        Sql.named('''
          INSERT INTO users (email, password_hash)
          VALUES (@email, @password_hash)
          ON CONFLICT (email) DO NOTHING
          RETURNING id, email, is_active, is_verified, created_at
        '''),
        parameters: {
          'email': normalizedEmail,
          'password_hash': passwordHash,
        },
      );

      if (userResult.isEmpty) {
        // Email already exists — return a generic success to prevent enumeration
        return {
          'message': 'If this email is available, your account has been created. Check your email to continue.',
        };
      }

      final user = userResult.first;
      final userId = user[0] as String;

      // Check username uniqueness (this is safe to reveal — usernames are public)
      if (username.isNotEmpty) {
        final existingUsername = await tx.execute(
          Sql.named('SELECT user_id FROM profiles WHERE username = @username'),
          parameters: {'username': username},
        );
        if (existingUsername.isNotEmpty) {
          throw AuthException('Username is already taken');
        }
      }

      await tx.execute(
        Sql.named('''
          INSERT INTO profiles (user_id, full_name, username, bio, fitness_goal, activity_level, age, height, weight)
          VALUES (@user_id, @full_name, @username, @bio, @fitness_goal, @activity_level, @age, @height, @weight)
        '''),
        parameters: {
          'user_id': userId,
          'full_name': fullName,
          'username': username.isEmpty ? 'user_${userId.substring(0, 8)}' : username,
          'bio': bio,
          'fitness_goal': fitnessGoal,
          'activity_level': activityLevel,
          'age': age,
          'height': height,
          'weight': weight,
        },
      );

      return {
        'message': 'If this email is available, your account has been created. Check your email to continue.',
      };
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase();

    // Find user
    final result = await _db.query(
      'SELECT id, email, password_hash, is_active, failed_login_attempts, locked_until FROM users WHERE email = @email',
      parameters: {'email': normalizedEmail},
    );

    if (result.isEmpty) {
      // Generic error to prevent account enumeration
      throw AuthException('Invalid email or password');
    }

    final user = result.first;
    final userId = user[0] as String;
    final passwordHash = user[2] as String;
    final isActive = user[3] as bool;
    final failedAttempts = user[4] as int;
    final lockedUntil = user[5] as DateTime?;

    if (!isActive) {
      throw AuthException('Account is deactivated');
    }

    // Check lockout
    if (lockedUntil != null && lockedUntil.isAfter(DateTime.now().toUtc())) {
      final minutes = lockedUntil.difference(DateTime.now().toUtc()).inMinutes + 1;
      throw AuthException('Account is temporarily locked. Try again in $minutes minutes');
    }

    // Verify password
    if (!PasswordHasher.verify(password, passwordHash)) {
      final newAttempts = failedAttempts + 1;
      if (newAttempts >= Env.maxLoginAttempts) {
        await _db.query(
          'UPDATE users SET failed_login_attempts = @attempts, locked_until = @locked_until WHERE id = @id',
          parameters: {
            'attempts': newAttempts,
            'locked_until': DateTime.now().toUtc().add(Duration(minutes: Env.loginLockoutMinutes)),
            'id': userId,
          },
        );
      } else {
        await _db.query(
          'UPDATE users SET failed_login_attempts = @attempts WHERE id = @id',
          parameters: {'attempts': newAttempts, 'id': userId},
        );
      }
      throw AuthException('Invalid email or password');
    }

    // Reset failed attempts
    await _db.query(
      'UPDATE users SET failed_login_attempts = 0, locked_until = NULL WHERE id = @id',
      parameters: {'id': userId},
    );

    // Generate tokens
    final accessToken = JwtService.generateAccessToken(userId, normalizedEmail);
    final refreshToken = JwtService.generateRefreshToken(userId);

    // Store refresh token hash
    final tokenHash = sha256.convert(utf8.encode(refreshToken)).toString();
    await _db.query(
      'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (@user_id, @token_hash, @expires_at)',
      parameters: {
        'user_id': userId,
        'token_hash': tokenHash,
        'expires_at': DateTime.now().toUtc().add(Duration(days: Env.refreshTokenExpiryDays)),
      },
    );

    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': 'bearer',
      'expires_in': Env.accessTokenExpiryMinutes * 60,
    };
  }

  Future<Map<String, dynamic>> refreshToken(String refreshTokenValue) async {
    final payload = JwtService.verifyToken(refreshTokenValue);
    if (payload == null || payload['type'] != 'refresh') {
      throw AuthException('Invalid refresh token');
    }

    final userId = payload['sub'] as String;
    final tokenHash = sha256.convert(utf8.encode(refreshTokenValue)).toString();

    // Find and validate stored refresh token
    final result = await _db.query(
      'SELECT id, revoked, expires_at FROM refresh_tokens WHERE token_hash = @hash AND user_id = @user_id',
      parameters: {'hash': tokenHash, 'user_id': userId},
    );

    if (result.isEmpty) {
      throw AuthException('Refresh token not found');
    }

    final storedToken = result.first;
    final isRevoked = storedToken[1] as bool;
    final expiresAt = storedToken[2] as DateTime;

    if (isRevoked) {
      // Potential token reuse — revoke all tokens for this user
      await _db.query(
        'UPDATE refresh_tokens SET revoked = true WHERE user_id = @user_id',
        parameters: {'user_id': userId},
      );
      throw AuthException('Token has been revoked');
    }

    if (expiresAt.isBefore(DateTime.now().toUtc())) {
      throw AuthException('Refresh token expired');
    }

    // Revoke old token (rotation)
    await _db.query(
      'UPDATE refresh_tokens SET revoked = true WHERE token_hash = @hash',
      parameters: {'hash': tokenHash},
    );

    // Get user email
    final userResult = await _db.query(
      'SELECT email FROM users WHERE id = @id AND is_active = true',
      parameters: {'id': userId},
    );
    if (userResult.isEmpty) {
      throw AuthException('User not found');
    }
    final email = userResult.first[0] as String;

    // Generate new pair
    final newAccessToken = JwtService.generateAccessToken(userId, email);
    final newRefreshToken = JwtService.generateRefreshToken(userId);
    final newTokenHash = sha256.convert(utf8.encode(newRefreshToken)).toString();

    await _db.query(
      'INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (@user_id, @token_hash, @expires_at)',
      parameters: {
        'user_id': userId,
        'token_hash': newTokenHash,
        'expires_at': DateTime.now().toUtc().add(Duration(days: Env.refreshTokenExpiryDays)),
      },
    );

    return {
      'access_token': newAccessToken,
      'refresh_token': newRefreshToken,
      'token_type': 'bearer',
      'expires_in': Env.accessTokenExpiryMinutes * 60,
    };
  }

  Future<void> logout(String userId, {String? refreshTokenValue}) async {
    if (refreshTokenValue != null) {
      final tokenHash = sha256.convert(utf8.encode(refreshTokenValue)).toString();
      await _db.query(
        'UPDATE refresh_tokens SET revoked = true WHERE token_hash = @hash AND user_id = @user_id',
        parameters: {'hash': tokenHash, 'user_id': userId},
      );
    } else {
      // Revoke all refresh tokens for this user
      await _db.query(
        'UPDATE refresh_tokens SET revoked = true WHERE user_id = @user_id',
        parameters: {'user_id': userId},
      );
    }
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
