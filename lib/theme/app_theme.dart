import 'package:flutter/material.dart';

class AppTheme {
  static const blue = Color(0xFF00A8E1);
  // ThemeData comparte colores y tipografías entre todas las pantallas.
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF050B15),
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: blue,
      secondary: blue,
      surface: Color(0xFF111D2E),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.1,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Color(0xFFB9C5D5),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF050B15),
      surfaceTintColor: Colors.transparent,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: blue,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    ),
  );
}
