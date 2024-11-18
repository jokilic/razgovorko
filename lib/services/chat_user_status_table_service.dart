import '../models/chat_user_status.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class ChatUserStatusTableService {
  final LoggerService logger;

  ChatUserStatusTableService({
    required this.logger,
  });

  ///
  /// STREAMS
  ///

  /// Stream typing `userIds`
  Stream<List<String>> streamTypingUserIds({required String chatId}) {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return supabase.from('chat_user_status').stream(primaryKey: ['id']).eq('chat_id', chatId).map(
          (rows) => rows.where((row) => row['user_id'] != userId && row['is_typing'] == true).map((row) => row['user_id'] as String).toList(),
        );
  }

  /// Stream unread counts for all `chats`
  Stream<Map<String, int>?> streamUnreadCounts({required List<String> chatIds}) {
    if (chatIds.isEmpty) {
      return Stream.value(null);
    }

    return supabase.from('messages').stream(primaryKey: ['id']).map(
      (_) async {
        final counts = <String, int>{};

        for (final chatId in chatIds) {
          counts[chatId] = await getUnreadCount(
                chatId: chatId,
              ) ??
              0;
        }

        return counts;
      },
    ).asyncMap(
      (future) => future,
    );
  }

  ///
  /// METHODS
  ///

  /// User joins / creates a `chat`
  Future<bool> createChatUserStatus({
    required List<String> participants,
    required String chatId,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Create [ChatUserStatus] entries for all `participants`
      await Future.wait(
        participants.map(
          (participantId) {
            final chatUserStatus = ChatUserStatus(
              userId: participantId,
              chatId: chatId,
              isMuted: false,
              isTyping: false,
              role: participantId == userId ? ChatRole.owner : ChatRole.member,
              joinedAt: DateTime.now(),
            );

            return supabase.from('chat_user_status').upsert(
                  chatUserStatus.toMap(),
                );
          },
        ),
      );

      logger.t('ChatUserStatusTableService -> createChatUserStatus() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> createChatUserStatus() -> $e');
      return false;
    }
  }

  /// User leaves a `chat`
  Future<bool> removeChatUserStatus({
    required List<String> participants,
    required String chatId,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Update [ChatUserStatus] for removed `participants`
      await supabase
          .from('chat_user_status')
          .update({
            'left_at': DateTime.now().toIso8601String(),
          })
          .eq('chat_id', chatId)
          .inFilter('user_id', participants);

      logger.t('ChatUserStatusTableService -> removeChatUserStatus() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> removeChatUserStatus() -> $e');
      return false;
    }
  }

  /// Updates typing value in the table
  Future<bool> updateTypingStatus({
    required String chatId,
    required bool isTyping,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Fetch existing [ChatUserStatus]
      final existingStatusResponse = await supabase.from('chat_user_status').select().eq('chat_id', chatId).eq('user_id', userId).maybeSingle();

      if (existingStatusResponse != null) {
        final existingStatus = ChatUserStatus.fromMap(existingStatusResponse);

        await supabase.from('chat_user_status').upsert(
              existingStatus
                  .copyWith(
                    userId: userId,
                    chatId: chatId,
                    isTyping: isTyping,
                  )
                  .toMap(),
            );

        logger.t('ChatUserStatusTableService -> updateTypingStatus() -> success!');
        return true;
      } else {
        logger.e('ChatUserStatusTableService -> updateTypingStatus() -> existingStatusResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('ChatUserStatusTableService -> updateTypingStatus() -> $e');
      return false;
    }
  }

  /// User opens a `chat` (mark messages as read)
  Future<bool> markChatAsRead({
    required String chatId,
    required String lastMessageId,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Fetch existing [ChatUserStatus]
      final existingStatusResponse = await supabase.from('chat_user_status').select().eq('chat_id', chatId).eq('user_id', userId).maybeSingle();

      if (existingStatusResponse != null) {
        final existingStatus = ChatUserStatus.fromMap(existingStatusResponse);

        await supabase.from('chat_user_status').upsert(
              existingStatus
                  .copyWith(
                    userId: userId,
                    chatId: chatId,
                    lastReadMessageId: lastMessageId,
                    lastReadAt: DateTime.now(),
                  )
                  .toMap(),
            );

        logger.t('ChatUserStatusTableService -> markChatAsRead() -> success!');
        return true;
      } else {
        logger.e('ChatUserStatusTableService -> updateTypingStatus() -> existingStatusResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('ChatUserStatusTableService -> markChatAsRead() -> $e');
      return false;
    }
  }

  /// User mutes / unmutes a `chat`
  Future<bool> updateMuteSettings({
    required String chatId,
    required bool isMuted,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase
          .from('chat_user_status')
          .upsert({
            'is_muted': isMuted,
          })
          .eq('user_id', userId)
          .eq('chat_id', chatId);

      logger.t('ChatUserStatusTableService -> updateMuteSettings() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> updateMuteSettings() -> $e');
      return false;
    }
  }

  /// User leaves a `chat`
  Future<bool> leaveChat({required String chatId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase
          .from('chat_user_status')
          .update({
            'left_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('chat_id', chatId);

      logger.t('ChatUserStatusTableService -> leaveChat() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> leaveChat() -> $e');
      return false;
    }
  }

  /// Unread count for a specific `chat`
  Future<int?> getUnreadCount({required String chatId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final status = await supabase.from('chat_user_status').select('last_read_at').eq('user_id', userId).eq('chat_id', chatId).maybeSingle();

      if (status != null) {
        final lastReadAt = status['last_read_at'] as String?;

        final response = await supabase.from('messages').select().eq('chat_id', chatId).gt(
              'created_at',
              lastReadAt ?? DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(),
            );

        logger.t('ChatUserStatusTableService -> getUnreadCount() -> success!');
        return (response as List).length;
      } else {
        logger.e('ChatUserStatusTableService -> getUnreadCount() -> status == null');
        return null;
      }
    } catch (e) {
      logger.e('ChatUserStatusTableService -> getUnreadCount() -> $e');
      return null;
    }
  }
}
