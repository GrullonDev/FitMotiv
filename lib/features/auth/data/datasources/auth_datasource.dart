import 'package:dartz/dartz.dart';

import '../../../../core/network/base/base_datasource.dart';
import '../../../../core/network/error_handlers/api_error_handler.dart';

/// Abstract datasource interface for authentication operations
/// This follows the Dependency Inversion Principle by defining abstractions
/// that concrete implementations must follow
/// Extends BaseDataSource to inherit common functionality
abstract class AuthDataSource extends BaseDataSource {
  // Authentication operations
  Future<Either<ApiException, Map<String, dynamic>>> register(Map<String, dynamic> userData);

  Future<Either<ApiException, Map<String, dynamic>>> login(Map<String, dynamic> credentials);

  Future<Either<ApiException, Map<String, dynamic>>> logout();

  Future<Either<ApiException, Map<String, dynamic>>> changePassword(Map<String, dynamic> passwordData);

  Future<Either<ApiException, Map<String, dynamic>>> verifyToken();

  Future<Either<ApiException, Map<String, dynamic>>> refreshToken();

  // Password recovery operations
  Future<Either<ApiException, Map<String, dynamic>>> forgotPassword(Map<String, dynamic> emailData);

  Future<Either<ApiException, Map<String, dynamic>>> resetPassword(Map<String, dynamic> resetData);

  // Email verification operations
  Future<Either<ApiException, Map<String, dynamic>>> verifyEmail(Map<String, dynamic> verificationData);

  Future<Either<ApiException, Map<String, dynamic>>> resendVerification(Map<String, dynamic> emailData);

  // User profile operations
  Future<Either<ApiException, Map<String, dynamic>>> getCurrentUserProfile();

  Future<Either<ApiException, Map<String, dynamic>>> updateCurrentUserProfile(Map<String, dynamic> profileData);

  Future<Either<ApiException, Map<String, dynamic>>> deleteCurrentUserAccount();

  Future<Either<ApiException, Map<String, dynamic>>> reactivateCurrentUserAccount();

  // Health check operations
  Future<Either<ApiException, Map<String, dynamic>>> healthCheck();

  Future<Either<ApiException, Map<String, dynamic>>> getHealthStatus();
}
