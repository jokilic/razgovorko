import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/chat.dart';
import '../../models/message.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/supabase_service.dart';
import '../../util/state.dart';

class ConversationController extends ValueNotifier<RazgovorkoState<String>> implements Disposable {
  final LoggerService logger;
  final ChatsTableService chatsTable;
  final ChatUserStatusTableService chatUserStatusTable;
  final MessagesTableService messagesTable;

  ConversationController({
    required this.logger,
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
  /// STREAMS
  ///

  /// Returns a [Stream] which listens `List<Message>` within the `messages` table
  Stream<List<Message>?> streamMessages({required String chatId}) => messagesTable.streamMessages(chatId: chatId);

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
        const error = 'ConversationController -> init() -> chatId == null';
        value = Error(error: error);
        logger.e(error);
      }
    } catch (e) {
      final error = 'ConversationController -> init() -> $e';
      value = Error(error: error);
      logger.e(error);
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
            userIds: [supabase.auth.currentUser!.id, ...otherUserIds],
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

  /// Mark `chat` as read
  Future<void> markChatAsRead({
    required String chatId,
    required String lastMessageId,
  }) =>
      chatUserStatusTable.markChatAsRead(
        chatId: chatId,
        lastMessageId: lastMessageId,
      );

  /// Mute `chat`
  Future<void> muteChat({
    required String chatId,
    required bool isMuted,
  }) =>
      chatUserStatusTable.updateMuteSettings(
        chatId: chatId,
        isMuted: isMuted,
      );
}
