import 'package:fit_motiv/core/routes/route_path.dart';
import 'package:fit_motiv/core/routes/route_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      initialRoute: RoutePath.splash,
      onGenerateRoute: RouteSwitch.onGenerateRoute,
    );
  }
}
