import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:fit_motiv/screens/home_screen.dart';

class FitMotivApp extends StatelessWidget {
  const FitMotivApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMotiv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF00D4A3),
        scaffoldBackgroundColor: const Color(0xFFF8FAFB),
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4A3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
