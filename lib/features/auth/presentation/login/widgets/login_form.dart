import 'package:fit_motiv/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:fit_motiv/utils/widgets/user_input.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Username
        UserInput(hint: 'Enter your username', controller: bloc.usernameController),
        const SizedBox(height: 16),

        // Password
        UserInput(hint: 'Enter your password', controller: bloc.passwordController, obscureText: true),
      ],
    );
  }
}
