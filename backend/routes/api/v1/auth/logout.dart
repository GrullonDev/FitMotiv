import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/core/utils/jwt_service.dart';
import '../../../../lib/core/utils/request_helpers.dart';
import '../../../../lib/features/auth/data/auth_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) return methodNotAllowed();

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return jsonUnauthorized();
  }

  final token = authHeader.substring(7);
  final payload = JwtService.verifyToken(token);
  if (payload == null) return jsonUnauthorized('Invalid token');

  if (payload['type'] != 'access') {
    return jsonUnauthorized('Invalid token type');
  }

  final userId = payload['sub'] as String?;
  if (userId == null) return jsonUnauthorized('Invalid token');

  final body = await parseJsonBody(context);
  final db = context.read<Database>();
  final authRepo = AuthRepository(db);

  await authRepo.logout(
    userId,
    refreshTokenValue: body['refresh_token'] as String?,
  );

  return jsonOk({'message': 'Logged out successfully'});
}
