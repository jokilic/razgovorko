import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../../routing.dart';
import '../../services/auth_service.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/users_table_service.dart';
import 'chat_controller.dart';
import 'chat_users_controller.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<ChatUsersController>(
      () => ChatUsersController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
      ),
    );
    registerIfNotInitialized<ChatController>(
      () => ChatController(
        logger: getIt.get<LoggerService>(),
        auth: getIt.get<AuthService>(),
        usersTable: getIt.get<UsersTableService>(),
        chatsTable: getIt.get<ChatsTableService>(),
        chatUserStatusTable: getIt.get<ChatUserStatusTableService>(),
        messagesTable: getIt.get<MessagesTableService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt
      ..unregister<ChatUsersController>()
      ..unregister<ChatController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersController = getIt.get<ChatUsersController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: Column(
            children: [
              StreamBuilder(
                stream: usersController.streamCurrentUser(),
                builder: (context, userSnapshot) => Text(
                  userSnapshot.data?.email ?? 'No email',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: usersController.signOut,
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
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder(
                  stream: usersController.streamAllUsers(),
                  builder: (context, usersSnapshot) {
                    ///
                    /// LOADING
                    ///
                    if (usersSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    ///
                    /// ERROR
                    ///
                    if (usersSnapshot.hasError) {
                      return Text(
                        usersSnapshot.error.toString(),
                      );
                    }

                    ///
                    /// SUCCESS
                    ///
                    if (usersSnapshot.hasData) {
                      final users = usersSnapshot.data;

                      return ListView.builder(
                        itemCount: users?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          final user = users![index];

                          return ListTile(
                            onTap: () => openConversation(
                              context,
                              otherUser: user,
                            ),
                            title: Text(user.displayName),
                            subtitle: Text(user.email),
                            leading: const Icon(Icons.person_rounded),
                          );
                        },
                      );
                    }

                    return Text(
                      usersSnapshot.error.toString(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
