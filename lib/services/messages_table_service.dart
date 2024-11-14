// ignore_for_file: unnecessary_lambdas

import '../models/message.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class MessagesTableService {
  final LoggerService logger;

  MessagesTableService({
    required this.logger,
  });

  ///
  /// METHODS
  ///

  /// Stream `List<Message>` from the [Chat] with `chatId`
  Stream<List<Message>> streamMessages({required String chatId}) => supabase.from('messages').stream(primaryKey: ['id']).eq('chat_id', chatId).order('created_at').map(
        (data) => data.map((json) => Message.fromMap(json)).toList(),
      );

  /// Store [Message] in [Supabase]
  Future<bool> sendMessage({
    required String chatId,
    required String messageText,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Create new [Message] model
      final message = Message(
        chatId: chatId,
        senderId: userId,
        messageType: MessageType.text,
        content: messageText,
        isViewOnce: false,
        isDeleted: false,
        createdAt: DateTime.now(),
      );

      /// Store in [Supabase]
      await supabase.from('messages').insert(message.toMap());

      logger.t('MessagesTableService -> sendMessage() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> sendMessage() -> $e');
      return false;
    }
  }
}
