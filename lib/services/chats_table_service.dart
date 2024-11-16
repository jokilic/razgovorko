// ignore_for_file: unnecessary_lambdas

import '../models/chat.dart';
import '../models/chat_user_status.dart';
import 'chat_user_status_table_service.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class ChatsTableService {
  final LoggerService logger;
  final ChatUserStatusTableService chatUserStatusTable;

  ChatsTableService({
    required this.logger,
    required this.chatUserStatusTable,
  });

  ///
  /// STREAMS
  ///

  /// Stream all `chats` for current user
  Stream<List<Chat>> streamChats() {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return supabase.from('chats').stream(primaryKey: ['id']).order('created_at').map((rows) => rows.map((row) => Chat.fromMap(row)).toList());
  }

  /// Stream a specific `chat`
  Stream<Chat?> streamChat({required String chatId}) =>
      supabase.from('chats').stream(primaryKey: ['id']).eq('id', chatId).map((rows) => rows.isEmpty ? null : Chat.fromMap(rows.first));

  ///
  /// METHODS
  ///

  /// Returns [Chat] between `userId` and `otherUserIds` or `null` if it doesn't exist
  Future<Chat?> fetchExistingChat({
    required List<String> otherUserIds,
    required ChatType chatType,
    String? name,
  }) async {
    try {
      if (chatType == ChatType.group && name == null) {
        throw Exception('Group chat should have a name');
      }

      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Include exact participant count to ensure correct matching
      final allParticipants = [userId, ...otherUserIds];

      var query = supabase.from('chats').select().eq('chat_type', chatType.name).contains('participants', allParticipants);

      /// Finding a group, `name` is required
      if (chatType == ChatType.group) {
        query = query.eq('name', name!);
      }

      final chatResponse = await query.maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        logger.t('ChatsTableService -> fetchExistingChat() -> success!');
        return chat;
      }

      logger.e('ChatsTableService -> fetchExistingChat() -> chat not found');
      return null;
    } catch (e) {
      logger.e('ChatsTableService -> fetchExistingChat() -> $e');
      return null;
    }
  }

  /// Creates new [Chat] for `userId` and `otherUserIds`
  Future<Chat?> createChat({
    required List<String> otherUserIds,
    required ChatType chatType,
    String? name,
    String? description,
    String? avatarUrl,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final now = DateTime.now();
      final allParticipants = [userId, ...otherUserIds];

      /// Validate `chat` creation
      if (chatType == ChatType.individual && allParticipants.length != 2) {
        throw Exception('Individual chat must have exactly 2 participants');
      }

      /// Create a new [Chat]
      final newChat = Chat(
        chatType: chatType,
        name: name ?? 'New chat',
        description: description,
        avatarUrl: avatarUrl,
        createdAt: now,
        createdBy: userId,
        participants: allParticipants,
      );

      /// Store [Chat] in [Supabase]
      final chatResponse = await supabase.from('chats').insert(newChat.toMap()).select().maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        await chatUserStatusTable.createChatUserStatus(
          participants: allParticipants,
          chatId: chat.id,
        );

        logger.t('ChatsTableService -> createChat() -> success!');
        return chat;
      } else {
        logger.e('ChatsTableService -> createChat() -> chatResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('ChatsTableService -> createChat() -> $e');
      return null;
    }
  }

  /// Update `chat` details
  Future<Chat?> updateChat({
    required String chatId,
    String? name,
    String? description,
    String? avatarUrl,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final chatResponse = await supabase
          .from('chats')
          .update({
            if (name != null) 'name': name,
            if (description != null) 'description': description,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', chatId)
          .select()
          .maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        logger.t('ChatsTableService -> updateChat() -> success!');
        return chat;
      } else {
        logger.e('ChatsTableService -> updateChat() -> chatResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('ChatsTableService -> updateChat() -> $e');
      return null;
    }
  }

  /// Add `participants` to a group `chat`
  Future<bool> addParticipants({
    required String chatId,
    required List<String> newParticipantIds,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Get current `chat` data
      final chatResponse = await supabase.from('chats').select('participants, chat_type').eq('id', chatId).maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        if (chat.chatType == ChatType.individual) {
          throw Exception('Cannot add participants to individual chat');
        }

        final now = DateTime.now();
        final allParticipants = {...chat.participants, ...newParticipantIds}.toList();

        /// Update `chat` participants
        await supabase.from('chats').update({
          'participants': allParticipants,
          'updated_at': now.toIso8601String(),
        }).eq('id', chatId);

        /// Create [ChatUserStatus] for new `participants`
        await Future.wait(
          newParticipantIds.map(
            (participantId) => supabase.from('chat_user_status').insert(
                  ChatUserStatus(
                    userId: participantId,
                    chatId: chatId,
                    isMuted: false,
                    isTyping: false,
                    role: ChatRole.member,
                    joinedAt: now,
                  ).toMap(),
                ),
          ),
        );

        logger.t('ChatsTableService -> addParticipants() -> success!');
        return true;
      } else {
        logger.e('ChatsTableService -> addParticipants() -> chatResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('ChatsTableService -> addParticipants() -> $e');
      return false;
    }
  }

  /// Remove `participants` from a group `chat`
  Future<bool> removeParticipants({
    required String chatId,
    required List<String> participantIds,
  }) async {
    try {
      /// Get current `chat` data
      final chatResponse = await supabase.from('chats').select('participants, chat_type').eq('id', chatId).maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        if (chat.chatType == ChatType.individual) {
          throw Exception('Cannot remove participants from individual chat');
        }

        final now = DateTime.now();
        final remainingParticipants = chat.participants.where((p) => !participantIds.contains(p)).toList();

        if (remainingParticipants.isEmpty) {
          throw Exception('Cannot remove all participants');
        }

        /// Update `chat` participants
        await supabase.from('chats').update({
          'participants': remainingParticipants,
          'updated_at': now.toIso8601String(),
        }).eq('id', chatId);

        /// Update [ChatUserStatus] for removed `participants`
        await supabase
            .from('chat_user_status')
            .update({
              'left_at': DateTime.now().toIso8601String(),
            })
            .eq('chat_id', chatId)
            .inFilter('user_id', participantIds);

        logger.t('ChatsTableService -> removeParticipants() -> success!');
        return true;
      } else {
        logger.e('ChatsTableService -> removeParticipants() -> chatResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('ChatsTableService -> removeParticipants() -> $e');
      return false;
    }
  }

  /// Delete a `chat` (soft delete)
  Future<bool> deleteChat({required String chatId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase.from('chats').update({
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('id', chatId);

      logger.t('ChatsTableService -> deleteChat() -> success!');
      return true;
    } catch (e) {
      logger.e('ChatsTableService -> deleteChat() -> $e');
      return false;
    }
  }
}
