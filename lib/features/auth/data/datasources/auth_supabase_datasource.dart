import 'package:fit_motiv/core/network/base/base_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_datasource.dart';
import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/data/model/request/register_request.dart';
import 'package:fit_motiv/features/auth/data/model/response/login_response.dart';
import 'package:fit_motiv/features/auth/data/model/response/register_response.dart';

class AuthSupabaseDataSource extends BaseRemoteDataSource implements AuthDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    // Supabase supports only email/password for basic auth out-of-the-box.
    // Assuming the request provides an email in the username field.
    final response = await _supabase.auth.signInWithPassword(
      email: request.username, 
      password: request.password,
    );

    if (response.user == null) {
      throw Exception('Login failed: Invalid credentials');
    }

    return LoginResponse(
      accessToken: response.session?.accessToken ?? '',
      refreshToken: response.session?.refreshToken ?? '',
      tokenType: 'bearer',
    );
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _supabase.auth.signUp(
      email: request.email,
      password: request.password,
      data: {
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

    if (response.user == null) {
      throw Exception('Registration failed: No user returned');
    }

    return RegisterResponse(
      id: 0, // Placeholder as real ID is String UUID
      email: response.user!.email ?? '',
      password: request.password,
      username: request.username,
      fullName: request.fullName,
      fitnesGoal: request.fitnesGoal,
      bio: request.bio,
      activityLevel: request.activityLevel,
      age: request.age,
      height: request.height,
      weight: request.weight,
      isActive: true,
      isVerify: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      message: 'Registration successful. Please check your email.',
    );
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    await _supabase.auth.signOut();
    return {'message': 'Logged out successfully'};
  }

  @override
  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> passwordData) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: passwordData['newPassword']),
    );
    return {'message': 'Password updated successfully'};
  }

  @override
  Future<Map<String, dynamic>> verifyToken() async {
    final session = _supabase.auth.currentSession;
    if (session == null || session.isExpired) {
      throw Exception('Session expired or invalid');
    }
    return {'valid': true};
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    final response = await _supabase.auth.refreshSession();
    return {
      'token': response.session?.accessToken,
      'refreshToken': response.session?.refreshToken,
    };
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> emailData) async {
    await _supabase.auth.resetPasswordForEmail(emailData['email']);
    return {'message': 'Recovery email sent'};
  }

  @override
  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> resetData) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: resetData['newPassword']),
    );
    return {'message': 'Password reset successfully'};
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(Map<String, dynamic> verificationData) async {
    return {'message': 'Email verification handled by Supabase SDK'};
  }

  @override
  Future<Map<String, dynamic>> resendVerification(Map<String, dynamic> emailData) async {
    await _supabase.auth.resend(type: OtpType.signup, email: emailData['email']);
    return {'message': 'Verification email resent'};
  }

  @override
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    return {
      'id': user.id,
      'email': user.email,
      ...user.userMetadata ?? {},
    };
  }

  @override
  Future<Map<String, dynamic>> updateCurrentUserProfile(Map<String, dynamic> profileData) async {
    final response = await _supabase.auth.updateUser(
      UserAttributes(data: profileData),
    );
    return response.user?.userMetadata ?? {};
  }

  @override
  Future<Map<String, dynamic>> deleteCurrentUserAccount() async {
    throw UnimplementedError('Delete account requires administrative action');
  }

  @override
  Future<Map<String, dynamic>> reactivateCurrentUserAccount() async {
    throw UnimplementedError('Reactivate account not directly supported');
  }

  @override
  Future<Map<String, dynamic>> healthCheck() async {
    return {'status': 'ok', 'service': 'supabase'};
  }

  @override
  Future<Map<String, dynamic>> getHealthStatus() async {
    return {'status': 'healthy'};
  }
}
