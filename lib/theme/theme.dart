import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class RazgovorkoTheme {
  ///
  /// LIGHT
  ///

  static ThemeData get light {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: lightAppColors.cyan,
        selectionColor: lightAppColors.cyan,
        selectionHandleColor: lightAppColors.cyan,
      ),
      scaffoldBackgroundColor: lightAppColors.white,
      extensions: [
        lightAppColors,
        lightTextTheme,
      ],
    );
  }

  static final lightAppColors = RazgovorkoColorsExtension(
    white: RazgovorkoColors.white,
    black: RazgovorkoColors.black,
    cyan: RazgovorkoColors.cyan,
  );

  static final lightTextTheme = RazgovorkoTextThemesExtension(
    onboardingTitle: RazgovorkoTextStyles.onboardingTitle.copyWith(
      color: lightAppColors.black,
    ),
    onboardingText: RazgovorkoTextStyles.onboardingText.copyWith(
      color: lightAppColors.black,
    ),
    onboardingTextField: RazgovorkoTextStyles.onboardingTextField.copyWith(
      color: lightAppColors.black,
    ),
    onboardingTextFieldLabel: RazgovorkoTextStyles.onboardingTextFieldLabel.copyWith(
      color: lightAppColors.black.withOpacity(0.35),
    ),
    onboardingButton: RazgovorkoTextStyles.onboardingButton.copyWith(
      color: lightAppColors.black,
    ),
  );
}

extension RazgovorkoThemeExtension on ThemeData {
  RazgovorkoColorsExtension get razgovorkoColors => extension<RazgovorkoColorsExtension>() ?? RazgovorkoTheme.lightAppColors;
  RazgovorkoTextThemesExtension get razgovorkoTextStyles => extension<RazgovorkoTextThemesExtension>() ?? RazgovorkoTheme.lightTextTheme;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
  RazgovorkoColorsExtension get colors => theme.razgovorkoColors;
  RazgovorkoTextThemesExtension get textStyles => theme.razgovorkoTextStyles;
}
