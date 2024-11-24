// ignore_for_file: unnecessary_lambdas

import '../models/message_user_status.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class MessageUserStatusTableService {
  final LoggerService logger;

  MessageUserStatusTableService({
    required this.logger,
  });

  ///
  /// STREAMS
  ///

  /// Stream `message` status (reactions and views)
  Stream<List<MessageUserStatus>?> streamMessageStatus({
    required String messageId,
  }) =>
      supabase.from('message_user_status').stream(primaryKey: ['id']).eq('message_id', messageId).map(
            (rows) => rows.map((row) => MessageUserStatus.fromMap(row)).toList(),
          );

  ///
  /// METHODS
  ///

  Future<bool> createMessageUserStatus({
    required List<String> otherUserIds,
    required String messageId,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final now = DateTime.now();

      /// Create a list of `participants`
      final allParticipants = {userId, ...otherUserIds}.toList();

      /// Create [MessageUserStatus] entries for all `participants`
      await Future.wait(
        allParticipants.map(
          (uid) {
            final messageUserStatus = MessageUserStatus(
              userId: userId,
              messageId: messageId,
              createdAt: now,
            );

            return supabase.from('message_user_status').insert(
                  messageUserStatus.toMap(),
                );
          },
        ),
      );

      logger.t('MessageUserStatusTableService -> createMessageUserStatus() -> success!');
      return true;
    } catch (e) {
      logger.e('MessageUserStatusTableService -> createMessageUserStatus() -> $e');
      return false;
    }
  }

  /// Mark `message` as viewed
  Future<bool> markMessageAsViewed({required String messageId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase
          .from('message_user_status')
          .update({
            'viewed_at': DateTime.now().toIso8601String(),
          })
          .eq('message_id', messageId)
          .eq('user_id', userId);

      logger.t('MessagesTableService -> markMessageAsViewed() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> markMessageAsViewed() -> $e');
      return false;
    }
  }

  /// Creates or updates a `reaction`
  Future<bool> createOrUpdateReaction({
    required String messageId,
    String? reaction, // `null` to remove reaction
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase
          .from('message_user_status')
          .update({
            'reaction': reaction,
          })
          .eq('message_id', messageId)
          .eq('user_id', userId);

      logger.t('MessageUserStatusService -> createOrUpdateReaction() -> success!');
      return true;
    } catch (e) {
      logger.e('MessageUserStatusService -> createOrUpdateReaction() -> $e');
      return false;
    }
  }

  /// Remove reaction from `message`
  Future<bool> deleteReaction({required String messageId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase.from('message_user_status').delete().eq('message_id', messageId).eq('user_id', userId);

      logger.t('MessagesTableService -> deleteReaction() -> success!');
      return true;
    } catch (e) {
      logger.e('MessagesTableService -> deleteReaction() -> $e');
      return false;
    }
  }
}
