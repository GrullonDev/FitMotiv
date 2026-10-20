import 'package:fit_motiv/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthLink extends StatelessWidget {
  const AuthLink({super.key, required this.text, required this.linkText, required this.onTap});

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
