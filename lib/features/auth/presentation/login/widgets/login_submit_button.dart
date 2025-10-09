import 'package:fit_motiv/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:fit_motiv/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({super.key, required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Sign In',
      loadingText: 'Signing In...',
      isLoading: bloc.isLoading,
      onPressed: () => _handleLogin(context),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    // Limpiar errores y mensajes previos
    bloc.clearError();
    bloc.clearSuccess();

    // Ejecutar login
    await bloc.login();

    // Si el login fue exitoso, navegar a la pantalla principal
    if (bloc.successMessage != null && bloc.loginData != null) {
      if (context.mounted) {
        // TODO: Navegar a la pantalla principal o dashboard
        // Navigator.pushReplacementNamed(context, '/dashboard');

        // Por ahora solo mostramos un diálogo de éxito
        await _showSuccessDialog(context);
      }
    }
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                child: Icon(Icons.check_circle, size: 50, color: Colors.green.shade600),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'You have successfully signed in. Ready to continue your fitness journey?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Navegar a dashboard cuando esté implementado
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
