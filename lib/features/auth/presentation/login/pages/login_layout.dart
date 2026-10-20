import 'package:fit_motiv/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:fit_motiv/features/auth/presentation/login/widgets/widgets.dart';
import 'package:fit_motiv/utils/widgets/auth_link.dart';
import 'package:fit_motiv/utils/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginBloc>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y descripción
              const LoginHeader(),

              // Campos del formulario
              LoginForm(bloc: model),

              const SizedBox(height: 24),

              // Mensaje de éxito si existe
              if (model.successMessage != null) MessageCard(message: model.successMessage!, isError: false),

              // Mensaje de error si existe
              if (model.errorMessage != null) MessageCard(message: model.errorMessage!, isError: true),

              // Botón para reenviar verificación de email
              if (model.isEmailNotConfirmed)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: model.isLoading ? null : () => model.resendVerificationEmail(),
                      icon: const Icon(Icons.email_outlined, size: 18),
                      label: const Text('Resend Verification Email'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade700,
                        side: BorderSide(color: Colors.orange.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Botón de login
              LoginSubmitButton(bloc: model),

              const SizedBox(height: 24),

              // Link para forgot password
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navegar a forgot password screen
                    // Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),

              // Link para register
              AuthLink(
                text: "Don't have an account? ",
                linkText: 'Sign Up',
                onTap: () => Navigator.pushNamed(context, '/register'),
              ),
            ],
          ),
        );
      },
    );
  }
}
