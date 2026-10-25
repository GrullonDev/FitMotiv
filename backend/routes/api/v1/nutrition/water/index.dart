import 'package:dart_frog/dart_frog.dart';

import '../../../../../lib/core/database/database.dart';
import '../../../../../lib/core/middleware/auth_middleware.dart';
import '../../../../../lib/core/utils/json_response.dart';
import '../../../../../lib/core/utils/request_helpers.dart';
import '../../../../../lib/features/nutrition/data/nutrition_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final authUser = context.read<AuthUser>();
  final db = context.read<Database>();
  final repo = NutritionRepository(db);

  switch (context.request.method) {
    case HttpMethod.get:
      final water = await repo.getTodayWater(authUser.id);
      return jsonOk(water);
    case HttpMethod.put:
      return _updateWater(context, repo, authUser.id);
    default:
      return methodNotAllowed();
  }
}

Future<Response> _updateWater(
  RequestContext context,
  NutritionRepository repo,
  String userId,
) async {
  final body = await parseJsonBody(context);

  final glasses = body['glasses'] as int?;
  if (glasses == null || glasses < 0) {
    return jsonError('Valid glasses count is required');
  }

  final water = await repo.updateWater(userId, glasses);
  return jsonOk(water);
}
