import 'package:fit_motiv/core/utils/snackbar_service.dart';
import 'package:fit_motiv/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fit_motiv/features/auth/presentation/pages/login_screen.dart';
import 'package:fit_motiv/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:fit_motiv/features/auth/presentation/pages/splash_screen.dart';
import 'package:fit_motiv/features/auth/presentation/register/pages/register_page.dart';
import 'package:fit_motiv/features/dashboard/presentation/screens/home_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/profile_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/settings_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/notification_settings_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/faq_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';

class FitMotivApp extends StatelessWidget {
  const FitMotivApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'FitMotiv',
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: themeProvider.primaryColor,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.primaryColor,
          primary: themeProvider.primaryColor,
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A1A),
          onSurfaceVariant: const Color(0xFF6B7280),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primaryColor: themeProvider.primaryColor,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.primaryColor,
          brightness: Brightness.dark,
          primary: themeProvider.primaryColor,
          surface: const Color(0xFF1E1E1E),
          onSurface: Colors.white,
          onSurfaceVariant: const Color(0xFF9CA3AF),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterPage(),
        '/forgot': (_) => const ForgotPasswordScreen(),
        '/home': (_) => const HomeScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/notifications': (_) => const NotificationSettingsScreen(),
        '/faq': (_) => const FAQScreen(),
      },
    );
  }
}
