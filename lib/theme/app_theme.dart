// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core palette
  static const Color bg       = Color(0xFF0A0E1A);
  static const Color surface  = Color(0xFF111827);
  static const Color surface2 = Color(0xFF1A2235);
  static const Color border   = Color(0xFF1E2D45);
  static const Color accent   = Color(0xFF00E5FF);
  static const Color accent2  = Color(0xFF7C3AED);
  static const Color accent3  = Color(0xFFF59E0B);
  static const Color textDim  = Color(0xFF64748B);
  static const Color green    = Color(0xFF10B981);
  static const Color red      = Color(0xFFEF4444);

  // Block colors by type
  static const Color blockFree    = Color(0xFF1E2D45);
  static const Color blockIndex   = Color(0xFF7C3AED);

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: accent2,
        error: red,
      ),
      textTheme: GoogleFonts.jetBrainsMonoTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        labelStyle: const TextStyle(color: textDim, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      dividerColor: border,
    );
  }

  // Text styles
  static TextStyle get labelStyle => GoogleFonts.syne(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: textDim,
    letterSpacing: 1.5,
  );

  static TextStyle get panelTitle => GoogleFonts.syne(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
    color: Colors.white,
  );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    color: Colors.white70,
  );

  static TextStyle get monoTiny => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    color: textDim,
  );
}
