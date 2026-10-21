import 'package:dart_frog/dart_frog.dart';

import '../utils/json_response.dart';
import '../utils/jwt_service.dart';

class AuthUser {
  const AuthUser({required this.id, required this.email});
  final String id;
  final String email;
}

Middleware authMiddleware() {
  return (handler) {
    return (context) async {
      final authHeader = context.request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return jsonUnauthorized('Missing or invalid authorization header');
      }

      final token = authHeader.substring(7);
      final payload = JwtService.verifyToken(token);

      if (payload == null) {
        return jsonUnauthorized('Invalid or expired token');
      }

      final tokenType = payload['type'] as String?;
      if (tokenType != 'access') {
        return jsonUnauthorized('Invalid token type');
      }

      final userId = payload['sub'] as String?;
      final email = payload['email'] as String?;

      if (userId == null || email == null) {
        return jsonUnauthorized('Invalid token payload');
      }

      final authUser = AuthUser(id: userId, email: email);
      final updatedContext = context.provide<AuthUser>(() => authUser);
      return handler(updatedContext);
    };
  };
}

Middleware optionalAuthMiddleware() {
  return (handler) {
    return (context) async {
      final authHeader = context.request.headers['authorization'];
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        final payload = JwtService.verifyToken(token);
        if (payload != null) {
          final userId = payload['sub'] as String?;
          final email = payload['email'] as String?;
          if (userId != null && email != null) {
            final authUser = AuthUser(id: userId, email: email);
            final updatedContext = context.provide<AuthUser>(() => authUser);
            return handler(updatedContext);
          }
        }
      }
      return handler(context);
    };
  };
}
