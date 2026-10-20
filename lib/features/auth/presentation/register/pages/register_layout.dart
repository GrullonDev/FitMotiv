import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:fit_motiv/features/auth/presentation/register/widgets/widgets.dart';
import 'package:fit_motiv/utils/widgets/auth_link.dart';
import 'package:fit_motiv/utils/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterLayout extends StatelessWidget {
  const RegisterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterBloc>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y descripción
              RegisterHeader(bloc: model),

              // Campos del formulario
              RegisterForm(bloc: model),

              const SizedBox(height: 24),

              // Mensaje de éxito si existe
              if (model.successMessage != null) MessageCard(message: model.successMessage!, isError: false),

              // Mensaje de error si existe
              if (model.errorMessage != null) MessageCard(message: model.errorMessage!, isError: true),

              // Botón de envío
              RegisterSubmitButton(bloc: model),

              const SizedBox(height: 16),

              // Link para ir al login
              AuthLink(text: 'Already have an account? ', linkText: 'Sign In', onTap: () => Navigator.pop(context)),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
