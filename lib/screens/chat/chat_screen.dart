import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/user_service.dart';
import 'chat_controller.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<ChatController>(
      () => ChatController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        user: getIt.get<UserService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<ChatController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<ChatController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: controller.streamCurrentUser(),
                  builder: (context, userSnapshot) => Text(
                    userSnapshot.data?.email ?? 'No email',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: controller.signOut,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      48,
                    ),
                  ),
                  label: Text('Sign out'.toUpperCase()),
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
