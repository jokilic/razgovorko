import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../routing.dart';
import '../../../services/logger_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import '../widgets/onboarding_button.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          /// BACK
          ///
          IgnorePointer(
            child: Opacity(
              opacity: 0,
              child: Padding(
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
                  RazgovorkoImages.illustration1,
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
                OnboardingButton(
                  buttonText: 'Get started',
                  isActive: nameState?.trim().isNotEmpty ?? false,
                  onPressed: () => openOnboardingNumber(
                    context,
                    name: nameState!.trim(),
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
