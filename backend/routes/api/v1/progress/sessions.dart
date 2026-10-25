import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/middleware/auth_middleware.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/core/utils/request_helpers.dart';
import '../../../../lib/features/progress/data/progress_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final authUser = context.read<AuthUser>();
  final db = context.read<Database>();
  final repo = ProgressRepository(db);

  switch (context.request.method) {
    case HttpMethod.get:
      final params = context.request.uri.queryParameters;
      final limit = int.tryParse(params['limit'] ?? '') ?? 20;
      final offset = int.tryParse(params['offset'] ?? '') ?? 0;
      final sessions = await repo.getWorkoutSessions(
        authUser.id,
        limit: limit.clamp(1, 100),
        offset: offset < 0 ? 0 : offset,
      );
      return jsonOk(sessions);
    case HttpMethod.post:
      return _logSession(context, repo, authUser);
    default:
      return methodNotAllowed();
  }
}

Future<Response> _logSession(
  RequestContext context,
  ProgressRepository repo,
  AuthUser authUser,
) async {
  final body = await parseJsonBody(context);

  final workoutName = body['workout_name'] as String?;
  if (workoutName == null || workoutName.isEmpty) {
    return jsonError('Workout name is required');
  }

  final session = await repo.logWorkoutSession(authUser.id, body);
  return jsonCreated(session);
}
