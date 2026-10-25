import '../../../core/database/database.dart';

class NutritionRepository {
  NutritionRepository(this._db);
  final Database _db;

  // --- Meal Plans ---

  Future<List<Map<String, dynamic>>> getMealPlans({
    int limit = 20,
    int offset = 0,
  }) async {
    final result = await _db.query(
      '''
      SELECT id, title, description, calories, icon, badge_text,
             image_url, is_recommended, created_at
      FROM meal_plans
      WHERE is_public = true
      ORDER BY is_recommended DESC, created_at DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: {'limit': limit, 'offset': offset},
    );

    return result
        .map((row) => {
              'id': row[0],
              'title': row[1],
              'description': row[2],
              'calories': row[3],
              'icon': row[4],
              'badge_text': row[5],
              'image_url': row[6],
              'is_recommended': row[7],
              'created_at': (row[8] as DateTime).toIso8601String(),
            })
        .toList();
  }

  // --- Recipes ---

  Future<List<Map<String, dynamic>>> getRecipes({
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>['is_public = true'];
    final parameters = <String, dynamic>{};

    if (category != null && category.isNotEmpty) {
      conditions.add('category = @category');
      parameters['category'] = category;
    }

    final where = 'WHERE ${conditions.join(' AND ')}';

    parameters['limit'] = limit;
    parameters['offset'] = offset;

    final result = await _db.query(
      '''
      SELECT id, title, description, time, calories, category,
             image_url, rating, ingredients, instructions, created_at
      FROM recipes
      $where
      ORDER BY rating DESC, created_at DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: parameters,
    );

    return result.map(_recipeFromRow).toList();
  }

  Future<Map<String, dynamic>?> getRecipeById(String id) async {
    final result = await _db.query(
      '''
      SELECT id, title, description, time, calories, category,
             image_url, rating, ingredients, instructions, created_at
      FROM recipes
      WHERE id = @id
      ''',
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return _recipeFromRow(result.first);
  }

  Future<Map<String, dynamic>?> getRandomRecipe() async {
    final result = await _db.query(
      '''
      SELECT id, title, description, time, calories, category,
             image_url, rating, ingredients, instructions, created_at
      FROM recipes
      WHERE is_public = true
      ORDER BY random()
      LIMIT 1
      ''',
    );

    if (result.isEmpty) return null;
    return _recipeFromRow(result.first);
  }

  // --- Water Log ---

  Future<Map<String, dynamic>> getTodayWater(String userId) async {
    final result = await _db.query(
      '''
      SELECT id, glasses, date
      FROM water_log
      WHERE user_id = @user_id AND date = CURRENT_DATE
      ''',
      parameters: {'user_id': userId},
    );

    if (result.isEmpty) {
      return {'glasses': 0, 'date': DateTime.now().toIso8601String().split('T')[0]};
    }

    final row = result.first;
    return {
      'id': row[0],
      'glasses': row[1],
      'date': (row[2] as DateTime).toIso8601String().split('T')[0],
    };
  }

  Future<Map<String, dynamic>> updateWater(
    String userId,
    int glasses,
  ) async {
    final result = await _db.query(
      '''
      INSERT INTO water_log (user_id, glasses, date)
      VALUES (@user_id, @glasses, CURRENT_DATE)
      ON CONFLICT (user_id, date) DO UPDATE SET glasses = @glasses
      RETURNING id, glasses, date
      ''',
      parameters: {
        'user_id': userId,
        'glasses': glasses,
      },
    );

    final row = result.first;
    return {
      'id': row[0],
      'glasses': row[1],
      'date': (row[2] as DateTime).toIso8601String().split('T')[0],
    };
  }

  Map<String, dynamic> _recipeFromRow(List<dynamic> row) {
    final ingredients = row[8];
    return {
      'id': row[0],
      'title': row[1],
      'description': row[2],
      'time': row[3],
      'calories': row[4],
      'category': row[5],
      'image_url': row[6],
      'rating': row[7],
      'ingredients': ingredients is List ? ingredients : <String>[],
      'instructions': row[9],
      'created_at': (row[10] as DateTime).toIso8601String(),
    };
  }
}
