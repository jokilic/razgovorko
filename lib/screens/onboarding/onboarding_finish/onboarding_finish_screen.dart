import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../models/parsed_number.dart';
import '../../../services/auth_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/users_table_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import 'onboarding_finish_controller.dart';

class OnboardingFinishScreen extends WatchingStatefulWidget {
  final String name;
  final ParsedNumber parsedNumber;
  final String password;
  final String? avatarUrl;
  final String? aboutMe;
  final String? status;
  final String? location;
  final DateTime? dateOfBirth;

  const OnboardingFinishScreen({
    required this.name,
    required this.parsedNumber,
    required this.password,
    required this.avatarUrl,
    required this.aboutMe,
    required this.status,
    required this.location,
    required this.dateOfBirth,
  });

  @override
  State<OnboardingFinishScreen> createState() => _OnboardingFinishScreenState();
}

class _OnboardingFinishScreenState extends State<OnboardingFinishScreen> with SingleTickerProviderStateMixin {
  late final AnimationController buttonShakeAnimationController;

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<OnboardingFinishController>(
      () => OnboardingFinishController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
      ),
    );

    buttonShakeAnimationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    getIt.unregister<OnboardingFinishController>();
    buttonShakeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<OnboardingFinishController>();

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
          ///
          /// HEADER IMAGE
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Image.asset(
              RazgovorkoImages.illustration5,
            ),
          ),
          SizedBox(height: bottomSpacing),

          ///
          /// CONTENT
          ///
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Congratulations',
                style: context.textStyles.onboardingTitle,
              ),
              const SizedBox(height: 6),
              Text(
                'You have registered successfully',
                style: context.textStyles.onboardingText,
              ),
              const SizedBox(height: 32),
              Card(
                color: context.colors.cyan,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ///
                      /// NAME
                      ///
                      Text(
                        'Name'.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: context.colors.black.withOpacity(0.4),
                        ),
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.4,
                          color: context.colors.black,
                        ),
                      ),

                      ///
                      /// NUMBER
                      ///
                      const SizedBox(height: 24),
                      Text(
                        'Number'.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: context.colors.black.withOpacity(0.4),
                        ),
                      ),
                      Text(
                        widget.parsedNumber.international,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.4,
                          color: context.colors.black,
                        ),
                      ),

                      ///
                      /// ABOUT YOU
                      ///
                      if (widget.aboutMe != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'About you'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: context.colors.black.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          widget.aboutMe!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.4,
                            color: context.colors.black,
                          ),
                        ),
                      ],

                      ///
                      /// THOUGHTS
                      ///
                      if (widget.status != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Your thoughts'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: context.colors.black.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          widget.status!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.4,
                            color: context.colors.black,
                          ),
                        ),
                      ],

                      ///
                      /// LOCATION
                      ///
                      if (widget.location != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Your location'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: context.colors.black.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          widget.location!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.4,
                            color: context.colors.black,
                          ),
                        ),
                      ],

                      ///
                      /// DATE OF BIRTH
                      ///
                      if (widget.dateOfBirth != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Date of birth'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: context.colors.black.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          DateFormat(
                            'd. MMMM yyyy.',
                            'hr',
                          ).format(widget.dateOfBirth!),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.4,
                            color: context.colors.black,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Animate(
                effects: const [
                  ShakeEffect(),
                ],
                autoPlay: false,
                controller: buttonShakeAnimationController,
                child: RazgovorkoButton(
                  onPressed: () async {
                    final isRegistered = await controller.registerUser(
                      displayName: widget.name,
                      parsedNumber: widget.parsedNumber,
                      password: widget.password,
                      avatarUrl: widget.avatarUrl,
                      aboutMe: widget.aboutMe,
                      status: widget.status,
                      location: widget.location,
                      dateOfBirth: widget.dateOfBirth,
                    );

                    if (!isRegistered) {
                      buttonShakeAnimationController.reset();
                      await buttonShakeAnimationController.forward();
                    }
                  },
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
                      "Start chattin'",
                      style: context.textStyles.onboardingButton,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: bottomSpacing),
            ],
          ),
        ],
      ),
    );
  }
}
