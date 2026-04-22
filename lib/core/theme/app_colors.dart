import 'package:flutter/material.dart';

/// HostelHop brand & semantic color tokens.
///
/// Light mode is default. Every surface, text, and accent color
/// has a light and dark variant keyed in [AppColors.light] and
/// [AppColors.dark].
class AppColors {
  AppColors._();

  // ──────────────────────────────────────
  //  Brand palette
  // ──────────────────────────────────────

  /// Primary action color – CTAs, active icons, bottom-nav highlight.
  static const Color orangeBright = Color(0xFFF57C00);

  /// Button gradients, focused field borders.
  static const Color orangePrimary = Color(0xFFE65100);

  /// Pressed states, deep accents.
  static const Color orangeDim = Color(0xFFBF360C);

  /// Links & secondary actions – light mode.
  static const Color blueLight = Color(0xFF1565C0);

  /// Links & secondary actions – dark mode.
  static const Color blueDark = Color(0xFF5A7ACD);

  // ──────────────────────────────────────
  //  Semantic – Light mode
  // ──────────────────────────────────────

  static const Color backgroundLight = Color(0xFFF5F2F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFF0EDED);
  static const Color borderLight = Color(0xFFE0DCDC);

  static const Color textHighLight = Color(0xFF1A1410);
  static const Color textMidLight = Color(0xFF5C5650);
  static const Color textLowLight = Color(0xFF9E9893);

  static const Color brandSoftLight = Color(0x1AF57C00); // 10% orange
  static const Color overlayLight = Color(0x80000000);

  // ──────────────────────────────────────
  //  Semantic – Dark mode
  // ──────────────────────────────────────

  static const Color backgroundDark = Color(0xFF1A1410);
  static const Color surfaceDark = Color(0xFF1E1A17);
  static const Color surfaceElevatedDark = Color(0xFF2A2520);
  static const Color borderDark = Color(0xFF3A3530);

  static const Color textHighDark = Color(0xFFF5F2F0);
  static const Color textMidDark = Color(0xFFB0AAA4);
  static const Color textLowDark = Color(0xFF7A746E);

  static const Color brandSoftDark = Color(0x33F57C00); // 20% orange
  static const Color overlayDark = Color(0xCC000000);

  // ──────────────────────────────────────
  //  Functional colors (shared)
  // ──────────────────────────────────────

  static const Color success = Color(0xFF4CAF50);
  static const Color successSoft = Color(0x1A4CAF50);
  static const Color warning = Color(0xFFF9A825);
  static const Color warningSoft = Color(0x1AF9A825);
  static const Color error = Color(0xFFEF5350);
  static const Color errorSoft = Color(0x1AEF5350);

  // ──────────────────────────────────────
  //  Gradient presets
  // ──────────────────────────────────────

  /// Primary CTA button gradient.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [orangeBright, orangePrimary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Splash / header background gradient (vertical).
  static const LinearGradient splashGradient = LinearGradient(
    colors: [orangeBright, orangePrimary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Sun Meter warm gauge gradient.
  static const LinearGradient sunMeterGradient = LinearGradient(
    colors: [
      Color(0xFF1565C0), // Cool (blue)
      Color(0xFF4CAF50), // Warm (green)
      Color(0xFFF9A825), // Hot (amber)
      Color(0xFFEF5350), // Extreme (red)
    ],
  );
}
