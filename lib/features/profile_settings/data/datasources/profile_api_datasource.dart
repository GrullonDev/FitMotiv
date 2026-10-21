import 'package:dio/dio.dart';

class ProfileApiDatasource {
  ProfileApiDatasource({required Dio dio, required String baseUrl})
      : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String _baseUrl;

  String get _usersBase => '$_baseUrl/v1/users';

  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    return {};
  }

  Future<Map<String, dynamic>> getCurrentProfile() async {
    final response = await _dio.get('$_usersBase/me');
    return _extractData(response.data);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.patch('$_usersBase/me', data: data);
  }

  Future<String> uploadAvatar(dynamic file) async {
    throw UnimplementedError(
      'Avatar upload not yet implemented in custom backend',
    );
  }
}
