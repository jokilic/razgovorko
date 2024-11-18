// ignore_for_file: unnecessary_lambdas

import '../models/message.dart';
import '../models/message_user_status.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class MessagesTableService {
  final LoggerService logger;

  MessagesTableService({
    required this.logger,
  });

  ///
  /// STREAMS
  ///

  /// Stream `messages` from a `chat`
  Stream<List<Message>?> streamMessages({required String chatId}) => supabase.from('messages').stream(primaryKey: ['id']).eq('chat_id', chatId).order('created_at').map(
        (data) => data.isNotEmpty ? data.map((json) => Message.fromMap(json)).toList() : null,
      );

  /// Stream message `reactions`
  Stream<List<MessageUserStatus>?> streamMessageReactions({
    required String messageId,
  }) =>
      supabase.from('reactions').stream(primaryKey: ['id']).eq('message_id', messageId).order('created_at').map(
            (data) => data.isNotEmpty ? data.map((json) => MessageUserStatus.fromMap(json)).toList() : null,
          );

  ///
  /// MESSAGES
  ///

  /// Send `message`
  Future<Message?> createMessage({
    required String chatId,
    required String content,
    required MessageType messageType,
    required bool isViewOnce,
    String? replyToMessageId,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final message = Message(
        chatId: chatId,
        senderId: userId,
        messageType: messageType,
        content: content,
        replyToMessageId: replyToMessageId,
        isViewOnce: isViewOnce,
        isDeleted: false,
        createdAt: DateTime.now(),
      );

      final messageResponse = await supabase.from('messages').insert(message.toMap()).select().maybeSingle();

      if (messageResponse != null) {
        final parsedMessage = Message.fromMap(messageResponse);

        logger.t('MessagesTableService -> createMessage() -> success!');
        return parsedMessage;
      } else {
        logger.e('MessagesTableService -> createMessage() -> messageResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('MessagesTableService -> createMessage() -> $e');
      return null;
    }
  }

  /// Edit a `message`
  Future<Message?> updateMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Update `message`
      final messageResponse = await supabase
          .from('messages')
          .update({
            'content': newContent,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', messageId)
          .eq('sender_id', userId) // Ensure user owns message
          .select()
          .maybeSingle();

      if (messageResponse != null) {
        final message = Message.fromMap(messageResponse);

        logger.t('MessagesTableService -> updateMessage() -> success!');
        return message;
      } else {
        logger.e('MessagesTableService -> updateMessage() -> messageResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('MessagesTableService -> updateMessage() -> $e');
      return null;
    }
  }

  /// Delete a `message`
  Future<Message?> deleteMessage({required String messageId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Delete `message`
      final messageResponse = await supabase
          .from('messages')
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', messageId)
          .eq('sender_id', userId) // Ensure user owns message
          .select()
          .maybeSingle();

      if (messageResponse != null) {
        final message = Message.fromMap(messageResponse);

        logger.t('MessagesTableService -> deleteMessage() -> success!');
        return message;
      } else {
        logger.e('MessagesTableService -> deleteMessage() -> messageResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('MessagesTableService -> deleteMessage() -> $e');
      return null;
    }
  }

  ///
  /// REACTIONS
  ///

  /// Add `reaction` to `message`
  Future<bool> createReaction({
    required String messageId,
    required String reaction,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final newReaction = MessageUserStatus(
        userId: userId,
        messageId: messageId,
        reaction: reaction,
        createdAt: DateTime.now(),
      );

      await supabase.from('reactions').upsert(
            newReaction.toMap(),
          );

      logger.t('MessagesTableService -> createReaction() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> createReaction() -> $e');
      return false;
    }
  }

  /// Remove reaction from message
  Future<bool> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase.from('reactions').delete().eq('message_id', messageId).eq('user_id', userId).eq('reaction', reaction);

      logger.t('MessagesTableService -> removeReaction() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> removeReaction() -> $e');
      return false;
    }
  }

  ///
  /// VIEWS
  ///

  /// Mark `message` as viewed
  Future<bool> markMessageAsViewed({required String messageId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase.from('messages').update({
        'viewed_at': DateTime.now().toIso8601String(),
      }).eq('id', messageId);

      logger.t('MessagesTableService -> markMessageAsViewed() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> markMessageAsViewed() -> $e');
      return false;
    }
  }
}
