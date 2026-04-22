import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralised text-style presets using Outfit from Google Fonts.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTypography.headlineLarge)
/// ```
class AppTypography {
  AppTypography._();

  static String get _fontFamily => GoogleFonts.outfit().fontFamily!;

  // ──────────────────────────────────────
  //  Display
  // ──────────────────────────────────────

  static TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.15,
  );

  // ──────────────────────────────────────
  //  Headlines
  // ──────────────────────────────────────

  static TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // ──────────────────────────────────────
  //  Titles
  // ──────────────────────────────────────

  static TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ──────────────────────────────────────
  //  Body
  // ──────────────────────────────────────

  static TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ──────────────────────────────────────
  //  Labels
  // ──────────────────────────────────────

  static TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.4,
  );

  // ──────────────────────────────────────
  //  Special
  // ──────────────────────────────────────

  /// Price display (large bold tabular numbers).
  static TextStyle priceTag = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.3,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// Compact price on hostel cards (e.g. "280k").
  static TextStyle priceCompact = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// Temperature reading on Sun Meter.
  static TextStyle temperature = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    height: 1.0,
  );

  /// Subtle copyright text.
  static TextStyle copyright = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );
}
