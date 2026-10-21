import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/core/utils/request_helpers.dart';
import '../../../../lib/features/auth/data/auth_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) return methodNotAllowed();

  final body = await parseJsonBody(context);
  final db = context.read<Database>();
  final authRepo = AuthRepository(db);

  final refreshToken = body['refresh_token'] as String?;
  if (refreshToken == null || refreshToken.isEmpty) {
    return jsonError('Refresh token is required');
  }

  try {
    final result = await authRepo.refreshToken(refreshToken);
    return jsonOk(result);
  } on AuthException catch (e) {
    return jsonUnauthorized(e.message);
  } catch (e) {
    return jsonError('Token refresh failed', statusCode: 500);
  }
}
