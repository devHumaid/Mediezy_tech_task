import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Brand Colors ──────────────────────────────────────────────
  /// Deep dark green – gradient start (3% stop)
  static const Color primaryDark = Color(0xFF042222);

  /// Vivid teal green – gradient end (68% stop)
  static const Color primaryTeal = Color(0xFF03624C);

  /// Primary gradient used on buttons, banners, active tiles
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.03, 0.68],
    colors: [primaryDark, primaryTeal],
  );

  // ── Background Colors ─────────────────────────────────────────────────
  /// Main app background
  static const Color background = Color(0xFFFFFFFF);

  /// Light grey background (used in dashboard, card surfaces)
  static const Color backgroundLight = Color(0xFFF0F0F0);

  // ── Text Colors ───────────────────────────────────────────────────────
  /// Primary text – black
  static const Color textPrimary = Color(0xFF000000);

  /// Secondary / caption text – grey
  static const Color textSecondary = Color(0xFF7D7D7D);

  /// Highlighted / brand text (dark green)
  static const Color textHighlight = Color(0xFF042222);

  /// Text inside login text fields – grey placeholder
  static const Color textFieldHint = Color(0xFF828282);

  // ── Border / Stroke Colors ────────────────────────────────────────────
  /// Login username & password field border
  static const Color loginFieldBorder = Color(0xFFE0E0E0);

  /// Create account text field border
  static const Color createAccountFieldBorder = Color(0xFFF0F0F0);

  // ── Component Colors ──────────────────────────────────────────────────
  /// White – used for card backgrounds, button text
  static const Color white = Color(0xFFFFFFFF);

  /// Divider / subtle separator
  static const Color divider = Color(0xFFE0E0E0);

  /// Route tile active background (dark green)
  static const Color routeTileActive = Color(0xFF042222);

  /// Leave tile background (white/light)
  static const Color routeTileInactive = Color(0xFFFFFFFF);

  // ── Status Colors ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF03624C);
  static const Color error   = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
}