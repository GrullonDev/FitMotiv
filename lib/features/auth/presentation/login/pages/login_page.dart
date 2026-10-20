import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/core/di/injection_container.dart';
import 'package:fit_motiv/core/services/analytics_service.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';
import 'package:fit_motiv/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:fit_motiv/features/auth/presentation/login/pages/login_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginBloc>(
      create: (_) => LoginBloc(authRepository: sl.get<AuthRepository>(), analyticsService: sl.get<AnalyticsService>()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: LoginLayout()),
      ),
    );
  }
}
