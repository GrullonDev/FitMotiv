import 'package:fit_motiv/core/network/base/base_datasource.dart';
import 'package:fit_motiv/core/network/services/api_service.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_datasource.dart';
import 'package:fit_motiv/features/auth/data/model/request/register_request.dart';
import 'package:fit_motiv/features/auth/data/model/response/register_response.dart';

class AuthRemoteDataSource extends BaseRemoteDataSource
    implements AuthDataSource {

  AuthRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;
  final ApiService _apiService;

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _apiService.register(request.toJson());
    final data = extractDataFromResponse(response.data);
    return RegisterResponse.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> credentials) async {
    final response = await _apiService.login(credentials);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    final response = await _apiService.logout();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    Map<String, dynamic> passwordData,
  ) async {
    final response = await _apiService.changePassword(passwordData);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> verifyToken() async {
    final response = await _apiService.verifyToken();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    final response = await _apiService.refreshToken();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(
    Map<String, dynamic> emailData,
  ) async {
    final response = await _apiService.forgotPassword(emailData);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    Map<String, dynamic> resetData,
  ) async {
    final response = await _apiService.resetPassword(resetData);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(
    Map<String, dynamic> verificationData,
  ) async {
    final response = await _apiService.verifyEmail(verificationData);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> resendVerification(
    Map<String, dynamic> emailData,
  ) async {
    final response = await _apiService.resendVerification(emailData);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final response = await _apiService.getCurrentUserProfile();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateCurrentUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    final response = await _apiService.updateCurrentUserProfile(profileData);
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> deleteCurrentUserAccount() async {
    final response = await _apiService.deleteCurrentUserAccount();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> reactivateCurrentUserAccount() async {
    final response = await _apiService.reactivateCurrentUserAccount();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> healthCheck() async {
    final response = await _apiService.healthCheck();
    return extractDataFromResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> getHealthStatus() async {
    final response = await _apiService.getHealthStatus();
    return extractDataFromResponse(response.data);
  }
}
