import 'package:dio/dio.dart';

class ProgressApiDatasource {
  ProgressApiDatasource({required Dio dio, required String baseUrl})
      : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String _baseUrl;

  String get _progressBase => '$_baseUrl/v1/progress';

  List<Map<String, dynamic>> _extractList(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is List) return List<Map<String, dynamic>>.from(data);
    }
    if (responseData is List) return List<Map<String, dynamic>>.from(responseData);
    return [];
  }

  // --- Weight Log ---

  Future<List<Map<String, dynamic>>> getWeightLog() async {
    try {
      final response = await _dio.get('$_progressBase/weight');
      return _extractList(response.data);
    } catch (_) {
      return [];
    }
  }

  Future<void> logWeight(double weight, {String notes = ''}) async {
    await _dio.post(
      '$_progressBase/weight',
      data: {'weight': weight, 'notes': notes},
    );
  }

  // --- Goals ---

  Future<List<Map<String, dynamic>>> getGoals() async {
    try {
      final response = await _dio.get('$_progressBase/goals');
      return _extractList(response.data);
    } catch (_) {
      return [];
    }
  }

  Future<void> createGoal({
    required String title,
    String description = '',
    double targetValue = 0,
    String unit = '',
    String icon = 'flag',
  }) async {
    await _dio.post(
      '$_progressBase/goals',
      data: {
        'title': title,
        'description': description,
        'target_value': targetValue,
        'unit': unit,
        'icon': icon,
      },
    );
  }

  Future<void> toggleGoalCompleted(String goalId, bool completed) async {
    await _dio.patch('$_progressBase/goals/$goalId');
  }

  // --- Workout Sessions ---

  Future<List<Map<String, dynamic>>> getWorkoutSessions() async {
    try {
      final response = await _dio.get('$_progressBase/sessions');
      return _extractList(response.data);
    } catch (_) {
      return [];
    }
  }

  Future<void> logWorkoutSession({
    required String workoutId,
    required String workoutName,
    required int durationMinutes,
    required int caloriesBurned,
  }) async {
    await _dio.post(
      '$_progressBase/sessions',
      data: {
        'workout_id': workoutId,
        'workout_name': workoutName,
        'duration_minutes': durationMinutes,
        'calories_burned': caloriesBurned,
      },
    );
  }
}
