import 'package:dartz/dartz.dart';
import 'package:fit_motiv/core/network/base/base_repository.dart';
import 'package:fit_motiv/core/network/error_handlers/api_error_handler.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_datasource.dart';
import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/data/model/request/register_request.dart';
import 'package:fit_motiv/features/auth/data/model/response/login_response.dart';
import 'package:fit_motiv/features/auth/data/model/response/register_response.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;
  final AuthDataSource _remoteDataSource;

  @override
  Future<Either<ApiException, RegisterResponse>> register(RegisterRequest request) async {
    try {
      final result = await _remoteDataSource.register(request);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, LoginResponse>> login(LoginRequest request) async {
    try {
      final result = await _remoteDataSource.login(request);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> logout() async {
    try {
      final result = await _remoteDataSource.logout();
      // Handle successful logout with token clearing
      return await handleLogoutResult(Right(result));
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> changePassword(Map<String, dynamic> passwordData) async {
    try {
      final result = await _remoteDataSource.changePassword(passwordData);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> verifyToken() async {
    try {
      final result = await _remoteDataSource.verifyToken();
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> refreshToken() async {
    try {
      final result = await _remoteDataSource.refreshToken();
      // Handle successful token refresh
      return await handleAuthenticationResult(Right(result));
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> forgotPassword(Map<String, dynamic> emailData) async {
    try {
      final result = await _remoteDataSource.forgotPassword(emailData);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> resetPassword(Map<String, dynamic> resetData) async {
    try {
      final result = await _remoteDataSource.resetPassword(resetData);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> verifyEmail(Map<String, dynamic> verificationData) async {
    try {
      final result = await _remoteDataSource.verifyEmail(verificationData);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> resendVerification(Map<String, dynamic> emailData) async {
    try {
      final result = await _remoteDataSource.resendVerification(emailData);
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> getCurrentUserProfile() async {
    try {
      final result = await _remoteDataSource.getCurrentUserProfile();
      // Handle successful profile retrieval with caching
      return await handleProfileResult(Right(result));
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> updateCurrentUserProfile(Map<String, dynamic> profileData) async {
    try {
      final result = await _remoteDataSource.updateCurrentUserProfile(profileData);
      // Handle successful profile update with caching
      return await handleProfileResult(Right(result));
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> deleteCurrentUserAccount() async {
    try {
      final result = await _remoteDataSource.deleteCurrentUserAccount();
      // Handle successful account deletion with cleanup
      return await handleLogoutResult(Right(result));
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> reactivateCurrentUserAccount() async {
    try {
      final result = await _remoteDataSource.reactivateCurrentUserAccount();
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> healthCheck() async {
    try {
      final result = await _remoteDataSource.healthCheck();
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }

  @override
  Future<Either<ApiException, Map<String, dynamic>>> getHealthStatus() async {
    try {
      final result = await _remoteDataSource.getHealthStatus();
      return Right(result);
    } catch (error, stackTrace) {
      final apiException = ApiErrorHandler.handleGeneralError(error, stackTrace);
      return Left(apiException);
    }
  }
}
