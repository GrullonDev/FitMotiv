import 'package:dio/dio.dart';
import 'package:fit_motiv/core/network/base/base_datasource.dart';
import 'package:fit_motiv/core/services/token_storage.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_datasource.dart';
import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/data/model/request/register_request.dart';
import 'package:fit_motiv/features/auth/data/model/response/login_response.dart';
import 'package:fit_motiv/features/auth/data/model/response/register_response.dart';

class AuthApiDataSource extends BaseRemoteDataSource implements AuthDataSource {
  AuthApiDataSource({
    required Dio dio,
    required String baseUrl,
    required TokenStorage tokenStorage,
  })  : _dio = dio,
        _baseUrl = baseUrl,
        _tokenStorage = tokenStorage;

  final Dio _dio;
  final String _baseUrl;
  final TokenStorage _tokenStorage;

  String get _authBase => '$_baseUrl/v1/auth';
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

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '$_authBase/login',
      data: {'email': request.username, 'password': request.password},
    );

    final data = _extractData(response.data);

    final accessToken = data['access_token'] as String? ?? '';
    final refreshToken = data['refresh_token'] as String? ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: data['token_type'] as String? ?? 'bearer',
    );
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _dio.post(
      '$_authBase/register',
      data: {
        'email': request.email,
        'password': request.password,
        'full_name': request.fullName,
        'username': request.username,
        'bio': request.bio,
        'fitness_goal': request.fitnesGoal,
        'activity_level': request.activityLevel,
        'age': request.age,
        'height': request.height,
        'weight': request.weight,
      },
    );

    final data = _extractData(response.data);

    return RegisterResponse.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    final accessToken = await _tokenStorage.getAccessToken();

    try {
      await _dio.post(
        '$_authBase/logout',
        data: {
          if (refreshToken != null) 'refresh_token': refreshToken,
        },
        options: Options(
          headers: {
            if (accessToken != null) 'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } finally {
      await _tokenStorage.clearTokens();
    }

    return {'message': 'Logged out successfully'};
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    final storedRefreshToken = await _tokenStorage.getRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      throw Exception('No refresh token available');
    }

    final response = await _dio.post(
      '$_authBase/refresh',
      data: {'refresh_token': storedRefreshToken},
    );

    final data = _extractData(response.data);

    final newAccessToken = data['access_token'] as String? ?? '';
    final newRefreshToken = data['refresh_token'] as String? ?? '';

    if (newAccessToken.isNotEmpty && newRefreshToken.isNotEmpty) {
      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
    }

    return data;
  }

  @override
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final response = await _dio.get('$_usersBase/me');
    return _extractData(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateCurrentUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    final response = await _dio.patch('$_usersBase/me', data: profileData);
    return _extractData(response.data);
  }

  @override
  Future<Map<String, dynamic>> verifyToken() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('No access token available');
    }
    final response = await _dio.get('$_usersBase/me');
    return {'valid': response.statusCode == 200};
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    Map<String, dynamic> passwordData,
  ) async {
    throw UnimplementedError('Change password not yet implemented in backend');
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(
    Map<String, dynamic> emailData,
  ) async {
    throw UnimplementedError('Forgot password not yet implemented in backend');
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    Map<String, dynamic> resetData,
  ) async {
    throw UnimplementedError('Reset password not yet implemented in backend');
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(
    Map<String, dynamic> verificationData,
  ) async {
    throw UnimplementedError('Email verification not yet implemented in backend');
  }

  @override
  Future<Map<String, dynamic>> resendVerification(
    Map<String, dynamic> emailData,
  ) async {
    throw UnimplementedError(
      'Resend verification not yet implemented in backend',
    );
  }

  @override
  Future<Map<String, dynamic>> deleteCurrentUserAccount() async {
    throw UnimplementedError('Delete account not yet implemented in backend');
  }

  @override
  Future<Map<String, dynamic>> reactivateCurrentUserAccount() async {
    throw UnimplementedError(
      'Reactivate account not yet implemented in backend',
    );
  }

  @override
  Future<Map<String, dynamic>> healthCheck() async {
    final response = await _dio.get('$_baseUrl/v1/health');
    return _extractData(response.data);
  }

  @override
  Future<Map<String, dynamic>> getHealthStatus() async {
    return healthCheck();
  }
}
