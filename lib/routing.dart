import 'package:flutter/material.dart';

import 'models/chat.dart';
import 'models/user.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/conversation/conversation_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'util/navigation.dart';

/// Opens [WelcomeScreen]
void openWelcome(BuildContext context) => pushScreen(
      WelcomeScreen(),
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
