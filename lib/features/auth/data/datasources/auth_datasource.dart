import 'package:fit_motiv/core/network/base/base_datasource.dart';
import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/data/model/request/register_request.dart';
import 'package:fit_motiv/features/auth/data/model/response/login_response.dart';
import 'package:fit_motiv/features/auth/data/model/response/register_response.dart';

/// Abstract datasource interface for authentication operations
/// This follows the Dependency Inversion Principle by defining abstractions
/// that concrete implementations must follow
/// Extends BaseDataSource to inherit common functionality
abstract class AuthDataSource extends BaseDataSource {
  // Authentication operations
  Future<RegisterResponse> register(RegisterRequest request);

  Future<LoginResponse> login(LoginRequest request);

  Future<Map<String, dynamic>> logout();

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> passwordData);

  Future<Map<String, dynamic>> verifyToken();

  Future<Map<String, dynamic>> refreshToken();

  // Password recovery operations
  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> emailData);

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> resetData);

  // Email verification operations
  Future<Map<String, dynamic>> verifyEmail(Map<String, dynamic> verificationData);

  Future<Map<String, dynamic>> resendVerification(Map<String, dynamic> emailData);

  // User profile operations
  Future<Map<String, dynamic>> getCurrentUserProfile();

  Future<Map<String, dynamic>> updateCurrentUserProfile(Map<String, dynamic> profileData);

  Future<Map<String, dynamic>> deleteCurrentUserAccount();

  Future<Map<String, dynamic>> reactivateCurrentUserAccount();

  // Health check operations
  Future<Map<String, dynamic>> healthCheck();

  Future<Map<String, dynamic>> getHealthStatus();
}
