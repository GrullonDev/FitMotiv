import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:fit_motiv/features/auth/presentation/register/widgets/register_success_dialog.dart';
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

    // Si el registro fue exitoso, mostrar diálogo después de un delay
    if (bloc.successMessage != null) {
      if (context.mounted) {
        // Esperar un poco para que el usuario vea el mensaje de éxito
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          showDialog(context: context, barrierDismissible: false, builder: (context) => const RegisterSuccessDialog());
        }
      }
    }
  }
}
