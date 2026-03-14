import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/core/di/injection_container.dart';
import 'package:fit_motiv/core/services/analytics_service.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';
import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:fit_motiv/features/auth/presentation/register/pages/register_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterBloc>(
      create: (_) =>
          RegisterBloc(authRepository: sl.get<AuthRepository>(), analyticsService: sl.get<AnalyticsService>()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: RegisterLayout()),
      ),
    );
  }
}
