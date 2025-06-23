import 'package:flutter/material.dart';
import 'palette.dart';

class AppColorScheme {
  // Context-dependent colors - must be called with BuildContext
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Palette.darkBackground
          : Palette.lightBackground;

  static Color text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Palette.darkText
          : Palette.lightText;

  // Constant colors (same in all themes)
  static const Color highlight = Palette.highlightYellow;
}