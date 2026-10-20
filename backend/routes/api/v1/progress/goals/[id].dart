import 'package:dart_frog/dart_frog.dart';

import '../../../../../lib/core/database/database.dart';
import '../../../../../lib/core/middleware/auth_middleware.dart';
import '../../../../../lib/core/utils/json_response.dart';
import '../../../../../lib/features/progress/data/progress_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.patch) return methodNotAllowed();

  final authUser = context.read<AuthUser>();
  final db = context.read<Database>();
  final repo = ProgressRepository(db);

  final goal = await repo.toggleGoalCompleted(authUser.id, id);
  if (goal == null) return jsonNotFound('Goal not found');
  return jsonOk(goal);
}
