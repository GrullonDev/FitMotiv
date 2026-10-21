import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:fit_motiv/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          l10n.createYourAccount,
          style: AppTextStyles.heading1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.joinFitMotivSubtitle,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
