import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/message_user_status_table_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/supabase_service.dart';

class ConversationSendController {
  final LoggerService logger;
  final ChatUserStatusTableService chatUserStatusTable;
  final MessagesTableService messagesTable;
  final MessageUserStatusTableService messageUserStatusTable;

  ConversationSendController({
    required this.logger,
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
            messageUserStatusTable.createMessageUserStatus(
              userIds: [supabase.auth.currentUser!.id, ...userIds],
              messageId: message.id,
            ),
            chatUserStatusTable.updateTypingStatus(
              chatId: chatId,
              isTyping: false,
            ),
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
