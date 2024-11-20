import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/message_user_status_table_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/supabase_service.dart';

class ConversationSendController {
  final LoggerService logger;
  final ChatsTableService chatsTable;
  final ChatUserStatusTableService chatUserStatusTable;
  final MessagesTableService messagesTable;
  final MessageUserStatusTableService messageUserStatusTable;

  ConversationSendController({
    required this.logger,
    required this.chatsTable,
    required this.chatUserStatusTable,
    required this.messagesTable,
    required this.messageUserStatusTable,
  });

  ///
  /// METHODS
  ///

  /// Triggered when the `user` sends a `message`
  Future<Message?> sendMessage({
    required String chatId,
    required List<String> userIds,
    required MessageType messageType,
    required TextEditingController messageController,
  }) async {
    try {
      /// Don't send message if `message` is empty
      if (messageController.text.trim().isEmpty) {
        logger.e('ConversationSendController -> sendMessage() -> message is empty');
        return null;
      }

      final messageText = messageController.text.trim();

      /// Try to send `message`
      final message = await messagesTable.createMessage(
        chatId: chatId,
        content: messageText,
        messageType: messageType,
        isViewOnce: false,
      );

      /// Message sent successfully
      if (message != null) {
        /// Clear `messageController`
        messageController.clear();

        /// Update relevant database values
        await Future.wait(
          [
            /// Updates `lastMessageId` in `chat` table
            chatsTable.updateChat(
              chatId: chatId,
              lastMessageId: message.id,
            ),

            /// Creates [MessageUserStatus] for each `user`
            messageUserStatusTable.createMessageUserStatus(
              userIds: [supabase.auth.currentUser!.id, ...userIds],
              messageId: message.id,
            ),

            /// Updates typing status for `user`
            chatUserStatusTable.updateTypingStatus(
              chatId: chatId,
              isTyping: false,
            ),

            /// Marks chat as read for for `user`
            chatUserStatusTable.markChatAsRead(
              chatId: chatId,
              lastMessageId: message.id,
            ),
          ],
        );

        logger.t('ConversationSendController -> sendMessage() -> success!');
        return message;
      }

      /// Message failed to send
      else {
        logger.e('ConversationSendController -> sendMessage() -> message == null');
        return null;
      }
    } catch (e) {
      logger.e('ConversationSendController -> sendMessage() -> $e');
      return null;
    }
  }
}
