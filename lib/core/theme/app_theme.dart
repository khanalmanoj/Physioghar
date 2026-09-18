import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: PhysioColors.cream,
      primaryColor: PhysioColors.pine,
      colorScheme: const ColorScheme.light(
        primary: PhysioColors.pine,
        secondary: PhysioColors.amber,
        surface: PhysioColors.cream,
        error: PhysioColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: PhysioColors.ink,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: PhysioColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: PhysioColors.ink),
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: PhysioColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: PhysioColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PhysioColors.mist, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: PhysioColors.mist,
        thickness: 1,
        space: 1,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.fraunces(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: PhysioColors.ink,
        ),
        displayMedium: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: PhysioColors.ink,
        ),
        displaySmall: GoogleFonts.fraunces(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: PhysioColors.ink,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PhysioColors.ink,
        ),
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: PhysioColors.ink,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: PhysioColors.ink,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: PhysioColors.ink,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: PhysioColors.inkMid,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: PhysioColors.inkMid,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: PhysioColors.inkMute,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: GoogleFonts.ibmPlexMono(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
