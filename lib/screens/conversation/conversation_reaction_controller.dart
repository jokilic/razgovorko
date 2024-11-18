import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';

class ConversationReactionController {
  final LoggerService logger;
  final MessagesTableService messagesTable;

  ConversationReactionController({
    required this.logger,
    required this.messagesTable,
  });

  ///
  /// METHODS
  ///

  /// Add `reaction` to `message`
  Future<bool> addReaction({
    required String messageId,
    required String reaction,
  }) =>
      messagesTable.createReaction(
        messageId: messageId,
        reaction: reaction,
      );

  /// Remove `reaction` from `message`
  Future<bool> removeReaction({
    required String messageId,
    required String reaction,
  }) =>
      messagesTable.removeReaction(
        messageId: messageId,
        reaction: reaction,
      );
}
