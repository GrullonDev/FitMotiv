import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource que obtiene workouts desde Supabase
class WorkoutSupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene todos los workouts públicos y los del usuario actual
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final response = await _client.from('workouts').select().order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Obtiene workouts filtrados por categoría
  Future<List<Map<String, dynamic>>> getWorkoutsByCategory(String category) async {
    final response = await _client
        .from('workouts')
        .select()
        .eq('category', category)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Obtiene un workout random para "Workout of the Day"
  Future<Map<String, dynamic>?> getRandomWorkout() async {
    final response = await _client.from('workouts').select().eq('is_public', true).limit(10);

    final workouts = List<Map<String, dynamic>>.from(response);
    if (workouts.isEmpty) return null;

    // Usar el día actual como seed para que cambie diariamente
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final index = dayOfYear % workouts.length;
    return workouts[index];
  }

  /// Obtiene los ejercicios de un workout específico desde la tabla exercises.
  /// Si la tabla no tiene ejercicios para este workout, retorna una lista vacía.
  Future<List<Map<String, dynamic>>> getExercises(String workoutId) async {
    try {
      final response = await _client
          .from('exercises')
          .select()
          .eq('workout_id', workoutId)
          .order('sort_order', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      // Si la tabla no existe aún, retornar vacío
      return [];
    }
  }

  /// Obtiene un workout por su ID
  Future<Map<String, dynamic>?> getWorkoutById(String id) async {
    try {
      final response = await _client.from('workouts').select().eq('id', id).maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }
}
