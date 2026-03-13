import 'package:fit_motiv/core/utils/snackbar_service.dart';
import 'package:fit_motiv/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fit_motiv/features/auth/presentation/pages/login_screen.dart';
import 'package:fit_motiv/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:fit_motiv/features/auth/presentation/register/pages/register_page.dart';
import 'package:fit_motiv/features/dashboard/presentation/screens/home_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/profile_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class FitMotivApp extends StatelessWidget {
  const FitMotivApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMotiv',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF00D4A3),
        scaffoldBackgroundColor: const Color(0xFFF8FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4A3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterPage(),
        '/forgot': (_) => const ForgotPasswordScreen(),
        '/home': (_) => const HomeScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
