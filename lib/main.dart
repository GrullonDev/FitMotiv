import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:fit_motiv/app.dart';

import 'core/di/injection_container.dart' as di;
import 'features/dashboard/presentation/providers/dashboard_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<DashboardProvider>()),
      ],
      child: const FitMotivApp(),
    ),
  );
}
