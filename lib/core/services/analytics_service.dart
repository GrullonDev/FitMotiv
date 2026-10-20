import 'package:flutter/foundation.dart';

class AnalyticsService {
  Future<void> logAppOpen() async {
    debugPrint('Analytics: app_open');
  }

  Future<void> logLogin(String loginMethod) async {
    debugPrint('Analytics: login ($loginMethod)');
  }

  Future<void> logSignUp(String signUpMethod) async {
    debugPrint('Analytics: sign_up ($signUpMethod)');
  }

  Future<void> logScreenView({required String screenName}) async {
    debugPrint('Analytics: screen_view ($screenName)');
  }

  Future<void> logWorkoutStarted(String workoutName) async {
    debugPrint('Analytics: workout_started ($workoutName)');
  }

  Future<void> logRecipeViewed(String recipeTitle) async {
    debugPrint('Analytics: recipe_viewed ($recipeTitle)');
  }

  Future<void> logWeightRegistered(double weight) async {
    debugPrint('Analytics: weight_registered ($weight)');
  }

  Future<void> logGoalCreated(String goalTitle) async {
    debugPrint('Analytics: goal_created ($goalTitle)');
  }
}
