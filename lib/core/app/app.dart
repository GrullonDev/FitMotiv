import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      home: Scaffold(body: Center(child: Text('FitMotiv'))),
    );
  }
}
