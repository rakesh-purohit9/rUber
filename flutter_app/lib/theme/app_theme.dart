import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color ink = Color(0xFF0B0B0B);
  static const Color snow = Color(0xFFF7F7F7);
  static const Color electricGreen = Color(0xFF06C167);
  static const Color midnight = Color(0xFF101012);
  static const Color graphite = Color(0xFF1B1B1F);
  static const Color slate = Color(0xFF5C5F66);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: ink,
        secondary: electricGreen,
        surface: Colors.white,
        background: snow,
        onPrimary: Colors.white,
        onSecondary: ink,
        onSurface: ink,
        onBackground: ink,
      ),
      scaffoldBackgroundColor: snow,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: snow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: electricGreen,
        surface: graphite,
        background: midnight,
        onPrimary: ink,
        onSecondary: ink,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      scaffoldBackgroundColor: midnight,
      appBarTheme: const AppBarTheme(
        backgroundColor: midnight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: graphite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: graphite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
