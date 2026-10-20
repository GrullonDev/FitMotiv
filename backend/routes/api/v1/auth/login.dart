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

  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || email.isEmpty) return jsonError('Email is required');
  if (password == null || password.isEmpty) {
    return jsonError('Password is required');
  }

  try {
    final result = await authRepo.login(
      email: sanitize(email),
      password: password,
    );
    return jsonOk(result);
  } on AuthException catch (e) {
    return jsonUnauthorized(e.message);
  } catch (e) {
    return jsonError('Login failed', statusCode: 500);
  }
}
