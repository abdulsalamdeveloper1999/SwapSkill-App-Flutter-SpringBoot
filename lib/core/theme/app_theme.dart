import 'package:flutter/material.dart';

class AppTheme {
  // Main Colors
  static const Color primaryBlue = Color(0xFF3B82F6); // Blue accent
  static const Color primaryPurple = Color(0xFF8B5CF6); // Purple accent
  static const Color darkBackground = Color(0xFF111827); // Main background
  static const Color cardDark = Color(0xFF1F2937); // Card background
  static const Color borderColor = Color(0xFF374151); // Border color

  // Text Colors
  static const Color textPrimary = Color(0xFFF9FAFB); // Primary text
  static const Color textSecondary = Color(0xFF9CA3AF); // Secondary text

  // Skill Tag Colors
  static const Color teachTagBg = Color(0xFF1E3A8A); // Can teach tag background
  static const Color teachTagText = Color(0xFF93C5FD); // Can teach tag text
  static const Color learnTagBg =
      Color(0xFF581C87); // Want to learn tag background
  static const Color learnTagText = Color(0xFFC4B5FD); // Want to learn tag text

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryBlue,

    // Card Theme
    cardTheme: const CardTheme(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: borderColor),
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),
    ),
  );
}
