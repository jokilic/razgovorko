import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../constants/borders.dart';
import '../../../../constants/images.dart';
import '../../../../dependencies.dart';
import '../../../../routing.dart';
import '../../../../services/logger_service.dart';
import '../../../../services/users_table_service.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/razgovorko_button.dart';
import '../../onboarding/widgets/onboarding_text_field.dart';
import 'login_number_controller.dart';

class LoginNumberScreen extends WatchingStatefulWidget {
  @override
  State<LoginNumberScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginNumberScreen> with SingleTickerProviderStateMixin {
  late final AnimationController buttonShakeAnimationController;

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<LoginNumberController>(
      () => LoginNumberController(
        logger: getIt.get<LoggerService>(),
        usersTable: getIt.get<UsersTableService>(),
      ),
      afterRegister: (controller) => controller.init(),
    );

    buttonShakeAnimationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    getIt.unregister<LoginNumberController>();
    buttonShakeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<LoginNumberController>();
    final numberState = watchIt<LoginNumberController>().value;

    final isStateProper = controller.isStateProper(numberState);

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
              child: Center(
                child: Image.asset(
                  RazgovorkoImages.illustration2,
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
                  'What is your phone number?',
                  style: context.textStyles.onboardingText,
                ),
                const SizedBox(height: 4),
                OnboardingTextField(
                  onChanged: (newNumber) => controller.updateState(
                    newNumber: newNumber,
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  prefix: CountryCodePicker(
                    searchPadding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    searchStyle: context.textStyles.onboardingTextField,
                    searchDecoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      alignLabelWithHint: true,
                      labelStyle: context.textStyles.onboardingTextFieldLabel,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: RazgovorkoBorders.onboardingBorder,
                      focusedErrorBorder: RazgovorkoBorders.onboardingBorder,
                      disabledBorder: RazgovorkoBorders.onboardingBorder,
                      focusedBorder: RazgovorkoBorders.onboardingBorder,
                      errorBorder: RazgovorkoBorders.onboardingBorder,
                      enabledBorder: RazgovorkoBorders.onboardingBorder,
                    ),
                    hideCloseIcon: true,
                    emptySearchBuilder: (context) => Text(
                      'No country found',
                      style: context.textStyles.onboardingText,
                      textAlign: TextAlign.center,
                    ),
                    mode: CountryCodePickerMode.bottomSheet,
                    onInit: (country) => WidgetsBinding.instance.addPostFrameCallback(
                      (_) => controller.updateState(
                        newCountryCode: country?.dialCode,
                      ),
                    ),
                    onChanged: (country) => controller.updateState(
                      newCountryCode: country.dialCode,
                    ),
                    initialSelection: 'HR',
                    flagDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: context.colors.white,
                    flagWidth: 48,
                    dialogItemPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    icon: const SizedBox.shrink(),
                    dialogTextStyle: context.textStyles.onboardingText,
                    textStyle: context.textStyles.onboardingTextField,
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
                    onPressed: isStateProper
                        ? () async {
                            /// Try to parse number
                            final parsedNumber = await controller.getParsedNumberFromState();

                            /// Number is proper, check if user exists
                            if (parsedNumber != null) {
                              final userExists = await controller.getUserExistsInDatabase(
                                parsedNumber: parsedNumber,
                              );

                              if (userExists) {
                                openLoginPassword(
                                  context,
                                  parsedNumber: parsedNumber,
                                );
                              } else {
                                buttonShakeAnimationController.reset();
                                await buttonShakeAnimationController.forward();
                              }
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
                        'Continue',
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
