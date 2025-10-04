import 'package:dartz/dartz.dart';

import '../../../../core/network/base/base_datasource.dart';
import '../../../../core/network/error_handlers/api_error_handler.dart';
import '../../../../core/network/services/api_service.dart';
import 'auth_datasource.dart';

/// Remote implementation of AuthDataSource
/// This class is responsible for handling remote authentication operations
/// Follows Single Responsibility Principle and Dependency Inversion Principle
/// Extends BaseRemoteDataSource to inherit common functionality
class AuthRemoteDataSource extends BaseRemoteDataSource implements AuthDataSource {
  final ApiService _apiService;

  AuthRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<ApiException, Map<String, dynamic>>> register(Map<String, dynamic> userData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.register(userData)).data),
      endpoint: '/auth/register',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> login(Map<String, dynamic> credentials) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.login(credentials)).data),
      endpoint: '/auth/login',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> logout() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.logout()).data),
      endpoint: '/auth/logout',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> changePassword(Map<String, dynamic> passwordData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.changePassword(passwordData)).data),
      endpoint: '/auth/change-password',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> verifyToken() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.verifyToken()).data),
      endpoint: '/auth/verify-token',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> refreshToken() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.refreshToken()).data),
      endpoint: '/auth/refresh',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> forgotPassword(Map<String, dynamic> emailData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.forgotPassword(emailData)).data),
      endpoint: '/auth/forgot-password',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> resetPassword(Map<String, dynamic> resetData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.resetPassword(resetData)).data),
      endpoint: '/auth/reset-password',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> verifyEmail(Map<String, dynamic> verificationData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.verifyEmail(verificationData)).data),
      endpoint: '/auth/verify-email',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> resendVerification(Map<String, dynamic> emailData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.resendVerification(emailData)).data),
      endpoint: '/auth/resend-verification',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> getCurrentUserProfile() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.getCurrentUserProfile()).data),
      endpoint: '/auth/me',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> updateCurrentUserProfile(Map<String, dynamic> profileData) async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.updateCurrentUserProfile(profileData)).data),
      endpoint: '/auth/me',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> deleteCurrentUserAccount() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.deleteCurrentUserAccount()).data),
      endpoint: '/auth/me',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> reactivateCurrentUserAccount() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.reactivateCurrentUserAccount()).data),
      endpoint: '/auth/me/reactivate',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> healthCheck() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.healthCheck()).data),
      endpoint: '/',
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> getHealthStatus() async {
    return await makeApiCall(
      () async => extractDataFromResponse((await _apiService.getHealthStatus()).data),
      endpoint: '/health',
    );
  }
}
