import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../dependencies.dart';
import '../../../models/parsed_number.dart';
import '../../../routing.dart';
import '../../../services/logger_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import '../widgets/onboarding_text_field.dart';
import 'onboarding_additional_controller.dart';

class OnboardingAdditionalScreen extends WatchingStatefulWidget {
  final String name;
  final ParsedNumber parsedNumber;
  final String password;

  const OnboardingAdditionalScreen({
    required this.name,
    required this.parsedNumber,
    required this.password,
  });

  @override
  State<OnboardingAdditionalScreen> createState() => _OnboardingAdditionalScreenState();
}

class _OnboardingAdditionalScreenState extends State<OnboardingAdditionalScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<OnboardingAdditionalController>(
      () => OnboardingAdditionalController(
        logger: getIt.get<LoggerService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<OnboardingAdditionalController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<OnboardingAdditionalController>();
    final additionalState = watchIt<OnboardingAdditionalController>().value;

    final topSpacing = MediaQuery.paddingOf(context).top;
    final bottomSpacing = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              top: topSpacing + 16,
              left: 16,
              bottom: 24,
            ),
            child: RazgovorkoButton(
              onPressed: Navigator.of(context).pop,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 36,
                color: context.colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              bottomSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add more account info',
                  style: context.textStyles.onboardingTitle,
                ),
                const SizedBox(height: 6),
                Text(
                  'Add a profile picture and some additional info about yourself.',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                Text(
                  "(you don't have to write anything here)",
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 32),
                Text(
                  'Add a profile picture of yourself.',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 16),
                Placeholder(
                  fallbackHeight: 240,
                  color: context.colors.blue,
                ),
                const SizedBox(height: 32),
                Text(
                  'Write a little about yourself.',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  maxLines: null,
                  onChanged: (value) => controller.updateState(
                    aboutMe: value,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  labelText: 'Type about yourself...',
                ),
                const SizedBox(height: 32),
                Text(
                  "Write what's on your mind.",
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  maxLines: null,
                  onChanged: (value) => controller.updateState(
                    status: value,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  labelText: 'Type your thoughts...',
                ),
                const SizedBox(height: 32),
                Text(
                  'Share your location.',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  onChanged: (value) => controller.updateState(
                    location: value,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  labelText: 'Type where are you...',
                ),
                const SizedBox(height: 32),
                Text(
                  'Your date of birth.',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      locale: const Locale('hr'),
                      initialDatePickerMode: DatePickerMode.year,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (date != null) {
                      controller.updateDateOfBirth(
                        newDate: date,
                      );
                    }
                  },
                  readOnly: true,
                  controller: controller.dateController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  labelText: 'Add your date of birth...',
                ),
                const SizedBox(height: 40),
                RazgovorkoButton(
                  onPressed: () => openOnboardingFinish(
                    context,
                    name: widget.name,
                    parsedNumber: widget.parsedNumber,
                    password: widget.password,
                    avatarUrl: (additionalState.avatarUrl?.isNotEmpty ?? false) ? additionalState.avatarUrl : null,
                    aboutMe: (additionalState.aboutMe?.isNotEmpty ?? false) ? additionalState.aboutMe : null,
                    status: (additionalState.status?.isNotEmpty ?? false) ? additionalState.status : null,
                    location: (additionalState.location?.isNotEmpty ?? false) ? additionalState.location : null,
                    dateOfBirth: additionalState.dateOfBirth,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        width: 2.5,
                        color: context.colors.blue,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Confirm',
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
