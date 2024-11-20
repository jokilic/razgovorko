// ignore_for_file: unnecessary_lambdas

import '../models/chat.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class ChatsTableService {
  final LoggerService logger;

  ChatsTableService({
    required this.logger,
  });

  ///
  /// STREAMS
  ///

  /// Stream all `chats` for `currentUser`
  Stream<List<Chat>?> streamCurrentUserChats() {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return supabase.from('chats').stream(primaryKey: ['id']).order('created_at').map(
          (data) => data.isNotEmpty ? data.map((json) => Chat.fromMap(json)).toList() : null,
        );
  }

  /// Stream a specific `chat`
  Stream<Chat?> streamChat({required String chatId}) => supabase.from('chats').stream(primaryKey: ['id']).eq('id', chatId).map(
        (data) => data.isNotEmpty ? Chat.fromMap(data.first) : null,
      );

  ///
  /// METHODS
  ///

  /// Returns [Chat] or `null` if it doesn't exist
  Future<Chat?> getChat({
    required List<String> otherUserIds,
    required ChatType chatType,
    String? name,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      if (chatType == ChatType.group && name == null) {
        throw Exception('Group chat should have a name');
      }

      /// Create a list of `participants`
      final allParticipants = {userId, ...otherUserIds}.toList();

      var query = supabase.from('chats').select().eq('chat_type', chatType.name).contains('participants', allParticipants);

      /// Finding a group, `name` is required
      if (chatType == ChatType.group && name != null) {
        query = query.eq('name', name);
      }

      final chatResponse = await query.maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        logger.t('ChatsTableService -> getChat() -> success!');
        return chat;
      }

      logger.e('ChatsTableService -> getChat() -> chat == null');
      return null;
    } catch (e) {
      logger.e('ChatsTableService -> getChat() -> $e');
      return null;
    }
  }

  /// Creates new [Chat]
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

      /// Create a list of `participants`
      final allParticipants = {userId, ...otherUserIds}.toList();

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
    String? lastMessageId,
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
            if (lastMessageId != null) 'last_message_id': lastMessageId,
            if (name != null || description != null || avatarUrl != null) 'updated_at': DateTime.now().toIso8601String(),
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
      final chatResponse = await supabase.from('chats').select().eq('id', chatId).maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        if (chat.chatType == ChatType.individual) {
          throw Exception('Cannot add participants to individual chat');
        }

        /// Create a list of `participants`
        final allParticipants = {...chat.participants, ...newParticipantIds}.toList();

        /// Update `chat` participants
        await supabase.from('chats').update({
          'participants': allParticipants,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', chatId);

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
  Future<bool> deleteParticipants({
    required String chatId,
    required List<String> participantIds,
  }) async {
    try {
      /// Get current `chat` data
      final chatResponse = await supabase.from('chats').select().eq('id', chatId).maybeSingle();

      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        if (chat.chatType == ChatType.individual) {
          throw Exception('Cannot remove participants from individual chat');
        }

        final remainingParticipants = chat.participants.where((p) => !participantIds.contains(p)).toList();

        if (remainingParticipants.isEmpty) {
          throw Exception('Cannot remove all participants');
        }

        /// Update `chat` participants
        await supabase.from('chats').update({
          'participants': remainingParticipants,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', chatId);

        logger.t('ChatsTableService -> deleteParticipants() -> success!');
        return true;
      } else {
        logger.e('ChatsTableService -> deleteParticipants() -> chatResponse == null');
        return false;
      }
    } catch (e) {
      logger.e('ChatsTableService -> deleteParticipants() -> $e');
      return false;
    }
  }

  /// Soft delete `chat`
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
