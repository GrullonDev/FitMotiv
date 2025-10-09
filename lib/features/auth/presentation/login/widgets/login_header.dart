import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome Back!', style: AppTextStyles.heading1.copyWith(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue your fitness journey',
          style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
