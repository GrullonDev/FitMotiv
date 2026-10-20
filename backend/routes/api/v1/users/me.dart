import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/middleware/auth_middleware.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/core/utils/request_helpers.dart';
import '../../../../lib/features/users/data/users_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final authUser = context.read<AuthUser>();
  final db = context.read<Database>();
  final usersRepo = UsersRepository(db);

  switch (context.request.method) {
    case HttpMethod.get:
      return _getProfile(usersRepo, authUser);
    case HttpMethod.patch:
      return _updateProfile(context, usersRepo, authUser);
    default:
      return methodNotAllowed();
  }
}

Future<Response> _getProfile(UsersRepository repo, AuthUser authUser) async {
  final profile = await repo.getProfile(authUser.id);
  if (profile == null) return jsonNotFound('Profile not found');
  return jsonOk(profile);
}

Future<Response> _updateProfile(
  RequestContext context,
  UsersRepository repo,
  AuthUser authUser,
) async {
  final body = await parseJsonBody(context);
  if (body.isEmpty) return jsonError('Request body is empty');

  try {
    final updated = await repo.updateProfile(authUser.id, body);
    if (updated == null) return jsonNotFound('Profile not found');
    return jsonOk(updated);
  } catch (e) {
    final message = e.toString();
    if (message.contains('Username is already taken')) {
      return jsonError('Username is already taken', statusCode: 409);
    }
    return jsonError('Failed to update profile', statusCode: 500);
  }
}
