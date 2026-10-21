import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/env.dart';

class JwtService {
  static String generateAccessToken(String userId, String email) {
    final jwt = JWT(
      {
        'sub': userId,
        'email': email,
        'type': 'access',
      },
      issuer: 'fitmotiv-api',
    );

    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: Duration(minutes: Env.accessTokenExpiryMinutes),
    );
  }

  static String generateRefreshToken(String userId) {
    final jwt = JWT(
      {
        'sub': userId,
        'type': 'refresh',
      },
      issuer: 'fitmotiv-api',
    );

    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: Duration(days: Env.refreshTokenExpiryDays),
    );
  }

  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
      return jwt.payload as Map<String, dynamic>;
    } on JWTExpiredException {
      return null;
    } on JWTException {
      return null;
    }
  }

  static String? extractUserId(String token) {
    final payload = verifyToken(token);
    return payload?['sub'] as String?;
  }
}
