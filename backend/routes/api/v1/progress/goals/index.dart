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
      final goals = await repo.getGoals(authUser.id);
      return jsonOk(goals);
    case HttpMethod.post:
      return _createGoal(context, repo, authUser);
    default:
      return methodNotAllowed();
  }
}

Future<Response> _createGoal(
  RequestContext context,
  ProgressRepository repo,
  AuthUser authUser,
) async {
  final body = await parseJsonBody(context);

  final title = body['title'] as String?;
  if (title == null || title.isEmpty) {
    return jsonError('Goal title is required');
  }

  final goal = await repo.createGoal(authUser.id, body);
  return jsonCreated(goal);
}
