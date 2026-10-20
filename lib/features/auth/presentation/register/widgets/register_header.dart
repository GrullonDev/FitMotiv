import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text('Create Your Account', style: AppTextStyles.heading1, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Join FitMotiv and start your fitness journey today',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
