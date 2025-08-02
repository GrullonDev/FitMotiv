import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00D4A3);
  static const Color secondary = Color(0xFF1A1A1A);
  static const Color background = Color(0xFFF8FAFB);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color progressBackground = Color(0xFFF3F4F6);

  // Gradientes
  static const LinearGradient quoteGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F5F1), Color(0xFFD4F1E8)],
  );

  static const LinearGradient workoutGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFB366), Color(0xFFFF8A50)],
  );
}
