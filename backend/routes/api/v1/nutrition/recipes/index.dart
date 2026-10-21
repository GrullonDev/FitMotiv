import 'package:dart_frog/dart_frog.dart';

import '../../../../../lib/core/database/database.dart';
import '../../../../../lib/core/utils/json_response.dart';
import '../../../../../lib/features/nutrition/data/nutrition_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();

  final db = context.read<Database>();
  final repo = NutritionRepository(db);
  final params = context.request.uri.queryParameters;

  final recipes = await repo.getRecipes(category: params['category']);
  return jsonOk(recipes);
}
