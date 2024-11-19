import '../../models/user.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/logger_service.dart';

class ConversationTypingController {
  final LoggerService logger;
  final ChatUserStatusTableService chatUserStatusTable;

  ConversationTypingController({
    required this.logger,
    required this.chatUserStatusTable,
  });

  ///
  /// STREAMS
  ///

  /// Returns a [Stream] which listens to typing `userIds`
  Stream<List<RazgovorkoUser>> streamTypingUsers({
    required String chatId,
  }) =>
      chatUserStatusTable.streamTypingUsers(
        chatId: chatId,
      );

  ///
  /// METHODS
  ///

  /// Handle typing status
  Future<void> updateTypingStatus({
    required String chatId,
    required bool isTyping,
  }) =>
      chatUserStatusTable.updateTypingStatus(
        chatId: chatId,
        isTyping: isTyping,
      );
}
