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
        padding: EdgeInsets.fromLTRB(
          24,
          topSpacing + 24,
          24,
          bottomSpacing,
        ),
        physics: const BouncingScrollPhysics(),
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
              avatarUrl: additionalState.avatarUrl,
              aboutMe: additionalState.aboutMe,
              status: additionalState.status,
              location: additionalState.location,
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
                'Finish',
                style: context.textStyles.onboardingButton,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }
}
