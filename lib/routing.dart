import 'package:flutter/material.dart';

import 'models/user.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/conversation/conversation_screen.dart';
import 'screens/login/login_screen.dart';
import 'util/navigation.dart';

/// Opens [LoginScreen]
void openLogin(BuildContext context) => pushScreen(
      LoginScreen(),
      context: context,
    );

/// Opens [ChatScreen]
void openChat(BuildContext context) => pushScreen(
      ChatScreen(),
      context: context,
    );

/// Opens [ConversationScreen]
void openConversation(BuildContext context, {required RazgovorkoUser otherUser}) => pushScreen(
      ConversationScreen(
        otherUser: otherUser,
      ),
      context: context,
    );
