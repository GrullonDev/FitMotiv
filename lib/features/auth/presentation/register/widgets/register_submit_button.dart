import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:fit_motiv/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegisterSubmitButton extends StatelessWidget {
  const RegisterSubmitButton({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Sign Up',
      loadingText: 'Creating Account...',
      isLoading: bloc.isLoading,
      onPressed: () => _handleRegister(context),
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    // Limpiar errores y mensajes previos
    bloc.clearError();
    bloc.clearSuccess();

    // Ejecutar registro
    await bloc.register();

    // Si el registro fue exitoso, navegar al dashboard automáticamente
    if (bloc.userData != null && context.mounted) {
      // Esperar brevemente para que el usuario vea el SnackBar de éxito
      await Future.delayed(const Duration(milliseconds: 1500));
      if (context.mounted) {
        // Navegar al home y limpiar todo el stack de navegación
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }
}
