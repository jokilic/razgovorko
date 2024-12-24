import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../models/parsed_number.dart';
import '../../../services/logger_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
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
        children: [
          ///
          /// HEADER IMAGE
          ///
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, topSpacing, 40, bottomSpacing),
              child: Image.asset(
                RazgovorkoImages.illustration4,
              ),
            ),
          ),

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
                  labelText: 'Type your password...',
                ),
                const SizedBox(height: 40),
                RazgovorkoButton(
                  onPressed: isStateProper
                      ? () {
                          getIt.get<LoggerService>().f('Name -> ${widget.name}');
                          getIt.get<LoggerService>().f('Number -> ${widget.parsedNumber}');
                          getIt.get<LoggerService>().f('Password -> $passwordState');
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        width: 2.5,
                        color: context.colors.blue.withOpacity(isStateProper ? 1 : 0.25),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Create account',
                      style: context.textStyles.onboardingButton,
                      textAlign: TextAlign.center,
                    ),
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
                            onPressed: () {
                              print('Hehe');
                            },
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
                SizedBox(height: bottomSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
