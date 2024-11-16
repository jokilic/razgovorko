import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/chat.dart';
import '../../models/message.dart';
import '../../services/auth_service.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/supabase_service.dart';
import '../../util/state.dart';

class ConversationController extends ValueNotifier<RazgovorkoState<String>> implements Disposable {
  final LoggerService logger;
  final AuthService auth;
  final ChatsTableService chatsTable;
  final ChatUserStatusTableService chatUserStatusTable;
  final MessagesTableService messagesTable;

  ConversationController({
    required this.logger,
    required this.auth,
    required this.chatsTable,
    required this.chatUserStatusTable,
    required this.messagesTable,
  }) : super(Initial());

  ///
  /// VARIABLES
  ///

  final messageController = TextEditingController();

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    messageController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Gets `chatId` and stores in `state`
  Future<void> init({
    required List<String> otherUserIds,
    required ChatType chatType,
    String? name,
  }) async {
    try {
      value = Loading();

      /// Try to fetch `chatId`
      final chatId = await getChatId(
        otherUserIds: otherUserIds,
        chatType: chatType,
        name: name,
      );

      /// `chatId` fetched
      if (chatId != null) {
        value = Success(data: chatId);
        logger.t('ConversationController -> init() -> success!');
      }

      /// `chatId` isn't fetched
      else {
        value = Error(error: "chatId isn't fetched");
        logger.e("ConversationController -> init() -> chatId isn't fetched");
      }
    } catch (e) {
      value = Error(error: '$e');
      logger.e('ConversationController -> init() -> $e');
    }
  }

  /// Return `chatId` from existing or new `chat` between `currentUser` and `otherUsers`
  Future<String?> getChatId({
    required List<String> otherUserIds,
    required ChatType chatType,
    String? name,
  }) async {
    try {
      /// Try to get existing `chatId`
      final existingChat = await chatsTable.getChat(
        otherUserIds: otherUserIds,
        chatType: chatType,
        name: name,
      );

      /// `chatId` exists
      if (existingChat?.id != null) {
        logger.t('ConversationController -> getChatId() -> existing chat -> success!');
        return existingChat!.id;
      }

      /// `chat` doesn't exist, create a new one
      else {
        final newChat = await chatsTable.createChat(
          otherUserIds: otherUserIds,
          chatType: chatType,
          name: name,
        );

        /// Create [ChatUserStatus] for each `participant`
        if (newChat?.id != null) {
          final chatUserStatus = await chatUserStatusTable.createChatUserStatus(
            participants: [supabase.auth.currentUser!.id, ...otherUserIds],
            chatId: newChat!.id,
          );

          /// `chat` successfully created, return it
          if (chatUserStatus) {
            logger.t('ConversationController -> getChatId() -> new chat -> success!');
            return newChat.id;
          }

          /// Error creating [ChatUserStatus], return `null`
          else {
            logger.e('ConversationController -> getChatId() -> newChat == null');
            return null;
          }
        }

        /// Error creating `chat`, return `null`
        else {
          logger.e('ConversationController -> getChatId() -> newChat == null');
          return null;
        }
      }
    } catch (e) {
      logger.e('ConversationController -> getChatId() -> $e');
      return null;
    }
  }

  /// Returns a [Stream] which listens `List<Message>` within the `messages` table
  Stream<List<Message>?> streamMessages({required String chatId}) => messagesTable.streamMessages(chatId: chatId);

  /// Triggered when the user sends a message
  Future<bool> sendMessage({
    required String chatId,
  }) async {
    try {
      /// Don't send message if there is no `chatId`
      if (value is! Success) {
        logger.e('ConversationController -> sendMessage() -> no chatId');
        return false;
      }

      /// Don't send message if `message` is empty
      if (messageController.text.trim().isEmpty) {
        logger.e('ConversationController -> sendMessage() -> message is empty');
        return false;
      }

      final messageText = messageController.text.trim();

      /// Try to send message
      final message = await messagesTable.sendMessage(
        chatId: chatId,
        content: messageText,
        messageType: MessageType.text,
        isViewOnce: false,
      );

      /// Message sent successfully, clear `messageController`
      if (message != null) {
        messageController.clear();
        logger.t('ConversationController -> sendMessage() -> success!');
        return true;
      }

      /// Message failed to send
      else {
        logger.e('ConversationController -> sendMessage() -> messageSent is false');
        return false;
      }
    } catch (e) {
      logger.e('ConversationController -> sendMessage() -> $e');
      return false;
    }
  }
}
