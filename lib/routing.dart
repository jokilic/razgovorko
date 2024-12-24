import 'package:flutter/material.dart';

import 'models/chat.dart';
import 'models/parsed_number.dart';
import 'models/user.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/conversation/conversation_screen.dart';
import 'screens/onboarding/onboarding_name/onboarding_name_screen.dart';
import 'screens/onboarding/onboarding_number/onboarding_number_screen.dart';
import 'screens/onboarding/onboarding_password/onboarding_password_screen.dart';
import 'util/navigation.dart';

/// Opens [OnboardingNameScreen]
void openOnboardingName(BuildContext context) => pushScreen(
      OnboardingNameScreen(),
      context: context,
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

/// Opens [ChatScreen]
void openChat(BuildContext context) => pushScreen(
      ChatScreen(),
      context: context,
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
