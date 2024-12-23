import 'package:flutter/material.dart';

import 'models/chat.dart';
import 'models/user.dart';
import 'onboarding/onboarding_name/onboarding_name_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/conversation/conversation_screen.dart';
import 'util/navigation.dart';

/// Opens [OnboardingNameScreen]
void openOnboardingName(BuildContext context) => pushScreen(
      OnboardingNameScreen(),
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
