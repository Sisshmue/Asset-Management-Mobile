import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Custom Dark Blue Palette ---
  static const Color primaryDarkBlue = Color(0xFF1A237E); // Indigo 900
  static const Color accentBlue = Color(0xFF283593); // Indigo 800
  static const Color surfaceLight = Color(0xFFF8F9FA); // Off-white background
  static const Color textMain = Color(0xFF102A43); // Deep blue-grey for text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDarkBlue,
        primary: primaryDarkBlue,
        onPrimary: Colors.white,
        surface: surfaceLight,
      ),

      // Setting Inter as the default font
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
      ),

      // Styling all InputFields globally
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryDarkBlue, width: 2),
        ),
        prefixIconColor: primaryDarkBlue,
      ),

      // Styling all Buttons globally
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDarkBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
