import 'package:backend/core/database/database.dart';
import 'package:backend/core/middleware/auth_middleware.dart';
import 'package:backend/core/utils/json_response.dart';
import 'package:backend/core/utils/request_helpers.dart';
import 'package:backend/features/progress/data/progress_repository.dart';
import 'package:dart_frog/dart_frog.dart';

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
