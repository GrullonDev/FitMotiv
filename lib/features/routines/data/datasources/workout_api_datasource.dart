import 'package:dio/dio.dart';

class WorkoutApiDatasource {
  WorkoutApiDatasource({required Dio dio, required String baseUrl})
      : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String _baseUrl;

  String get _workoutsBase => '$_baseUrl/v1/workouts';

  List<Map<String, dynamic>> _extractList(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is List) return List<Map<String, dynamic>>.from(data);
    }
    if (responseData is List) return List<Map<String, dynamic>>.from(responseData);
    return [];
  }

  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final response = await _dio.get(_workoutsBase);
    return _extractList(response.data);
  }

  Future<List<Map<String, dynamic>>> getWorkoutsByCategory(String category) async {
    final response = await _dio.get(
      _workoutsBase,
      queryParameters: {'category': category},
    );
    return _extractList(response.data);
  }

  Future<Map<String, dynamic>?> getRandomWorkout() async {
    final response = await _dio.get('$_workoutsBase/random');
    return _extractData(response.data);
  }

  Future<List<Map<String, dynamic>>> getExercises(String workoutId) async {
    final response = await _dio.get('$_workoutsBase/$workoutId');
    final data = _extractData(response.data);
    final exercises = data['exercises'];
    if (exercises is List) return List<Map<String, dynamic>>.from(exercises);
    return [];
  }

  Future<Map<String, dynamic>?> getWorkoutById(String id) async {
    final response = await _dio.get('$_workoutsBase/$id');
    return _extractData(response.data);
  }
}
