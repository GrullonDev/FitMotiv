import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get analyticsObserver => FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> _safeLog(Future<void> Function() logAction) async {
    try {
      await logAction();
    } catch (e) {
      debugPrint('📊 Analytics log failed: $e');
    }
  }

  Future<void> logAppOpen() async {
    await _safeLog(() => _analytics.logAppOpen());
  }

  Future<void> logLogin(String loginMethod) async {
    await _safeLog(() => _analytics.logLogin(loginMethod: loginMethod));
  }

  Future<void> logSignUp(String signUpMethod) async {
    await _safeLog(() => _analytics.logSignUp(signUpMethod: signUpMethod));
  }

  Future<void> logScreenView({required String screenName}) async {
    await _safeLog(() => _analytics.logScreenView(screenName: screenName));
  }

  Future<void> logWorkoutStarted(String workoutName) async {
    await _safeLog(() => _analytics.logEvent(name: 'workout_started', parameters: {'workout_name': workoutName}));
  }

  Future<void> logRecipeViewed(String recipeTitle) async {
    await _safeLog(() => _analytics.logEvent(name: 'recipe_viewed', parameters: {'recipe_title': recipeTitle}));
  }

  Future<void> logWeightRegistered(double weight) async {
    await _safeLog(() => _analytics.logEvent(name: 'weight_registered', parameters: {'weight': weight}));
  }

  Future<void> logGoalCreated(String goalTitle) async {
    await _safeLog(() => _analytics.logEvent(name: 'goal_created', parameters: {'goal_title': goalTitle}));
  }
}

