import 'package:flutter/material.dart';
import 'package:fit_motiv/features/routines/data/datasources/workout_supabase_datasource.dart';

/// Provider que gestiona los workouts desde Supabase
class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({required WorkoutSupabaseDatasource datasource})
      : _datasource = datasource {
    loadWorkouts();
  }

  final WorkoutSupabaseDatasource _datasource;

  List<Map<String, dynamic>> _workouts = [];
  Map<String, dynamic>? _dailyWorkout;
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get workouts => _workouts;
  Map<String, dynamic>? get dailyWorkout => _dailyWorkout;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Lista de workouts filtrada por categoría
  List<Map<String, dynamic>> getByCategory(String category) {
    if (category == 'All') return _workouts;
    return _workouts.where((w) => w['category'] == category).toList();
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
    await loadWorkouts();
  }
}
