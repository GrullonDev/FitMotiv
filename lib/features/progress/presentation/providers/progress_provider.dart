import 'package:flutter/material.dart';
import 'package:fit_motiv/features/progress/data/datasources/progress_supabase_datasource.dart';

/// Provider que gestiona el progreso del usuario
class ProgressProvider extends ChangeNotifier {
  ProgressProvider({required ProgressSupabaseDatasource datasource})
      : _datasource = datasource {
    loadAll();
  }

  final ProgressSupabaseDatasource _datasource;

  List<Map<String, dynamic>> _weightLog = [];
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get weightLog => _weightLog;
  List<Map<String, dynamic>> get goals => _goals;
  List<Map<String, dynamic>> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Peso más reciente
  double? get latestWeight {
    if (_weightLog.isEmpty) return null;
    return (_weightLog.first['weight'] as num?)?.toDouble();
  }

  /// Cambio de peso (diff entre el más reciente y el anterior)
  double? get weightChange {
    if (_weightLog.length < 2) return null;
    final latest = (_weightLog[0]['weight'] as num?)?.toDouble() ?? 0;
    final previous = (_weightLog[1]['weight'] as num?)?.toDouble() ?? 0;
    return latest - previous;
  }

  /// Total de sesiones de workout completadas
  int get totalSessions => _sessions.length;

  /// Total de calorías quemadas
  int get totalCalories {
    return _sessions.fold(0, (sum, s) => sum + ((s['calories_burned'] as int?) ?? 0));
  }

  /// Carga todo el progreso
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _datasource.getWeightLog(),
        _datasource.getGoals(),
        _datasource.getWorkoutSessions(),
      ]);
      _weightLog = results[0];
      _goals = results[1];
      _sessions = results[2];
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading progress: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async => loadAll();

  /// Registra un peso nuevo
  Future<bool> logWeight(double weight, {String notes = ''}) async {
    try {
      await _datasource.logWeight(weight, notes: notes);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Completa/deshabilita una meta
  Future<void> toggleGoal(String goalId, bool completed) async {
    try {
      await _datasource.toggleGoalCompleted(goalId, completed);
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
