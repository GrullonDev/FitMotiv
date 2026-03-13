import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';

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
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => _baseStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading3 => _baseStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading4 => _baseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Texto del cuerpo
  static TextStyle get bodyLarge => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Texto especial
  static TextStyle get welcome => _baseStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get quote => _baseStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: AppColors.textSecondary,
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
