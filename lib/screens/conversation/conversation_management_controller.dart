import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/supabase_service.dart';

class ConversationManagementController {
  final LoggerService logger;
  final ChatsTableService chatsTable;
  final ChatUserStatusTableService chatUserStatusTable;

  ConversationManagementController({
    required this.logger,
    required this.chatsTable,
    required this.chatUserStatusTable,
  });

  ///
  /// METHODS
  ///

  /// Add `participants` to `chat`
  Future<bool> addParticipants({
    required String chatId,
    required List<String> userIds,
  }) async {
    /// Add new `participants`
    final participantsResponse = await chatsTable.addParticipants(
      chatId: chatId,
      newParticipantIds: userIds,
    );

    /// Create [ChatUserStatus] for new `participants`
    if (participantsResponse) {
      final chatUserStatusResponse = await chatUserStatusTable.createChatUserStatus(
        otherUserIds: userIds,
        chatId: chatId,
      );

      if (chatUserStatusResponse) {
        logger.t('ConversationManagementController -> leaveChat() -> success!');
        return true;
      } else {
        logger.e('ConversationManagementController -> leaveChat() -> chatUserStatusResponse == null');
        return false;
      }
    } else {
      logger.e('ConversationManagementController -> leaveChat() -> participantsResponse ==  null');
      return false;
    }
  }

  /// Leave `chat`
  Future<void> leaveChat({required String chatId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await Future.wait(
        [
          chatUserStatusTable.leaveChat(chatId: chatId),
          chatsTable.deleteParticipants(
            chatId: chatId,
            participantIds: [userId],
          ),
          chatUserStatusTable.removeChatUserStatus(
            userChatIds: [userId],
            chatId: chatId,
          ),
        ],
      );

      logger.t('ConversationManagementController -> leaveChat() -> success!');
    } catch (e) {
      logger.e('ConversationManagementController -> leaveChat() -> $e');
    }
  }
}
