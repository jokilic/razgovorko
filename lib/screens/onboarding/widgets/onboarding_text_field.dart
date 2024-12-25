import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/borders.dart';
import '../../../theme/theme.dart';

class OnboardingTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final Function(String value)? onChanged;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? prefix;
  final String labelText;
  final int? maxLines;

  const OnboardingTextField({
    required this.keyboardType,
    required this.textInputAction,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) => TextField(
        readOnly: readOnly,
        controller: controller,
        maxLines: maxLines,
        autofocus: autofocus,
        obscureText: obscureText,
        onChanged: onChanged,
        onTap: onTap,
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
