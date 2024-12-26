import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../models/parsed_number.dart';
import '../../../routing.dart';
import '../../../services/logger_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_text_field.dart';
import 'onboarding_password_controller.dart';

class OnboardingPasswordScreen extends WatchingStatefulWidget {
  final String name;
  final ParsedNumber parsedNumber;

  const OnboardingPasswordScreen({
    required this.name,
    required this.parsedNumber,
  });

  @override
  State<OnboardingPasswordScreen> createState() => _OnboardingPasswordScreenState();
}

class _OnboardingPasswordScreenState extends State<OnboardingPasswordScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<OnboardingPasswordController>(
      () => OnboardingPasswordController(
        logger: getIt.get<LoggerService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<OnboardingPasswordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<OnboardingPasswordController>();
    final passwordState = watchIt<OnboardingPasswordController>().value;

    final isStateProper = controller.isStateProper(passwordState);

    final topSpacing = MediaQuery.paddingOf(context).top;
    final bottomSpacing = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topSpacing + 16, left: 16),
            child: RazgovorkoButton(
              onPressed: Navigator.of(context).pop,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 36,
                color: context.colors.black,
              ),
            ),
          ),

          ///
          /// HEADER IMAGE
          ///
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, bottomSpacing),
              child: Center(
                child: Image.asset(
                  RazgovorkoImages.illustration4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          ///
          /// CONTENT
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Razgovorko',
                  style: context.textStyles.onboardingTitle,
                ),
                const SizedBox(height: 6),
                Text(
                  'Razgovorko will help you chat with people.',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 32),
                Text(
                  'What is your password?',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  obscureText: true,
                  onChanged: (newPassword) => controller.value = newPassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  labelText: 'Type your password...',
                ),
                const SizedBox(height: 40),
                OnboardingButton(
                  buttonText: 'Next',
                  isActive: isStateProper,
                  onPressed: () => openOnboardingAdditional(
                    context,
                    name: widget.name,
                    parsedNumber: widget.parsedNumber,
                    password: passwordState!,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account?',
                      style: context.textStyles.onboardingText,
                      children: [
                        const WidgetSpan(
                          child: SizedBox(width: 4),
                        ),
                        WidgetSpan(
                          child: RazgovorkoButton(
                            onPressed: () => openLoginNumber(context),
                            child: Text(
                              'Sign in',
                              style: context.textStyles.onboardingText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: bottomSpacing + 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
