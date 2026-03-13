import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource para el progreso y metas del usuario
class ProgressSupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene el historial de peso del usuario
  Future<List<Map<String, dynamic>>> getWeightLog() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('weight_log')
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(30);

      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return [];
    }
  }

  /// Obtiene las metas del usuario
  Future<List<Map<String, dynamic>>> getGoals() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('goals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return [];
    }
  }

  /// Obtiene las sesiones de workout del usuario
  Future<List<Map<String, dynamic>>> getWorkoutSessions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('workout_sessions')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false)
          .limit(30);

      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return [];
    }
  }

  /// Registra un peso
  Future<void> logWeight(double weight, {String notes = ''}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await _client.from('weight_log').insert({
      'user_id': userId,
      'weight': weight,
      'notes': notes,
    });
  }

  /// Crea una meta
  Future<void> createGoal({
    required String title,
    String description = '',
    double targetValue = 0,
    String unit = '',
    String icon = 'flag',
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await _client.from('goals').insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'target_value': targetValue,
      'unit': unit,
      'icon': icon,
    });
  }

  /// Marca una meta como completada
  Future<void> toggleGoalCompleted(String goalId, bool completed) async {
    await _client.from('goals').update({
      'is_completed': completed,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', goalId);
  }
}
