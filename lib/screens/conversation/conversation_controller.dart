import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/message.dart';
import '../../services/auth_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../util/state.dart';

class ConversationController extends ValueNotifier<RazgovorkoState<String>> implements Disposable {
  final LoggerService logger;
  final AuthService auth;
  final ChatsTableService chatsTable;
  final MessagesTableService messagesTable;

  ConversationController({
    required this.logger,
    required this.auth,
    required this.chatsTable,
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
  Future<void> init({required String otherUserId}) async {
    try {
      value = Loading();

      /// Try to fetch `chatId`
      final chatId = await getChatId(otherUserId: otherUserId);

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

  /// Return `chatId` from existing or new `chat` between `currentUser` and `otherUser`
  Future<String?> getChatId({required String otherUserId}) async {
    try {
      /// Try to get existing `chatId`
      final existingChat = await chatsTable.fetchExistingChat(
        otherUserId: otherUserId,
      );

      /// `chatId` exists
      if (existingChat?.id != null) {
        logger.t('ConversationController -> getChatId() -> existing chat -> success!');
        return existingChat!.id;
      }

      /// `chat` doesn't exist, create a new one
      else {
        final newChat = await chatsTable.createChatAndParticipants(
          otherUserId: otherUserId,
        );

        /// `chat` successfully created, return `chatId`
        if (newChat?.id != null) {
          logger.t('ConversationController -> getChatId() -> new chat -> success!');
          return newChat!.id;
        }

        /// Error creatubg `chat`, return `null`
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
  Stream<List<Message>> streamMessages({required String chatId}) => messagesTable.streamMessages(chatId: chatId);

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
      final messageSent = await messagesTable.sendMessage(
        chatId: chatId,
        messageText: messageText,
      );

      /// Message sent successfully, clear `messageController`
      if (messageSent) {
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
