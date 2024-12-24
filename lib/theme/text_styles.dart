import 'package:flutter/material.dart';

abstract class RazgovorkoTextStyles {
  static const onboardingTitle = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
  static const onboardingText = TextStyle(
    fontFamily: 'Kanit',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static const onboardingTextField = TextStyle(
    fontFamily: 'Kanit',
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );
  static const onboardingTextFieldLabel = TextStyle(
    fontFamily: 'Kanit',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );
  static const onboardingButton = TextStyle(
    fontFamily: 'Kanit',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    letterSpacing: 1.2,
  );
}

class RazgovorkoTextThemesExtension extends ThemeExtension<RazgovorkoTextThemesExtension> {
  final TextStyle onboardingTitle;
  final TextStyle onboardingText;
  final TextStyle onboardingTextField;
  final TextStyle onboardingTextFieldLabel;
  final TextStyle onboardingButton;

  const RazgovorkoTextThemesExtension({
    required this.onboardingTitle,
    required this.onboardingText,
    required this.onboardingTextField,
    required this.onboardingTextFieldLabel,
    required this.onboardingButton,
  });

  @override
  ThemeExtension<RazgovorkoTextThemesExtension> copyWith({
    TextStyle? onboardingTitle,
    TextStyle? onboardingText,
    TextStyle? onboardingTextField,
    TextStyle? onboardingTextFieldLabel,
    TextStyle? onboardingButton,
  }) =>
      RazgovorkoTextThemesExtension(
        onboardingTitle: onboardingTitle ?? this.onboardingTitle,
        onboardingText: onboardingText ?? this.onboardingText,
        onboardingTextField: onboardingTextField ?? this.onboardingTextField,
        onboardingTextFieldLabel: onboardingTextFieldLabel ?? this.onboardingTextFieldLabel,
        onboardingButton: onboardingButton ?? this.onboardingButton,
      );

  @override
  ThemeExtension<RazgovorkoTextThemesExtension> lerp(
    covariant ThemeExtension<RazgovorkoTextThemesExtension>? other,
    double t,
  ) {
    if (other is! RazgovorkoTextThemesExtension) {
      return this;
    }

    return RazgovorkoTextThemesExtension(
      onboardingTitle: TextStyle.lerp(onboardingTitle, other.onboardingTitle, t)!,
      onboardingText: TextStyle.lerp(onboardingText, other.onboardingText, t)!,
      onboardingTextField: TextStyle.lerp(onboardingTextField, other.onboardingTextField, t)!,
      onboardingTextFieldLabel: TextStyle.lerp(onboardingTextFieldLabel, other.onboardingTextFieldLabel, t)!,
      onboardingButton: TextStyle.lerp(onboardingButton, other.onboardingButton, t)!,
    );
  }
}
