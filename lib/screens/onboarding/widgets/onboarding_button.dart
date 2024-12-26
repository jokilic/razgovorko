import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';

class OnboardingButton extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;
  final String buttonText;

  const OnboardingButton({
    required this.isActive,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) => RazgovorkoButton(
        onPressed: isActive ? onPressed : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            boxShadow: isActive
                ? [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 8,
                      color: context.colors.cyan.withOpacity(0.25),
                    ),
                  ]
                : null,
            gradient: isActive
                ? RadialGradient(
                    colors: [
                      context.colors.cyan.withOpacity(0),
                      context.colors.white,
                    ],
                    center: const Alignment(0, 3),
                    radius: 2,
                    focal: const Alignment(0, 4),
                  )
                : null,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              width: 2.5,
              color: context.colors.cyan.withOpacity(isActive ? 1 : 0.25),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: context.textStyles.onboardingButton.copyWith(
              color: context.colors.black.withOpacity(isActive ? 1 : 0.25),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
