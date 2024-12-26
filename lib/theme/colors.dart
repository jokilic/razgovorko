import 'package:flutter/material.dart';

abstract class RazgovorkoColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const cyan = Color(0xFF30BCED);
}

class RazgovorkoColorsExtension extends ThemeExtension<RazgovorkoColorsExtension> {
  final Color white;
  final Color black;
  final Color cyan;

  RazgovorkoColorsExtension({
    required this.white,
    required this.black,
    required this.cyan,
  });

  @override
  ThemeExtension<RazgovorkoColorsExtension> copyWith({
    Color? white,
    Color? black,
    Color? cyan,
  }) =>
      RazgovorkoColorsExtension(
        white: white ?? this.white,
        black: black ?? this.black,
        cyan: cyan ?? this.cyan,
      );

  @override
  ThemeExtension<RazgovorkoColorsExtension> lerp(
    covariant ThemeExtension<RazgovorkoColorsExtension>? other,
    double t,
  ) {
    if (other is! RazgovorkoColorsExtension) {
      return this;
    }

    return RazgovorkoColorsExtension(
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
    );
  }
}
