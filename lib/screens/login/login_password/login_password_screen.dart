import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/images.dart';
import '../../../dependencies.dart';
import '../../../models/parsed_number.dart';
import '../../../routing.dart';
import '../../../services/auth_service.dart';
import '../../../services/logger_service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/razgovorko_button.dart';
import '../../onboarding/widgets/onboarding_text_field.dart';
import 'login_password_controller.dart';

class LoginPasswordScreen extends WatchingStatefulWidget {
  final ParsedNumber parsedNumber;

  const LoginPasswordScreen({
    required this.parsedNumber,
  });

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> with SingleTickerProviderStateMixin {
  late final AnimationController buttonShakeAnimationController;

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<LoginPasswordController>(
      () => LoginPasswordController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
      ),
    );

    buttonShakeAnimationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    getIt.unregister<LoginPasswordController>();
    buttonShakeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<LoginPasswordController>();
    final passwordState = watchIt<LoginPasswordController>().value;

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
                Animate(
                  effects: const [
                    ShakeEffect(),
                  ],
                  autoPlay: false,
                  controller: buttonShakeAnimationController,
                  child: RazgovorkoButton(
                    onPressed: isStateProper
                        ? () async {
                            final user = await controller.signIn(
                              email: '${widget.parsedNumber.international.replaceAll(' ', '')}@razgovorko.com',
                              password: passwordState!.trim(),
                            );

                            if (user != null) {
                              openChat(context);
                            } else {
                              buttonShakeAnimationController.reset();
                              await buttonShakeAnimationController.forward();
                            }
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
                        'Login',
                        style: context.textStyles.onboardingButton.copyWith(
                          color: context.colors.black.withOpacity(isStateProper ? 1 : 0.25),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account?",
                      style: context.textStyles.onboardingText,
                      children: [
                        const WidgetSpan(
                          child: SizedBox(width: 4),
                        ),
                        WidgetSpan(
                          child: RazgovorkoButton(
                            onPressed: () => openOnboardingName(context),
                            child: Text(
                              'Sign up',
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
