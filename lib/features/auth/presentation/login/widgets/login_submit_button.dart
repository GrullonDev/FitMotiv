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

    // Si el login fue exitoso, navegar al dashboard automáticamente
    if (bloc.successMessage != null && bloc.loginData != null) {
      if (context.mounted) {
        // Esperar brevemente para que el usuario vea el SnackBar de éxito
        await Future.delayed(const Duration(milliseconds: 1500));
        if (context.mounted) {
          // Navegar al home y limpiar todo el stack de navegación
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    }
  }
}
