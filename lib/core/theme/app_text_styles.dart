import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3,
  );

  static TextStyle heading3 = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle buttonPrimary = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.white, letterSpacing: 0.3,
  );

  static TextStyle buttonOutlined = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: 0.3,
  );

  static TextStyle fieldHint = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textFieldHint,
  );

  static TextStyle fieldInput = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle poweredBy = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Create Account specific
  static TextStyle createAccountLabel = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.createAccountLabel,
  );

  static TextStyle createAccountHint = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w700,
    color: AppColors.createAccountHint,
  );
}