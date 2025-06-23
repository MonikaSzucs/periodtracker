// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../core/palette.dart';
import '../core/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Palette.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: Palette.highlightYellow,
      background: Palette.darkBackground,
      surface: Palette.darkBackground,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Palette.darkText),
      bodyMedium: TextStyle(color: Palette.darkText),
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Palette.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: Palette.highlightYellow,
      background: Palette.lightBackground,
      surface: Palette.lightBackground,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Palette.lightText),
      bodyMedium: TextStyle(color: Palette.lightText),
    ),
  );
}