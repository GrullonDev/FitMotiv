import 'package:dio/dio.dart';

class PlansApiDatasource {
  PlansApiDatasource({required Dio dio, required String baseUrl})
      : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String _baseUrl;

  String get _nutritionBase => '$_baseUrl/v1/nutrition';

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

  // --- Meal Plans ---

  Future<List<Map<String, dynamic>>> getMealPlans() async {
    final response = await _dio.get('$_nutritionBase/meals');
    return _extractList(response.data);
  }

  // --- Recipes ---

  Future<List<Map<String, dynamic>>> getRecipes({String? category}) async {
    final response = await _dio.get(
      '$_nutritionBase/recipes',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    return _extractList(response.data);
  }

  Future<Map<String, dynamic>?> getRandomRecipe() async {
    final response = await _dio.get('$_nutritionBase/recipes/random');
    return _extractData(response.data);
  }

  // --- Tips (not implemented in backend yet, return empty) ---

  Future<List<Map<String, dynamic>>> getTips() async {
    return [];
  }

  // --- Articles (not implemented in backend yet, return empty) ---

  Future<List<Map<String, dynamic>>> getArticles() async {
    return [];
  }

  // --- Water Log ---

  Future<int> getTodayWaterGlasses() async {
    final response = await _dio.get('$_nutritionBase/water');
    final data = _extractData(response.data);
    return (data['glasses'] as int?) ?? 0;
  }

  Future<void> updateWaterGlasses(int glasses) async {
    await _dio.put(
      '$_nutritionBase/water',
      data: {'glasses': glasses},
    );
  }
}
