import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fit_motiv/features/routines/domain/entities/exercise.dart';

enum WorkoutState { idle, playing, paused, rest, completed }

class WorkoutSessionProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];
  int _currentIndex = 0;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _totalDurationMinutes = 0;
  Timer? _timer;
  WorkoutState _state = WorkoutState.idle;

  List<Exercise> get exercises => _exercises;
  int get currentIndex => _currentIndex;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  int get totalDurationMinutes => _totalDurationMinutes;
  WorkoutState get state => _state;
  Exercise get currentExercise => _exercises[_currentIndex];
  double get progress => _currentIndex / _exercises.length;
  double get timerProgress => _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

  void startWorkout(List<Exercise> exercises) {
    _exercises = exercises;
    _currentIndex = 0;
    _totalDurationMinutes = 0;
    _state = WorkoutState.playing;
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
