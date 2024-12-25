import 'package:flutter/material.dart';

import 'models/chat.dart';
import 'models/parsed_number.dart';
import 'models/user.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/conversation/conversation_screen.dart';
import 'screens/login/login_number/login_number_screen.dart';
import 'screens/login/login_password/login_password_screen.dart';
import 'screens/onboarding/onboarding_additional/onboarding_additional_screen.dart';
import 'screens/onboarding/onboarding_finish/onboarding_finish_screen.dart';
import 'screens/onboarding/onboarding_name/onboarding_name_screen.dart';
import 'screens/onboarding/onboarding_number/onboarding_number_screen.dart';
import 'screens/onboarding/onboarding_password/onboarding_password_screen.dart';
import 'util/navigation.dart';

/// Opens [LoginNumberScreen]
void openLoginNumber(BuildContext context) => pushScreen(
      LoginNumberScreen(),
      context: context,
      popEverything: true,
    );

/// Opens [LoginPasswordScreen]
void openLoginPassword(
  BuildContext context, {
  required ParsedNumber parsedNumber,
}) =>
    pushScreen(
      LoginPasswordScreen(
        parsedNumber: parsedNumber,
      ),
      context: context,
    );

/// Opens [OnboardingNameScreen]
void openOnboardingName(BuildContext context) => pushScreen(
      OnboardingNameScreen(),
      context: context,
      popEverything: true,
    );

/// Opens [OnboardingNumberScreen]
void openOnboardingNumber(
  BuildContext context, {
  required String name,
}) =>
    pushScreen(
      OnboardingNumberScreen(
        name: name,
      ),
      context: context,
    );

/// Opens [OnboardingPasswordScreen]
void openOnboardingPassword(
  BuildContext context, {
  required String name,
  required ParsedNumber parsedNumber,
}) =>
    pushScreen(
      OnboardingPasswordScreen(
        name: name,
        parsedNumber: parsedNumber,
      ),
      context: context,
    );

/// Opens [OnboardingAdditionalScreen]
void openOnboardingAdditional(
  BuildContext context, {
  required String name,
  required ParsedNumber parsedNumber,
  required String password,
}) =>
    pushScreen(
      OnboardingAdditionalScreen(
        name: name,
        parsedNumber: parsedNumber,
        password: password,
      ),
      context: context,
    );

/// Opens [OnboardingFinishScreen]
void openOnboardingFinish(
  BuildContext context, {
  required String name,
  required ParsedNumber parsedNumber,
  required String password,
  required String? avatarUrl,
  required String? aboutMe,
  required String? status,
  required String? location,
  required DateTime? dateOfBirth,
}) =>
    pushScreen(
      OnboardingFinishScreen(
        name: name,
        parsedNumber: parsedNumber,
        password: password,
        avatarUrl: avatarUrl,
        aboutMe: aboutMe,
        status: status,
        location: location,
        dateOfBirth: dateOfBirth,
      ),
      context: context,
    );

/// Opens [ChatScreen]
void openChat(BuildContext context) => pushScreen(
      ChatScreen(),
      context: context,
      popEverything: true,
    );

/// Opens [ConversationScreen]
void openConversation(
  BuildContext context, {
  required List<RazgovorkoUser> otherUsers,
  required ChatType chatType,
  required String? chatName,
}) =>
    pushScreen(
      ConversationScreen(
        otherUsers: otherUsers,
        chatType: chatType,
        chatName: chatName,
      ),
      context: context,
    );
