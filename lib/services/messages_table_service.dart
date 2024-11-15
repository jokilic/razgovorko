// ignore_for_file: unnecessary_lambdas

import '../models/message.dart';
import '../models/reaction.dart';
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
  Stream<List<Reaction>?> streamMessageReactions({
    required String messageId,
  }) =>
      supabase.from('reactions').stream(primaryKey: ['id']).eq('message_id', messageId).order('created_at').map(
            (data) => data.isNotEmpty ? data.map((json) => Reaction.fromMap(json)).toList() : null,
          );

  ///
  /// MESSAGES
  ///

  /// Store `message` in [Supabase]
  Future<Message?> sendMessage({
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

      final now = DateTime.now();

      final message = Message(
        chatId: chatId,
        senderId: userId,
        messageType: messageType,
        content: content,
        replyToMessageId: replyToMessageId,
        isViewOnce: isViewOnce,
        isDeleted: false,
        createdAt: now,
      );

      final messageResponse = await supabase.from('messages').insert(message.toMap()).select().maybeSingle();

      if (messageResponse != null) {
        final parsedMessage = Message.fromMap(messageResponse);

        logger.t('MessagesTableService -> _sendMessage() -> success!');
        return parsedMessage;
      } else {
        logger.e('MessagesTableService -> _sendMessage() -> messageResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('MessagesTableService -> _sendMessage() -> $e');
      return null;
    }
  }

  /// Edit a `message`
  Future<Message?> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Get existing `message`
      final messageResponse = await supabase.from('messages').select().eq('id', messageId).maybeSingle();

      if (messageResponse != null) {
        final message = Message.fromMap(messageResponse);

        /// Verify ownership
        if (message.senderId != userId) {
          throw Exception('Cannot edit message from another user');
        }

        // Update message
        final updatedMessageResponse = await supabase
            .from('messages')
            .update({
              'content': newContent,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', messageId)
            .select()
            .maybeSingle();

        if (updatedMessageResponse != null) {
          final updatedMessage = Message.fromMap(updatedMessageResponse);

          logger.t('MessagesTableService -> editMessage() -> success!');
          return updatedMessage;
        } else {
          logger.e('MessagesTableService -> editMessage() -> updatedMessageResponse == null');
          return null;
        }
      } else {
        logger.e('MessagesTableService -> editMessage() -> messageResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('MessagesTableService -> editMessage() -> $e');
      return null;
    }
  }

  /// Delete a `message`
  Future<bool> deleteMessage({required String messageId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase
          .from('messages')
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', messageId)
          .eq('sender_id', userId); // Ensure user owns message

      logger.t('MessagesTableService -> deleteMessage() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> deleteMessage() -> $e');
      return false;
    }
  }

  ///
  /// REACTIONS
  ///

  /// Add `reaction` to `message`
  Future<bool> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase.from('reactions').upsert(
            Reaction(
              userId: userId,
              messageId: messageId,
              reaction: reaction,
              createdAt: DateTime.now(),
            ).toMap(),
          );

      logger.t('MessagesTableService -> addReaction() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> addReaction() -> $e');
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
