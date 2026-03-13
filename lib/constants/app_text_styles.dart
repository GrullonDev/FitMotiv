import 'package:flutter/material.dart';

class AppTextStyles {
  // Generic TextStyle using default font (fallback)
  static TextStyle _baseStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: height,
      fontFamily: 'Poppins', // Still attempt to use Poppins if available in assets
    );
  }

  // Títulos principales
  static TextStyle get heading1 => _baseStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading2 => _baseStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading3 => _baseStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading4 => _baseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Texto del cuerpo
  static TextStyle get bodyLarge => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyMedium => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6B7280), // We keep a neutral grey for secondary, or let it be handled by context
  );

  static TextStyle get bodySmall => _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6B7280),
  );

  // Texto especial
  static TextStyle get welcome => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get quote => _baseStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );

  static TextStyle get buttonText => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get chipText =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.w500);
}
