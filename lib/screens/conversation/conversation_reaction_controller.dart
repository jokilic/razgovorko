import '../../services/logger_service.dart';
import '../../services/message_user_status_table_service.dart';

class ConversationReactionController {
  final LoggerService logger;
  final MessageUserStatusTableService messageUserStatusTable;

  ConversationReactionController({
    required this.logger,
    required this.messageUserStatusTable,
  });

  ///
  /// METHODS
  ///

  /// Add `reaction` to `message`
  Future<bool> addReaction({
    required String messageId,
    required String reaction,
  }) =>
      messageUserStatusTable.createOrUpdateReaction(
        messageId: messageId,
        reaction: reaction,
      );

  /// Remove `reaction` from `message`
  Future<bool> removeReaction({
    required String messageId,
    required String reaction,
  }) =>
      messageUserStatusTable.deleteReaction(
        messageId: messageId,
      );
}
