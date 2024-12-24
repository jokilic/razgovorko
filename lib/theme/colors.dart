import 'package:flutter/material.dart';

abstract class RazgovorkoColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const blue = Color(0xFF446DF6);
}

class RazgovorkoColorsExtension extends ThemeExtension<RazgovorkoColorsExtension> {
  final Color white;
  final Color black;
  final Color blue;

  RazgovorkoColorsExtension({
    required this.white,
    required this.black,
    required this.blue,
  });

  @override
  ThemeExtension<RazgovorkoColorsExtension> copyWith({
    Color? white,
    Color? black,
    Color? blue,
  }) =>
      RazgovorkoColorsExtension(
        white: white ?? this.white,
        black: black ?? this.black,
        blue: blue ?? this.blue,
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
      blue: Color.lerp(blue, other.blue, t)!,
    );
  }
}
