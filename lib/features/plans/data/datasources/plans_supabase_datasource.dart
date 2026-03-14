import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource para obtener planes de nutrición, recetas, tips y artículos
/// directamente desde Supabase.
class PlansSupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  // ─────────────────────────────────────────
  // Meal Plans
  // ─────────────────────────────────────────

  /// Obtiene todos los planes de comidas públicos
  Future<List<Map<String, dynamic>>> getMealPlans() async {
    try {
      final response = await _client
          .from('meal_plans')
          .select()
          .eq('is_public', true)
          .order('is_recommended', ascending: false)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Error fetching meal plans: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────
  // Recipes
  // ─────────────────────────────────────────

  /// Obtiene todas las recetas públicas
  Future<List<Map<String, dynamic>>> getRecipes({String? category}) async {
    try {
      var query = _client.from('recipes').select().eq('is_public', true);

      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Error fetching recipes: $e');
      return [];
    }
  }

  /// Obtiene una receta aleatoria para mostrar en el dashboard
  Future<Map<String, dynamic>?> getRandomRecipe() async {
    try {
      final response = await _client.from('recipes').select().eq('is_public', true).limit(10);

      final recipes = List<Map<String, dynamic>>.from(response);
      if (recipes.isEmpty) return null;

      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
      final index = dayOfYear % recipes.length;
      return recipes[index];
    } catch (e) {
      debugPrint('❌ Error fetching random recipe: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────
  // Tips ("Sabías que?")
  // ─────────────────────────────────────────

  /// Obtiene los tips/mitos nutricionales
  Future<List<Map<String, dynamic>>> getTips() async {
    try {
      final response = await _client.from('tips').select().eq('is_public', true).order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Error fetching tips: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────
  // Articles
  // ─────────────────────────────────────────

  /// Obtiene los artículos recomendados
  Future<List<Map<String, dynamic>>> getArticles() async {
    try {
      final response = await _client
          .from('articles')
          .select()
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Error fetching articles: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────
  // Water Log
  // ─────────────────────────────────────────

  /// Obtiene el registro de agua del día actual
  Future<int> getTodayWaterGlasses() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return 0;

    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final response = await _client
          .from('water_log')
          .select('glasses')
          .eq('user_id', userId)
          .eq('date', today)
          .maybeSingle();

      return (response?['glasses'] as int?) ?? 0;
    } catch (e) {
      debugPrint('❌ Error fetching water log: $e');
      return 0;
    }
  }

  /// Actualiza el registro de agua del día actual (upsert)
  Future<void> updateWaterGlasses(int glasses) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      await _client.from('water_log').upsert({
        'user_id': userId,
        'glasses': glasses,
        'date': today,
      }, onConflict: 'user_id,date');
    } catch (e) {
      debugPrint('❌ Error updating water log: $e');
    }
  }
}
