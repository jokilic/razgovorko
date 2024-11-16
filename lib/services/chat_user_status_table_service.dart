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

  /// Stream typing users
  Stream<List<String>> streamTypingUsers({required String chatId}) {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return supabase
        .from('chat_user_status')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .map((rows) => rows.where((row) => row['user_id'] != supabase.auth.currentUser!.id && row['is_typing'] == true).map((row) => row['user_id'] as String).toList());
  }

  /// Stream unread counts for all chats
  Stream<Map<String, int>> streamUnreadCounts({required List<String> chatIds}) {
    if (chatIds.isEmpty) {
      return Stream.value({});
    }

    return supabase.from('messages').stream(primaryKey: ['id']).map((_) async {
      final counts = <String, int>{};
      for (final chatId in chatIds) {
        counts[chatId] = await getUnreadCount(
              chatId: chatId,
            ) ??
            0;
      }
      return counts;
    }).asyncMap((future) => future);
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
          (participantId) => supabase.from('chat_user_status').upsert(
                ChatUserStatus(
                  userId: participantId,
                  chatId: chatId,
                  isMuted: false,
                  isTyping: false,
                  role: participantId == userId ? ChatRole.owner : ChatRole.member,
                  joinedAt: DateTime.now(),
                ).toMap(),
              ),
        ),
      );

      logger.t('ChatUserStatusTableService -> createChatUserStatus() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> createChatUserStatus() -> $e');
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

      await supabase.from('chat_user_status').upsert({
        'user_id': userId,
        'chat_id': chatId,
        'last_read_message_id': lastMessageId,
        'last_read_at': DateTime.now().toIso8601String(),
      });

      logger.t('ChatUserStatusTableService -> markChatAsRead() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> markChatAsRead() -> $e');
      return false;
    }
  }

  /// When user types
  Future<bool> updateTypingStatus({
    required String chatId,
    required bool isTyping,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      // Only update if status actually changed
      // if (_isCurrentlyTyping == isTyping) return;

      // _isCurrentlyTyping = isTyping;

      await supabase.from('chat_user_status').upsert({
        'user_id': userId,
        'chat_id': chatId,
        'is_typing': isTyping,
        if (isTyping) 'last_typed_at': DateTime.now().toIso8601String(),
      });

      // If starting to type, set timer to automatically stop
      // if (isTyping) {
      //   _typingTimer?.cancel();
      //   _typingTimer = Timer(const Duration(seconds: 5), () {
      //     updateTypingStatus(chatId, isTyping: false);
      //   });
      // }

      logger.t('ChatUserStatusTableService -> updateTypingStatus() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatUserStatusTableService -> updateTypingStatus() -> $e');
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

      await supabase.from('chat_user_status').upsert({
        'user_id': userId,
        'chat_id': chatId,
        'is_muted': isMuted,
      });

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

      // _isCurrentlyTyping = false;
      // _typingTimer?.cancel();

      await supabase
          .from('chat_user_status')
          .update({
            'left_at': DateTime.now().toIso8601String(),
            'is_typing': false,
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

      final status = await supabase.from('chat_user_status').select('last_read_at').eq('user_id', supabase.auth.currentUser!.id).eq('chat_id', chatId).maybeSingle();

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
