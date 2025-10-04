import 'package:dartz/dartz.dart';

import '../../../../core/network/base/base_repository.dart';
import '../../../../core/network/error_handlers/api_error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

/// Implementation of AuthRepository
/// This class follows the Repository Pattern and acts as a bridge between
/// the domain layer and data layer, implementing business logic and data transformation
/// Follows Single Responsibility Principle and Dependency Inversion Principle
/// Extends BaseRepositoryImpl to inherit common functionality
class AuthRepositoryImpl extends BaseRepositoryImpl implements AuthRepository {
  final AuthDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<ApiException, Map<String, dynamic>>> register(
    Map<String, dynamic> userData,
  ) async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.register(userData),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> login(
    Map<String, dynamic> credentials,
  ) async {
    final result = await handleRepositoryCall(
      () async => await _remoteDataSource.login(credentials),
    );
    
    // Handle successful login with token management
    return await handleAuthenticationResult(result);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> logout() async {
    final result = await handleRepositoryCall(
      () async => await _remoteDataSource.logout(),
    );
    
    // Handle successful logout with token clearing
    return await handleLogoutResult(result);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> changePassword(
    Map<String, dynamic> passwordData,
  ) async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.changePassword(passwordData),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> verifyToken() async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.verifyToken(),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> refreshToken() async {
    final result = await handleRepositoryCall(
      () async => await _remoteDataSource.refreshToken(),
    );
    
    // Handle successful token refresh
    return await handleAuthenticationResult(result);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> forgotPassword(
    Map<String, dynamic> emailData,
  ) async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.forgotPassword(emailData),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> resetPassword(
    Map<String, dynamic> resetData,
  ) async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.resetPassword(resetData),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> verifyEmail(
    Map<String, dynamic> verificationData,
  ) async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.verifyEmail(verificationData),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> resendVerification(
    Map<String, dynamic> emailData,
  ) async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.resendVerification(emailData),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> getCurrentUserProfile() async {
    final result = await handleRepositoryCall(
      () async => await _remoteDataSource.getCurrentUserProfile(),
    );
    
    // Handle successful profile retrieval with caching
    return await handleProfileResult(result);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> updateCurrentUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    final result = await handleRepositoryCall(
      () async => await _remoteDataSource.updateCurrentUserProfile(profileData),
    );
    
    // Handle successful profile update with caching
    return await handleProfileResult(result);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> deleteCurrentUserAccount() async {
    final result = await handleRepositoryCall(
      () async => await _remoteDataSource.deleteCurrentUserAccount(),
    );
    
    // Handle successful account deletion with cleanup
    return await handleLogoutResult(result);
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> reactivateCurrentUserAccount() async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.reactivateCurrentUserAccount(),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> healthCheck() async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.healthCheck(),
    );
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> getHealthStatus() async {
    return await handleRepositoryCall(
      () async => await _remoteDataSource.getHealthStatus(),
    );
  }
}