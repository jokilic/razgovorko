import 'package:flutter/material.dart';

import '../../constants/borders.dart';
import '../../constants/images.dart';
import '../../dependencies.dart';
import '../../services/logger_service.dart';
import '../../widgets/razgovorko_button.dart';
import 'onboarding_name_controller.dart';

class OnboardingNameScreen extends StatefulWidget {
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
    final topSpacing = MediaQuery.paddingOf(context).top;
    final bottomSpacing = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///
          /// HEADER IMAGE
          ///
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, topSpacing, 40, bottomSpacing),
              child: Image.asset(
                RazgovorkoImages.onboardingIllustration,
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
                const Text(
                  'Welcome to Razgovorko',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Razgovorko will help you chat with people.',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'What is your name?',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller.nameController,
                  cursorColor: Colors.black,
                  cursorRadius: const Radius.circular(8),
                  cursorHeight: 20,
                  cursorWidth: 1.5,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 0.8,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.35),
                      letterSpacing: 0.8,
                    ),
                    labelText: 'Type your name...',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: RazgovorkoBorders.onboardingNameBorder,
                    focusedErrorBorder: RazgovorkoBorders.onboardingNameBorder,
                    disabledBorder: RazgovorkoBorders.onboardingNameBorder,
                    focusedBorder: RazgovorkoBorders.onboardingNameBorder,
                    errorBorder: RazgovorkoBorders.onboardingNameBorder,
                    enabledBorder: RazgovorkoBorders.onboardingNameBorder,
                  ),
                ),
                const SizedBox(height: 40),
                RazgovorkoButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        width: 2.5,
                        color: Colors.cyan,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account?',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const WidgetSpan(
                          child: SizedBox(width: 4),
                        ),
                        WidgetSpan(
                          child: RazgovorkoButton(
                            onPressed: () {
                              print('Hehe');
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 18,
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
