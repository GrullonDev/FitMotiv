import 'package:firebase_core/firebase_core.dart';
import 'package:fit_motiv/firebase_options.dart';
import 'package:fit_motiv/core/services/notification_service.dart';
import 'package:fit_motiv/core/config/app_config.dart';
import 'package:fit_motiv/core/di/injection_container.dart' as di;
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:fit_motiv/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';
import 'package:fit_motiv/features/progress/presentation/providers/progress_provider.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<DashboardProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<UserProfileProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<WorkoutProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProgressProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CommunityProvider>()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const FitMotivApp(),
    );
  }
}

/// Función común que inicializa las dependencias y configuraciones básicas
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Only if configured)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization skipped: $e');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.instance.supabaseUrl,
    anonKey: AppConfig.instance.supabaseAnonKey,
  );

  // Initialize dependency injection
  await di.init();

  // Initialize Notifications
  try {
    await di.sl<NotificationService>().init();
  } catch (e) {
    debugPrint('Notification initialization skipped: $e');
  }
}
