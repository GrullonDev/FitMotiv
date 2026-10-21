import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/core/utils/jwt_service.dart';
import '../../../../lib/core/utils/request_helpers.dart';
import '../../../../lib/features/nutrition/data/nutrition_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return jsonUnauthorized();
  }

  final token = authHeader.substring(7);
  final payload = JwtService.verifyToken(token);
  if (payload == null || payload['type'] != 'access') {
    return jsonUnauthorized('Invalid token');
  }

  final userId = payload['sub'] as String?;
  if (userId == null) return jsonUnauthorized('Invalid token');

  final db = context.read<Database>();
  final repo = NutritionRepository(db);

  switch (context.request.method) {
    case HttpMethod.get:
      final water = await repo.getTodayWater(userId);
      return jsonOk(water);
    case HttpMethod.put:
      return _updateWater(context, repo, userId);
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
