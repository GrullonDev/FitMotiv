import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

/// Generic API service that handles all HTTP requests for the application
/// This service can be used across all modules (auth, fitness, nutrition, etc.)
/// Follows Single Responsibility Principle by focusing only on HTTP communication
class ApiService {
  ApiService({required Dio dio, required this.baseUrl}) : _dio = dio {
    _setupInterceptors();
  }
  final Dio _dio;
  final String baseUrl;

  /// Configure Dio interceptors for API communication
  void _setupInterceptors() {
    final cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
        onError: (error, handler) {
          // Log error for debugging purposes
          print('API Error: ${error.message}'); // ignore: avoid_print
          handler.next(error);
        },
      ),
    );
  }

  // ============================================================================
  // AUTHENTICATION ENDPOINTS
  // ============================================================================

  /// POST /auth/register - Register a new user
  Future<Response> register(Map<String, dynamic> json) async {
    return await _dio.post('$baseUrl/default/register', data: json);
  }

  /// POST /auth/login - Login user
  Future<Response> login(Map<String, dynamic> json) async {
    return await _dio.post('$baseUrl/default/login', data: json);
  }

  /// POST /auth/logout - Logout user
  Future<Response> logout() async {
    return await _dio.post('$baseUrl/default/logout');
  }

  /// POST /auth/change-password - Change user password
  Future<Response> changePassword(Map<String, dynamic> json) async {
    return await _dio.post('$baseUrl/default/change-password', data: json);
  }

  /// GET /auth/verify-token - Verify authentication token
  Future<Response> verifyToken() async {
    return await _dio.get('$baseUrl/default/verify-token');
  }

  /// POST /auth/refresh - Refresh authentication token
  Future<Response> refreshToken() async {
    return await _dio.post('$baseUrl/default/refresh');
  }

  /// POST /auth/forgot-password - Request password reset
  Future<Response> forgotPassword(Map<String, dynamic> emailData) async {
    return await _dio.post('$baseUrl/default/forgot-password', data: emailData);
  }

  /// POST /auth/reset-password - Reset password with token
  Future<Response> resetPassword(Map<String, dynamic> resetData) async {
    return await _dio.post('$baseUrl/default/reset-password', data: resetData);
  }

  /// POST /auth/verify-email - Verify email address
  Future<Response> verifyEmail(Map<String, dynamic> verificationData) async {
    return await _dio.post('$baseUrl/default/verify-email', data: verificationData);
  }

  /// POST /auth/resend-verification - Resend email verification
  Future<Response> resendVerification(Map<String, dynamic> emailData) async {
    return await _dio.post('$baseUrl/default/resend-verification', data: emailData);
  }

  // ============================================================================
  // USER PROFILE ENDPOINTS
  // ============================================================================

  /// GET /auth/me - Get current user profile
  Future<Response> getCurrentUserProfile() async {
    return await _dio.get('$baseUrl/default/me');
  }

  /// PUT /auth/me - Update current user profile
  Future<Response> updateCurrentUserProfile(Map<String, dynamic> profileData) async {
    return await _dio.put('$baseUrl/default/me', data: profileData);
  }

  /// DELETE /auth/me - Delete current user account
  Future<Response> deleteCurrentUserAccount() async {
    return await _dio.delete('$baseUrl/default/me');
  }

  /// POST /auth/me/reactivate - Reactivate current user account
  Future<Response> reactivateCurrentUserAccount() async {
    return await _dio.post('$baseUrl/default/me/reactivate');
  }

  // ============================================================================
  // FITNESS/WORKOUT ENDPOINTS
  // ============================================================================

  /// GET /workouts - Get user workouts
  Future<Response> getWorkouts({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/workouts', queryParameters: queryParams);
  }

  /// POST /workouts - Create new workout
  Future<Response> createWorkout(Map<String, dynamic> workoutData) async {
    return await _dio.post('$baseUrl/workouts', data: workoutData);
  }

  /// GET /workouts/{id} - Get specific workout
  Future<Response> getWorkout(String workoutId) async {
    return await _dio.get('$baseUrl/workouts/$workoutId');
  }

  /// PUT /workouts/{id} - Update workout
  Future<Response> updateWorkout(String workoutId, Map<String, dynamic> workoutData) async {
    return await _dio.put('$baseUrl/workouts/$workoutId', data: workoutData);
  }

  /// DELETE /workouts/{id} - Delete workout
  Future<Response> deleteWorkout(String workoutId) async {
    return await _dio.delete('$baseUrl/workouts/$workoutId');
  }

  /// GET /exercises - Get exercises library
  Future<Response> getExercises({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/exercises', queryParameters: queryParams);
  }

  /// POST /workouts/{id}/sessions - Start workout session
  Future<Response> startWorkoutSession(String workoutId, Map<String, dynamic> sessionData) async {
    return await _dio.post('$baseUrl/workouts/$workoutId/sessions', data: sessionData);
  }

  /// PUT /workout-sessions/{id} - Update workout session
  Future<Response> updateWorkoutSession(String sessionId, Map<String, dynamic> sessionData) async {
    return await _dio.put('$baseUrl/workout-sessions/$sessionId', data: sessionData);
  }

  /// POST /workout-sessions/{id}/complete - Complete workout session
  Future<Response> completeWorkoutSession(String sessionId, Map<String, dynamic> sessionData) async {
    return await _dio.post('$baseUrl/workout-sessions/$sessionId/complete', data: sessionData);
  }

  // ============================================================================
  // NUTRITION ENDPOINTS
  // ============================================================================

  /// GET /nutrition/meals - Get user meals
  Future<Response> getMeals({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/nutrition/meals', queryParameters: queryParams);
  }

  /// POST /nutrition/meals - Create new meal
  Future<Response> createMeal(Map<String, dynamic> mealData) async {
    return await _dio.post('$baseUrl/nutrition/meals', data: mealData);
  }

  /// GET /nutrition/foods - Search foods database
  Future<Response> searchFoods({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/nutrition/foods', queryParameters: queryParams);
  }

  /// GET /nutrition/goals - Get nutrition goals
  Future<Response> getNutritionGoals() async {
    return await _dio.get('$baseUrl/nutrition/goals');
  }

  /// PUT /nutrition/goals - Update nutrition goals
  Future<Response> updateNutritionGoals(Map<String, dynamic> goalsData) async {
    return await _dio.put('$baseUrl/nutrition/goals', data: goalsData);
  }

  // ============================================================================
  // PROGRESS TRACKING ENDPOINTS
  // ============================================================================

  /// GET /progress/weight - Get weight progress
  Future<Response> getWeightProgress({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/progress/weight', queryParameters: queryParams);
  }

  /// POST /progress/weight - Log weight entry
  Future<Response> logWeight(Map<String, dynamic> weightData) async {
    return await _dio.post('$baseUrl/progress/weight', data: weightData);
  }

  /// GET /progress/measurements - Get body measurements
  Future<Response> getBodyMeasurements({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/progress/measurements', queryParameters: queryParams);
  }

  /// POST /progress/measurements - Log body measurements
  Future<Response> logBodyMeasurements(Map<String, dynamic> measurementData) async {
    return await _dio.post('$baseUrl/progress/measurements', data: measurementData);
  }

  /// GET /progress/photos - Get progress photos
  Future<Response> getProgressPhotos({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/progress/photos', queryParameters: queryParams);
  }

  /// POST /progress/photos - Upload progress photo
  Future<Response> uploadProgressPhoto(FormData photoData) async {
    return await _dio.post('$baseUrl/progress/photos', data: photoData);
  }

  // ============================================================================
  // SOCIAL/COMMUNITY ENDPOINTS
  // ============================================================================

  /// GET /social/feed - Get social feed
  Future<Response> getSocialFeed({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/social/feed', queryParameters: queryParams);
  }

  /// POST /social/posts - Create new post
  Future<Response> createPost(Map<String, dynamic> postData) async {
    return await _dio.post('$baseUrl/social/posts', data: postData);
  }

  /// POST /social/posts/{id}/like - Like a post
  Future<Response> likePost(String postId) async {
    return await _dio.post('$baseUrl/social/posts/$postId/like');
  }

  /// DELETE /social/posts/{id}/like - Unlike a post
  Future<Response> unlikePost(String postId) async {
    return await _dio.delete('$baseUrl/social/posts/$postId/like');
  }

  /// GET /social/friends - Get friends list
  Future<Response> getFriends({Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl/social/friends', queryParameters: queryParams);
  }

  /// POST /social/friends/request - Send friend request
  Future<Response> sendFriendRequest(Map<String, dynamic> requestData) async {
    return await _dio.post('$baseUrl/social/friends/request', data: requestData);
  }

  // ============================================================================
  // UTILITY ENDPOINTS
  // ============================================================================

  /// GET / - Health check or root endpoint
  Future<Response> healthCheck() async {
    return await _dio.get('$baseUrl/');
  }

  /// GET /health - Application health status
  Future<Response> getHealthStatus() async {
    return await _dio.get('$baseUrl/health');
  }

  // ============================================================================
  // GENERIC HTTP METHODS
  // ============================================================================

  /// Generic GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get('$baseUrl$endpoint', queryParameters: queryParams);
  }

  /// Generic POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post('$baseUrl$endpoint', data: data);
  }

  /// Generic PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put('$baseUrl$endpoint', data: data);
  }

  /// Generic PATCH request
  Future<Response> patch(String endpoint, {dynamic data}) async {
    return await _dio.patch('$baseUrl$endpoint', data: data);
  }

  /// Generic DELETE request
  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await _dio.delete('$baseUrl$endpoint', data: data);
  }

  // ============================================================================
  // TOKEN MANAGEMENT
  // ============================================================================

  /// Add authorization header to requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization header
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Get current auth token
  String? get authToken {
    final authHeader = _dio.options.headers['Authorization'];
    if (authHeader is String && authHeader.startsWith('Bearer ')) {
      return authHeader.substring(7);
    }
    return null;
  }
}
