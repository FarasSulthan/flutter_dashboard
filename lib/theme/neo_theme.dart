import 'package:flutter/material.dart';
import 'neo_colors.dart';

class NeoTheme {
  NeoTheme._();

  static const double borderThickness = 2.5;
  static const double borderRadius = 12.0;
  static const Offset shadowOffset = Offset(4, 4);

  static BoxDecoration boxDecoration({
    Color color = Colors.white,
    double radius = borderRadius,
    double borderWidth = borderThickness,
    Color borderColor = NeoColors.border,
    Color shadowColor = NeoColors.shadow,
    Offset shadow = shadowOffset,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: shadow == Offset.zero
          ? null
          : [
              BoxShadow(
                color: shadowColor,
                offset: shadow,
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
    );
  }

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: NeoColors.background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: NeoColors.primary,
        secondary: NeoColors.secondary,
        surface: Colors.white,
        onSurface: NeoColors.textDark,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: const TextStyle(
          color: NeoColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: NeoColors.border, width: 2),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NeoColors.border, width: 3),
        ),
        elevation: 0,
      ),
    );
  }
}
