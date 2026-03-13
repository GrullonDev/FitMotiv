import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Splash screen que verifica la sesión del usuario al abrir la app.
/// Si hay una sesión válida (token), navega directamente al Home.
/// Si no hay sesión, navega al Onboarding/Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Verificar sesión después de la animación
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Esperar un mínimo para la animación del splash
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null && !session.isExpired) {
        // Sesión válida - intentar refrescar el token para mantenerlo actualizado
        try {
          await Supabase.instance.client.auth.refreshSession();
        } catch (_) {
          // Si no se puede refrescar, aún puede ser válida temporalmente
        }

        // Verificar de nuevo después del refresh
        final refreshedSession = Supabase.instance.client.auth.currentSession;
        if (refreshedSession != null && !refreshedSession.isExpired && mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          return;
        }
      }

      // No hay sesión válida, ir al onboarding
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } catch (e) {
      // En caso de error, ir al onboarding
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / Ícono de la app
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Nombre de la app
                    Text(
                      'FitMotiv',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Fitness Journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Loading indicator
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Badge de entorno (solo visible en dev)
          if (AppConfig.instance.isDevelopment)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.build_rounded, size: 14, color: Colors.orange.shade800),
                      const SizedBox(width: 6),
                      Text(
                        'DEV Environment',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
