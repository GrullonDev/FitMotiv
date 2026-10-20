import 'package:dart_frog/dart_frog.dart';

import '../../../../../lib/core/database/database.dart';
import '../../../../../lib/core/utils/json_response.dart';
import '../../../../../lib/features/nutrition/data/nutrition_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();

  final db = context.read<Database>();
  final repo = NutritionRepository(db);

  final recipe = await repo.getRecipeById(id);
  if (recipe == null) return jsonNotFound('Recipe not found');
  return jsonOk(recipe);
}
