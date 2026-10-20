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

  // Validate required fields
  final email = body['email'] as String?;
  final password = body['password'] as String?;
  final fullName = body['full_name'] as String?;

  final emailError = validateEmail(email);
  if (emailError != null) return jsonError(emailError);

  final passwordError = validatePassword(password);
  if (passwordError != null) return jsonError(passwordError);

  final nameError = validateRequired(fullName, 'Full name');
  if (nameError != null) return jsonError(nameError);

  try {
    final result = await authRepo.register(
      email: sanitize(email!),
      password: password!,
      fullName: sanitize(fullName!),
      username: sanitize(body['username'] as String? ?? ''),
      bio: sanitize(body['bio'] as String? ?? ''),
      fitnessGoal: sanitize(body['fitness_goal'] as String? ?? ''),
      activityLevel: sanitize(body['activity_level'] as String? ?? ''),
      age: (body['age'] as num?)?.toInt() ?? 0,
      height: (body['height'] as num?)?.toDouble() ?? 0.0,
      weight: (body['weight'] as num?)?.toDouble() ?? 0.0,
    );
    return jsonCreated(result);
  } on AuthException catch (e) {
    return jsonError(e.message, statusCode: 409);
  } catch (e) {
    return jsonError('Registration failed', statusCode: 500);
  }
}
