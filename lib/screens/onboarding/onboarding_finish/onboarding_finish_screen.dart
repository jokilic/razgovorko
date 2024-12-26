import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../models/parsed_number.dart';
import '../../../routing.dart';
import '../../../services/auth_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/users_table_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import '../widgets/onboarding_button.dart';
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
                ///
                /// HEADER IMAGE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: Image.asset(
                      RazgovorkoImages.illustration5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

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
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.colors.cyan,
                          width: 2.5,
                        ),
                      ),
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

                          ///
                          /// PROFILE PICTURE
                          ///
                          if (widget.avatarUrl != null) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Profile picture'.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                color: context.colors.black.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              height: 160,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.file(
                                  File(widget.avatarUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Animate(
                      effects: const [
                        ShakeEffect(),
                      ],
                      autoPlay: false,
                      controller: buttonShakeAnimationController,
                      child: OnboardingButton(
                        buttonText: 'Register',
                        isActive: true,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
