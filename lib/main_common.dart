import 'package:fit_motiv/core/di/injection_container.dart' as di;
import 'package:fit_motiv/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fit_motiv/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => di.sl<DashboardProvider>())],
      child: const FitMotivApp(),
    );
  }
}

/// Función común que inicializa las dependencias y configuraciones básicas
Future<void> initializeApp() async {
  // Initialize dependency injection
  await di.init();
}
