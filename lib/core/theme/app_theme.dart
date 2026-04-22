import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Builds complete [ThemeData] for light and dark modes.
///
/// Both themes share the orange brand accent while adjusting
/// surfaces, text, and component styles for readability.
class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────
  //  Light theme
  // ──────────────────────────────────────

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.light(
        primary: AppColors.orangeBright,
        onPrimary: Colors.white,
        secondary: AppColors.blueLight,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textHighLight,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderLight,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textHighLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.textHighLight),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.orangeBright,
        unselectedItemColor: AppColors.textLowLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button (primary CTA)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeBright,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textHighLight,
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.orangeBright,
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.orangePrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textLowLight,
        ),
        labelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMidLight,
          letterSpacing: 0.5,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevatedLight,
        side: const BorderSide(color: AppColors.borderLight),
        labelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMidLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: AppColors.borderLight,
        showDragHandle: true,
      ),

      // Text theme
      textTheme: _buildTextTheme(base.textTheme, AppColors.textHighLight),

      // Extensions
      extensions: [
        const HostelHopColors(
          textHigh: AppColors.textHighLight,
          textMid: AppColors.textMidLight,
          textLow: AppColors.textLowLight,
          surfaceElevated: AppColors.surfaceElevatedLight,
          brandSoft: AppColors.brandSoftLight,
          link: AppColors.blueLight,
          overlay: AppColors.overlayLight,
        ),
      ],
    );
  }

  // ──────────────────────────────────────
  //  Dark theme
  // ──────────────────────────────────────

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.orangeBright,
        onPrimary: Colors.white,
        secondary: AppColors.blueDark,
        onSecondary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textHighDark,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderDark,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textHighDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textHighDark),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.orangeBright,
        unselectedItemColor: AppColors.textLowDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeBright,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textHighDark,
          side: const BorderSide(color: AppColors.borderDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.orangeBright,
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.orangePrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textLowDark,
        ),
        labelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMidDark,
          letterSpacing: 0.5,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        side: const BorderSide(color: AppColors.borderDark),
        labelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMidDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: AppColors.borderDark,
        showDragHandle: true,
      ),

      // Text theme
      textTheme: _buildTextTheme(base.textTheme, AppColors.textHighDark),

      // Extensions
      extensions: [
        const HostelHopColors(
          textHigh: AppColors.textHighDark,
          textMid: AppColors.textMidDark,
          textLow: AppColors.textLowDark,
          surfaceElevated: AppColors.surfaceElevatedDark,
          brandSoft: AppColors.brandSoftDark,
          link: AppColors.blueDark,
          overlay: AppColors.overlayDark,
        ),
      ],
    );
  }

  // ──────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return GoogleFonts.outfitTextTheme(base).apply(
      bodyColor: textColor,
      displayColor: textColor,
    );
  }
}

// ──────────────────────────────────────
//  Custom theme extension for non-Material tokens
// ──────────────────────────────────────

@immutable
class HostelHopColors extends ThemeExtension<HostelHopColors> {
  const HostelHopColors({
    required this.textHigh,
    required this.textMid,
    required this.textLow,
    required this.surfaceElevated,
    required this.brandSoft,
    required this.link,
    required this.overlay,
  });

  final Color textHigh;
  final Color textMid;
  final Color textLow;
  final Color surfaceElevated;
  final Color brandSoft;
  final Color link;
  final Color overlay;

  @override
  HostelHopColors copyWith({
    Color? textHigh,
    Color? textMid,
    Color? textLow,
    Color? surfaceElevated,
    Color? brandSoft,
    Color? link,
    Color? overlay,
  }) {
    return HostelHopColors(
      textHigh: textHigh ?? this.textHigh,
      textMid: textMid ?? this.textMid,
      textLow: textLow ?? this.textLow,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      brandSoft: brandSoft ?? this.brandSoft,
      link: link ?? this.link,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  HostelHopColors lerp(covariant HostelHopColors? other, double t) {
    if (other is! HostelHopColors) return this;
    return HostelHopColors(
      textHigh: Color.lerp(textHigh, other.textHigh, t)!,
      textMid: Color.lerp(textMid, other.textMid, t)!,
      textLow: Color.lerp(textLow, other.textLow, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      link: Color.lerp(link, other.link, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

/// Convenience extension to access [HostelHopColors] from any [BuildContext].
extension HostelHopColorsX on BuildContext {
  HostelHopColors get hhColors =>
      Theme.of(this).extension<HostelHopColors>()!;
}
