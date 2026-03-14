import 'package:fit_motiv/features/routines/data/datasources/workout_supabase_datasource.dart';
import 'package:flutter/material.dart';

/// Provider que gestiona los workouts desde Supabase
class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({required WorkoutSupabaseDatasource datasource}) : _datasource = datasource {
    loadWorkouts();
  }

  final WorkoutSupabaseDatasource _datasource;

  List<Map<String, dynamic>> _workouts = [];
  Map<String, dynamic>? _dailyWorkout;
  bool _isLoading = false;
  String? _error;

  /// Cache de ejercicios por workout_id
  final Map<String, List<Map<String, dynamic>>> _exercisesCache = {};
  bool _loadingExercises = false;

  List<Map<String, dynamic>> get workouts => _workouts;
  Map<String, dynamic>? get dailyWorkout => _dailyWorkout;
  bool get isLoading => _isLoading;
  bool get loadingExercises => _loadingExercises;
  String? get error => _error;

  /// Lista de workouts filtrada por categoría
  List<Map<String, dynamic>> getByCategory(String category) {
    if (category == 'All') return _workouts;
    return _workouts.where((w) => w['category'] == category).toList();
  }

  /// Obtiene ejercicios de un workout (desde cache o Supabase)
  List<Map<String, dynamic>> getExercisesFor(String workoutId) {
    return _exercisesCache[workoutId] ?? [];
  }

  /// Carga los ejercicios de un workout específico desde Supabase
  Future<List<Map<String, dynamic>>> loadExercises(String workoutId) async {
    if (_exercisesCache.containsKey(workoutId)) {
      return _exercisesCache[workoutId]!;
    }

    _loadingExercises = true;
    notifyListeners();

    try {
      final exercises = await _datasource.getExercises(workoutId);
      _exercisesCache[workoutId] = exercises;
      return exercises;
    } catch (e) {
      debugPrint('❌ Error loading exercises: $e');
      return [];
    } finally {
      _loadingExercises = false;
      notifyListeners();
    }
  }

  /// Carga todos los workouts
  Future<void> loadWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _workouts = await _datasource.getWorkouts();
      _dailyWorkout = await _datasource.getRandomWorkout();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresca los workouts
  Future<void> refreshWorkouts() async {
    _exercisesCache.clear();
    await loadWorkouts();
  }
}
