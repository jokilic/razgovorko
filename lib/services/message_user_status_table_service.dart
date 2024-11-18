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

      final now = DateTime.now();

      /// Fetch existing [MessageUserStatus]
      final existingStatusResponse = await supabase.from('message_user_status').select().eq('message_id', messageId).eq('user_id', userId).maybeSingle();

      if (existingStatusResponse != null) {
        final existingStatus = MessageUserStatus.fromMap(existingStatusResponse);

        await supabase.from('message_user_status').upsert(
              existingStatus
                  .copyWith(
                    userId: userId,
                    messageId: messageId,
                    reaction: reaction,
                    updatedAt: now,
                    deletedAt: reaction == null ? now : null,
                  )
                  .toMap(),
            );

        logger.t('MessageUserStatusService -> updateReaction() -> success!');
        return true;
      } else {
        logger.e('MessageUserStatusService -> updateReaction() -> existingStatusResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('MessageUserStatusService -> updateReaction() -> $e');
      return false;
    }
  }

  /// Mark `message` as viewed
  Future<bool> markAsViewed({required String messageId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final now = DateTime.now();

      /// Fetch existing [MessageUserStatus]
      final existingStatusResponse = await supabase.from('message_user_status').select().eq('message_id', messageId).eq('user_id', userId).maybeSingle();

      if (existingStatusResponse != null) {
        final existingStatus = MessageUserStatus.fromMap(existingStatusResponse);

        await supabase.from('message_user_status').upsert(
              existingStatus
                  .copyWith(
                    userId: userId,
                    messageId: messageId,
                    viewedAt: now,
                    updatedAt: now,
                  )
                  .toMap(),
            );

        logger.t('MessageUserStatusService -> markAsViewed() -> success!');
        return true;
      } else {
        logger.e('MessageUserStatusService -> markAsViewed() -> existingStatusResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('MessageUserStatusService -> markAsViewed() -> $e');
      return false;
    }
  }
}
