import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryDark  = Color(0xFF042222);
  static const Color primaryTeal  = Color(0xFF03624C);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.03, 0.68],
    colors: [primaryDark, primaryTeal],
  );

  static const Color background       = Color(0xFFFFFFFF);
  static const Color backgroundLight  = Color(0xFFF0F0F0);
  static const Color white            = Color(0xFFFFFFFF);
  static const Color divider          = Color(0xFFE0E0E0);

  static const Color textPrimary      = Color(0xFF000000);
  static const Color textSecondary    = Color(0xFF7D7D7D);
  static const Color textHighlight    = Color(0xFF042222);
  static const Color textFieldHint    = Color(0xFF828282);

  static const Color loginFieldBorder         = Color(0xFFE0E0E0);
  static const Color createAccountFieldBorder = Color(0xFFF0F0F0);

  // status colors
  static const Color success  = Color(0xFF03624C);
  static const Color error    = Color(0xFFD32F2F);
  static const Color warning  = Color(0xFFF57C00);
  static const Color pending  = Color(0xFFF57C00);
  static const Color approved = Color(0xFF03624C);
  static const Color rejected = Color(0xFFD32F2F);
  static const Color casual   = Color(0xFFD4C200);
// Create Account
  static const Color createAccountBg        = Color(0xFFF1F7F7);
static const Color createAccountContainer = Color(0xFFFFFFFF);
static const Color createAccountStroke    = Color(0xFFD6DCE1);
static const Color createAccountHint      = Color(0xFFF0F0F0);
static const Color createAccountLabel     = Color(0xFF000000);
}