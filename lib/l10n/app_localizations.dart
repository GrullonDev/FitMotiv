import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @minRead.
  ///
  /// In en, this message translates to:
  /// **'min read'**
  String get minRead;

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'SEC'**
  String get sec;

  /// No description provided for @secShort.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secShort;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Wait!'**
  String get wait;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @resendVerification.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendVerification;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @fitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goal'**
  String get fitnessGoal;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgotYourPassword;

  /// No description provided for @forgotPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you instructions to reset your password.'**
  String get forgotPasswordInstructions;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @welcomeToFitMotiv.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FitMotiv!'**
  String get welcomeToFitMotiv;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your journey to a healthier, happier you starts here. Get personalized plans, track your progress, and join our supportive community.'**
  String get onboardingDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// No description provided for @joinFitMotivSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join FitMotiv and start your fitness journey today'**
  String get joinFitMotivSubtitle;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating Account...'**
  String get creatingAccount;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created!'**
  String get accountCreated;

  /// No description provided for @accountCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FitMotiv! Your account has been successfully created. You can now start your fitness journey.'**
  String get accountCreatedMessage;

  /// No description provided for @dontHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccountPrefix;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @routines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get routines;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @workoutOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Workout of the Day'**
  String get workoutOfTheDay;

  /// No description provided for @quoteOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Quote of the Day'**
  String get quoteOfTheDay;

  /// No description provided for @dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallenge;

  /// No description provided for @personalRecords.
  ///
  /// In en, this message translates to:
  /// **'Personal Records'**
  String get personalRecords;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @mealPlans.
  ///
  /// In en, this message translates to:
  /// **'Meal Plans'**
  String get mealPlans;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @personalizedMealPlans.
  ///
  /// In en, this message translates to:
  /// **'Personalized Meal Plans'**
  String get personalizedMealPlans;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @preparation.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get preparation;

  /// No description provided for @waterTracker.
  ///
  /// In en, this message translates to:
  /// **'Water Tracker'**
  String get waterTracker;

  /// No description provided for @waterTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Target: 8 glasses'**
  String get waterTarget;

  /// No description provided for @waterReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached! Stay hydrated.'**
  String get waterReached;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @proteins.
  ///
  /// In en, this message translates to:
  /// **'Proteins'**
  String get proteins;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fats;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// No description provided for @searchRecipes.
  ///
  /// In en, this message translates to:
  /// **'Search recipes...'**
  String get searchRecipes;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @recommendedArticles.
  ///
  /// In en, this message translates to:
  /// **'Recommended Articles'**
  String get recommendedArticles;

  /// No description provided for @didYouKnow.
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get didYouKnow;

  /// No description provided for @highProtein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get highProtein;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @keto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get keto;

  /// No description provided for @easyRecipes.
  ///
  /// In en, this message translates to:
  /// **'Easy Recipes'**
  String get easyRecipes;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @noRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes'**
  String get noRecipes;

  /// No description provided for @dailyUpdatesHere.
  ///
  /// In en, this message translates to:
  /// **'Daily updates here'**
  String get dailyUpdatesHere;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'{count} serv'**
  String servings(int count);

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'exercises'**
  String get exercises;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'series'**
  String get series;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now!'**
  String get startNow;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get rest;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'PACE'**
  String get pace;

  /// No description provided for @workoutSettings.
  ///
  /// In en, this message translates to:
  /// **'Workout Settings'**
  String get workoutSettings;

  /// No description provided for @exerciseDuration.
  ///
  /// In en, this message translates to:
  /// **'Exercise Duration'**
  String get exerciseDuration;

  /// No description provided for @restDuration.
  ///
  /// In en, this message translates to:
  /// **'Rest Duration'**
  String get restDuration;

  /// No description provided for @quitWorkout.
  ///
  /// In en, this message translates to:
  /// **'Quit Workout?'**
  String get quitWorkout;

  /// No description provided for @quitWorkoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your progress for this session will be lost.'**
  String get quitWorkoutConfirm;

  /// No description provided for @getReadyForNext.
  ///
  /// In en, this message translates to:
  /// **'Get ready for next'**
  String get getReadyForNext;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noRoutinesYet.
  ///
  /// In en, this message translates to:
  /// **'No routines yet'**
  String get noRoutinesYet;

  /// No description provided for @noRoutinesDescription.
  ///
  /// In en, this message translates to:
  /// **'Workouts will appear here once you create them\nor they are added to the database.'**
  String get noRoutinesDescription;

  /// No description provided for @noWorkoutsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No workouts in this category'**
  String get noWorkoutsInCategory;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @defaultExerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'Focus on your form and keep a steady pace.'**
  String get defaultExerciseDescription;

  /// No description provided for @defaultRoutineDescription.
  ///
  /// In en, this message translates to:
  /// **'This routine is designed to help you reach your goals with a mix of targeted exercises.'**
  String get defaultRoutineDescription;

  /// No description provided for @cardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get cardio;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @noWorkoutOfDay.
  ///
  /// In en, this message translates to:
  /// **'No workout of the day'**
  String get noWorkoutOfDay;

  /// No description provided for @addWorkoutsToDatabase.
  ///
  /// In en, this message translates to:
  /// **'Add workouts to the database'**
  String get addWorkoutsToDatabase;

  /// No description provided for @defaultWorkoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Get your body moving with this workout.'**
  String get defaultWorkoutDescription;

  /// No description provided for @noRecipesYet.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get noRecipesYet;

  /// No description provided for @addRecipesToDatabase.
  ///
  /// In en, this message translates to:
  /// **'Add recipes to the database'**
  String get addRecipesToDatabase;

  /// No description provided for @defaultRecipeDescription.
  ///
  /// In en, this message translates to:
  /// **'A nutritious and delicious recipe.'**
  String get defaultRecipeDescription;

  /// No description provided for @viewRecipe.
  ///
  /// In en, this message translates to:
  /// **'View Recipe'**
  String get viewRecipe;

  /// No description provided for @cancelWorkoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop? Progress won\'t be saved.'**
  String get cancelWorkoutConfirm;

  /// No description provided for @workoutCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Workout completed successfully!'**
  String get workoutCompletedMsg;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerWeight.
  ///
  /// In en, this message translates to:
  /// **'Register Weight'**
  String get registerWeight;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get newGoal;

  /// No description provided for @weightTrend.
  ///
  /// In en, this message translates to:
  /// **'Weight Trend'**
  String get weightTrend;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @pendingRegistration.
  ///
  /// In en, this message translates to:
  /// **'Pending registration'**
  String get pendingRegistration;

  /// No description provided for @whatToRegister.
  ///
  /// In en, this message translates to:
  /// **'What do you want to register?'**
  String get whatToRegister;

  /// No description provided for @goToRoutines.
  ///
  /// In en, this message translates to:
  /// **'Go to Routines'**
  String get goToRoutines;

  /// No description provided for @lbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbs;

  /// No description provided for @targetValue.
  ///
  /// In en, this message translates to:
  /// **'Target value'**
  String get targetValue;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessionsYet;

  /// No description provided for @completeWorkoutToSeeHistory.
  ///
  /// In en, this message translates to:
  /// **'Complete a workout to see your history.'**
  String get completeWorkoutToSeeHistory;

  /// No description provided for @weightLog.
  ///
  /// In en, this message translates to:
  /// **'Weight log'**
  String get weightLog;

  /// No description provided for @noWeightRecords.
  ///
  /// In en, this message translates to:
  /// **'No weight records'**
  String get noWeightRecords;

  /// No description provided for @startMonitoringWeight.
  ///
  /// In en, this message translates to:
  /// **'Start monitoring your weight to see progress.'**
  String get startMonitoringWeight;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @recordWeightToSeeEvolution.
  ///
  /// In en, this message translates to:
  /// **'Record your weight to see the evolution.'**
  String get recordWeightToSeeEvolution;

  /// No description provided for @suggestedGoals.
  ///
  /// In en, this message translates to:
  /// **'Suggested Goals'**
  String get suggestedGoals;

  /// No description provided for @maintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain'**
  String get maintain;

  /// No description provided for @stayActive.
  ///
  /// In en, this message translates to:
  /// **'Stay active'**
  String get stayActive;

  /// No description provided for @noGoals.
  ///
  /// In en, this message translates to:
  /// **'No goals'**
  String get noGoals;

  /// No description provided for @setGoalsToMeasureProgress.
  ///
  /// In en, this message translates to:
  /// **'Set goals to measure your progress.'**
  String get setGoalsToMeasureProgress;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgress;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get currentWeight;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'actual'**
  String get actual;

  /// No description provided for @startWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Start: {weight} lbs'**
  String startWeightLabel(String weight);

  /// No description provided for @goalWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal: {weight} lbs'**
  String goalWeightLabel(String weight);

  /// No description provided for @weightWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{weight} lbs'**
  String weightWithUnit(String weight);

  /// No description provided for @heightWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{height} m'**
  String heightWithUnit(String height);

  /// No description provided for @ageWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String ageWithUnit(String age);

  /// No description provided for @weightLostGained.
  ///
  /// In en, this message translates to:
  /// **'{weight} lbs {action}'**
  String weightLostGained(String weight, String action);

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'lost'**
  String get lost;

  /// No description provided for @gained.
  ///
  /// In en, this message translates to:
  /// **'gained'**
  String get gained;

  /// No description provided for @greatJobLost.
  ///
  /// In en, this message translates to:
  /// **'Great job! You\'ve lost {weight} lbs since you started.'**
  String greatJobLost(String weight);

  /// No description provided for @keepPushingGained.
  ///
  /// In en, this message translates to:
  /// **'Keep pushing! You\'ve gained {weight} lbs since you started.'**
  String keepPushingGained(String weight);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @muscleBuilding.
  ///
  /// In en, this message translates to:
  /// **'Muscle Building'**
  String get muscleBuilding;

  /// No description provided for @weightLossPlan.
  ///
  /// In en, this message translates to:
  /// **'Weight Loss Plan'**
  String get weightLossPlan;

  /// No description provided for @healthyRecipe.
  ///
  /// In en, this message translates to:
  /// **'Healthy Recipe'**
  String get healthyRecipe;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @startNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get startNewChat;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversations;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @whatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnYourMind;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeComment;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Be the first!'**
  String get noCommentsYet;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @postView.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postView;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPosts;

  /// No description provided for @noPostsDescription.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share something with the community!'**
  String get noPostsDescription;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get addComment;

  /// No description provided for @noMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get noMembersYet;

  /// No description provided for @membersWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Members will appear here when they join.'**
  String get membersWillAppear;

  /// No description provided for @errorStartingChat.
  ///
  /// In en, this message translates to:
  /// **'Error starting chat: {error}'**
  String errorStartingChat(String error);

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'You have no messages yet'**
  String get noMessagesYet;

  /// No description provided for @startConversationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with a community member.'**
  String get startConversationPrompt;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @youPrefix.
  ///
  /// In en, this message translates to:
  /// **'You: {message}'**
  String youPrefix(String message);

  /// No description provided for @startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start Conversation'**
  String get startConversation;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResultsFor(String query);

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @errorStartingConversation.
  ///
  /// In en, this message translates to:
  /// **'Error starting conversation: {error}'**
  String errorStartingConversation(String error);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @appColor.
  ///
  /// In en, this message translates to:
  /// **'App Color'**
  String get appColor;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updateProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updateProfileInfo;

  /// No description provided for @fitnessGoalsSettings.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goals'**
  String get fitnessGoalsSettings;

  /// No description provided for @fitnessGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your workout and health goals'**
  String get fitnessGoalsSubtitle;

  /// No description provided for @manageNotificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manageNotificationPrefs;

  /// No description provided for @toggleDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark mode on/off'**
  String get toggleDarkMode;

  /// No description provided for @getHelpAndAnswers.
  ///
  /// In en, this message translates to:
  /// **'Get help and find answers'**
  String get getHelpAndAnswers;

  /// No description provided for @communicateWithSupport.
  ///
  /// In en, this message translates to:
  /// **'Communicate with support'**
  String get communicateWithSupport;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile'**
  String get couldNotLoadProfile;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive important system alerts'**
  String get pushNotificationsSubtitle;

  /// No description provided for @workoutReminders.
  ///
  /// In en, this message translates to:
  /// **'Workout Reminders'**
  String get workoutReminders;

  /// No description provided for @workoutRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget your daily routines'**
  String get workoutRemindersSubtitle;

  /// No description provided for @communityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Community Alerts'**
  String get communityAlerts;

  /// No description provided for @communityAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Messages and comments from other members'**
  String get communityAlertsSubtitle;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @faqChangeTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'How can I change my training plan?'**
  String get faqChangeTrainingPlan;

  /// No description provided for @faqChangeTrainingPlanAnswer.
  ///
  /// In en, this message translates to:
  /// **'You can change your training plan by navigating to the \"My Plans\" section and selecting a new plan that fits your needs.'**
  String get faqChangeTrainingPlanAnswer;

  /// No description provided for @faqRegisterProgress.
  ///
  /// In en, this message translates to:
  /// **'How do I register my daily progress?'**
  String get faqRegisterProgress;

  /// No description provided for @faqRegisterProgressAnswer.
  ///
  /// In en, this message translates to:
  /// **'On the main Dashboard, you\'ll find a section to register your weight, water intake, and daily calories.'**
  String get faqRegisterProgressAnswer;

  /// No description provided for @faqOffline.
  ///
  /// In en, this message translates to:
  /// **'Does the app work offline?'**
  String get faqOffline;

  /// No description provided for @faqOfflineAnswer.
  ///
  /// In en, this message translates to:
  /// **'Some features like viewing your downloaded routines work offline, but to sync your progress and chat with the community you need internet.'**
  String get faqOfflineAnswer;

  /// No description provided for @faqContactSupport.
  ///
  /// In en, this message translates to:
  /// **'How can I contact technical support?'**
  String get faqContactSupport;

  /// No description provided for @faqContactSupportAnswer.
  ///
  /// In en, this message translates to:
  /// **'You can go to Settings > Support > Send Feedback to send us an email directly.'**
  String get faqContactSupportAnswer;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiAssistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your FitMotiv assistant. How can I help you train today?'**
  String get aiAssistantGreeting;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @supportEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'FitMotiv Support'**
  String get supportEmailSubject;

  /// No description provided for @supportEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Hello, I need help with...'**
  String get supportEmailBody;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get reps;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
