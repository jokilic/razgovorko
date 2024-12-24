import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../routing.dart';
import '../../../services/logger_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import '../widgets/onboarding_text_field.dart';
import 'onboarding_name_controller.dart';

class OnboardingNameScreen extends WatchingStatefulWidget {
  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<OnboardingNameController>(
      () => OnboardingNameController(
        logger: getIt.get<LoggerService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<OnboardingNameController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<OnboardingNameController>();
    final nameState = watchIt<OnboardingNameController>().value;

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
                RazgovorkoImages.illustration1,
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
                  'What is your name?',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  onChanged: (newName) => controller.value = newName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  labelText: 'Type your name...',
                ),
                const SizedBox(height: 40),
                RazgovorkoButton(
                  onPressed: (nameState?.isNotEmpty ?? false)
                      ? () => openOnboardingNumber(
                            context,
                            name: nameState!.trim(),
                          )
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
                        color: context.colors.blue.withOpacity((nameState?.isNotEmpty ?? false) ? 1 : 0.25),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Get started',
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
