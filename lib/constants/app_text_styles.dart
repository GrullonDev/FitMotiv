import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_motiv/constants/app_colors.dart';

class AppTextStyles {
  // Títulos principales
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading4 => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Texto del cuerpo
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Texto especial
  static TextStyle get welcome => GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get quote => GoogleFonts.poppins(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get chipText =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);
}
