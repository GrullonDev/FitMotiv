import 'dart:async';

import 'package:fit_motiv/core/services/analytics_service.dart';
import 'package:fit_motiv/features/progress/data/datasources/progress_supabase_datasource.dart';
import 'package:fit_motiv/features/routines/domain/entities/exercise.dart';
import 'package:flutter/material.dart';

enum WorkoutState { idle, playing, paused, rest, completed }

class WorkoutSessionProvider extends ChangeNotifier {
  WorkoutSessionProvider({this.progressDatasource, this.analyticsService});

  /// Datasource opcional para persistir la sesión al completarse
  final ProgressSupabaseDatasource? progressDatasource;
  final AnalyticsService? analyticsService;

  List<Exercise> _exercises = [];
  int _currentIndex = 0;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _totalDurationMinutes = 0;
  int _totalCaloriesBurned = 0;
  String _workoutId = '';
  String _workoutName = '';
  Timer? _timer;
  WorkoutState _state = WorkoutState.idle;

  List<Exercise> get exercises => _exercises;
  int get currentIndex => _currentIndex;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  int get totalDurationMinutes => _totalDurationMinutes;
  int get totalCaloriesBurned => _totalCaloriesBurned;
  WorkoutState get state => _state;
  Exercise get currentExercise => _exercises[_currentIndex];
  double get progress => _currentIndex / _exercises.length;
  double get timerProgress => _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

  void startWorkout(List<Exercise> exercises, {String workoutId = '', String workoutName = ''}) {
    _exercises = exercises;
    _currentIndex = 0;
    _totalDurationMinutes = 0;
    _totalCaloriesBurned = 0;
    _workoutId = workoutId;
    _workoutName = workoutName;
    _state = WorkoutState.playing;

    // Log tracking
    analyticsService?.logWorkoutStarted(workoutName.isNotEmpty ? workoutName : 'Workout');

    _prepareCurrentExercise();
    notifyListeners();
  }

  void _prepareCurrentExercise() {
    final exercise = _exercises[_currentIndex];

    if (exercise.isTimeBased) {
      _remainingSeconds = exercise.seconds!;
      _totalSeconds = exercise.seconds!;
    } else {
      // For reps, we set a "suggested" time (e.g., 4s per rep) to help with rhythm
      final reps = exercise.reps ?? 10;
      _remainingSeconds = reps * 4;
      _totalSeconds = reps * 4;
    }

    if (_state == WorkoutState.playing) {
      _totalDurationMinutes += _totalSeconds ~/ 60;
      // Estimar calorías: ~5 cal/min para ejercicio moderado
      _totalCaloriesBurned += (_totalSeconds ~/ 60) * 5;
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        nextExercise();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void togglePause() {
    if (_state == WorkoutState.playing) {
      _state = WorkoutState.paused;
      _stopTimer();
    } else if (_state == WorkoutState.paused) {
      _state = WorkoutState.playing;
      if (currentExercise.isTimeBased) {
        _startTimer();
      }
    }
    notifyListeners();
  }

  void nextExercise() {
    if (_state == WorkoutState.playing && _currentIndex < _exercises.length - 1) {
      _state = WorkoutState.rest;
      _remainingSeconds = 15; // 15 seconds rest
      _totalSeconds = 15;
      _startTimer();
    } else if (_currentIndex < _exercises.length - 1 || _state == WorkoutState.rest) {
      if (_state == WorkoutState.rest) {
        _currentIndex++;
      }
      _state = WorkoutState.playing;
      _prepareCurrentExercise();
    } else {
      _state = WorkoutState.completed;
      _stopTimer();
      // Persistir la sesión completa en Supabase
      _logCompletedSession();
    }
    notifyListeners();
  }

  void previousExercise() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _prepareCurrentExercise();
      notifyListeners();
    }
  }

  /// Persiste la sesión completada en la base de datos
  Future<void> _logCompletedSession() async {
    if (progressDatasource == null) return;

    try {
      await progressDatasource!.logWorkoutSession(
        workoutId: _workoutId.isNotEmpty ? _workoutId : 'manual',
        workoutName: _workoutName.isNotEmpty ? _workoutName : 'Workout',
        durationMinutes: _totalDurationMinutes > 0 ? _totalDurationMinutes : 1,
        caloriesBurned: _totalCaloriesBurned > 0 ? _totalCaloriesBurned : 10,
      );
      debugPrint('✅ Workout session logged to Supabase');
    } catch (e) {
      debugPrint('❌ Error logging workout session: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
