import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../dependencies.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/message_user_status_table_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/supabase_service.dart';
import '../../util/state.dart';
import 'conversation_controller.dart';
import 'conversation_management_controller.dart';
import 'conversation_reaction_controller.dart';
import 'conversation_send_controller.dart';
import 'conversation_typing_controller.dart';

class ConversationScreen extends WatchingStatefulWidget {
  final List<RazgovorkoUser> otherUsers;
  final ChatType chatType;
  final String? chatName;

  const ConversationScreen({
    required this.otherUsers,
    required this.chatType,
    required this.chatName,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final otherUserIds = widget.otherUsers.map((user) => user.id).toList();

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<ConversationSendController>(
      () => ConversationSendController(
        logger: getIt.get<LoggerService>(),
        chatsTable: getIt.get<ChatsTableService>(),
        chatUserStatusTable: getIt.get<ChatUserStatusTableService>(),
        messagesTable: getIt.get<MessagesTableService>(),
        messageUserStatusTable: getIt.get<MessageUserStatusTableService>(),
      ),
    );
    registerIfNotInitialized<ConversationTypingController>(
      () => ConversationTypingController(
        logger: getIt.get<LoggerService>(),
        chatUserStatusTable: getIt.get<ChatUserStatusTableService>(),
      ),
    );
    registerIfNotInitialized<ConversationManagementController>(
      () => ConversationManagementController(
        logger: getIt.get<LoggerService>(),
        chatsTable: getIt.get<ChatsTableService>(),
        chatUserStatusTable: getIt.get<ChatUserStatusTableService>(),
      ),
    );
    registerIfNotInitialized<ConversationReactionController>(
      () => ConversationReactionController(
        logger: getIt.get<LoggerService>(),
        messageUserStatusTable: getIt.get<MessageUserStatusTableService>(),
      ),
    );
    registerIfNotInitialized<ConversationController>(
      () => ConversationController(
        logger: getIt.get<LoggerService>(),
        chatsTable: getIt.get<ChatsTableService>(),
        chatUserStatusTable: getIt.get<ChatUserStatusTableService>(),
        messagesTable: getIt.get<MessagesTableService>(),
      ),
      afterRegister: (controller) => controller.init(
        otherUserIds: otherUserIds,
        chatType: widget.chatType,
        name: widget.chatName,
      ),
    );
  }

  @override
  void dispose() {
    getIt
      ..unregister<ConversationSendController>()
      ..unregister<ConversationTypingController>()
      ..unregister<ConversationManagementController>()
      ..unregister<ConversationReactionController>()
      ..unregister<ConversationController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<ConversationController>();
    final sendController = getIt.get<ConversationSendController>();
    final conversationState = watchIt<ConversationController>().value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversation with ${widget.otherUsers.map((user) => user.displayName).toList()}',
        ),
      ),
      body: SafeArea(
        child: switch (conversationState) {
          Initial() => Container(
              color: Colors.grey,
            ),
          Loading() => Container(
              color: Colors.yellow,
            ),
          Empty() => Container(
              color: Colors.cyan,
            ),
          Error(error: final error) => Container(
              color: Colors.red,
              child: Text(error ?? 'no_error'),
            ),
          Success(data: final chatId) => Column(
              children: [
                ///
                /// MESSAGES
                ///
                Expanded(
                  child: StreamBuilder(
                    stream: controller.streamMessages(
                      chatId: chatId,
                    ),
                    builder: (context, messagesSnapshot) {
                      ///
                      /// LOADING
                      ///
                      if (messagesSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      ///
                      /// ERROR
                      ///
                      if (messagesSnapshot.hasError) {
                        return Text(
                          messagesSnapshot.error.toString(),
                        );
                      }

                      ///
                      /// SUCCESS
                      ///
                      if (messagesSnapshot.hasData) {
                        final messages = messagesSnapshot.data;

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: messages?.length ?? 0,
                          itemBuilder: (_, index) {
                            final message = messages![index];

                            final isMe = message.senderId == supabase.auth.currentUser?.id;

                            return ListTile(
                              title: Text(
                                message.content,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: isMe ? TextAlign.left : TextAlign.right,
                              ),
                              subtitle: Text(
                                message.createdAt.toIso8601String(),
                                textAlign: isMe ? TextAlign.left : TextAlign.right,
                              ),
                              leading: isMe
                                  ? const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                              trailing: !isMe
                                  ? const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        );
                      }

                      return const Text(
                        "This shouldn't happen",
                      );
                    },
                  ),
                ),

                ///
                /// TEXT FIELD
                ///
                TextField(
                  onSubmitted: (_) => sendController.sendMessage(
                    chatId: chatId,
                    userIds: otherUserIds,
                    messageType: MessageType.text,
                    messageController: controller.messageController,
                  ),
                  controller: controller.messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message...',
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
