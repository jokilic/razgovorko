import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/borders.dart';
import '../../../theme/theme.dart';

class OnboardingTextField extends StatelessWidget {
  final bool autofocus;
  final bool obscureText;
  final Function(String value) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? prefix;
  final String labelText;

  const OnboardingTextField({
    required this.onChanged,
    required this.keyboardType,
    required this.textInputAction,
    required this.labelText,
    this.autofocus = false,
    this.obscureText = false,
    this.inputFormatters,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) => TextField(
        autofocus: autofocus,
        obscureText: obscureText,
        onChanged: onChanged,
        cursorColor: context.colors.black,
        cursorRadius: const Radius.circular(8),
        cursorHeight: 20,
        cursorWidth: 1.5,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: context.textStyles.onboardingTextField,
        decoration: InputDecoration(
          prefix: prefix,
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          alignLabelWithHint: true,
          labelStyle: context.textStyles.onboardingTextFieldLabel,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: RazgovorkoBorders.onboardingBorder,
          focusedErrorBorder: RazgovorkoBorders.onboardingBorder,
          disabledBorder: RazgovorkoBorders.onboardingBorder,
          focusedBorder: RazgovorkoBorders.onboardingBorder,
          errorBorder: RazgovorkoBorders.onboardingBorder,
          enabledBorder: RazgovorkoBorders.onboardingBorder,
        ),
      );
}
