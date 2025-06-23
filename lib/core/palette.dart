import 'package:flutter/material.dart';

abstract class Palette {
  // Universal Colors (used in both themes)
  static const Color highlightYellow = Color(0xFFFFD700);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkText = Color(0xFFFFFFFF);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF000000);
}