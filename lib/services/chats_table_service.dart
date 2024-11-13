import '../models/chat.dart';
import '../models/chat_participant.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class ChatsTableService {
  final LoggerService logger;

  ChatsTableService({
    required this.logger,
  });

  ///
  /// METHODS
  ///

  /// Creates new [Chat] & [ChatParticipant] for `userId` and `otherUserId`
  Future<Chat?> createChatAndParticipants({required String otherUserId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final now = DateTime.now();

      /// Create a new [Chat]
      final newChat = Chat(
        chatType: 'individual',
        name: 'Chat name',
        description: 'Some desc',
        avatarUrl: '',
        createdAt: now,
        createdBy: userId,
      );

      /// Store [Chat] in [Supabase]
      final chatResponse = await supabase.from('chats').insert(newChat.toMap()).select().single();
      final chat = Chat.fromMap(chatResponse);

      /// Create [ChatParticipant] for both users
      final firstParticipant = ChatParticipant(
        chatId: chat.id,
        userId: userId,
        role: 'member',
        isMuted: false,
        joinedAt: now,
      );

      final secondParticipant = ChatParticipant(
        chatId: chat.id,
        userId: otherUserId,
        role: 'member',
        isMuted: false,
        joinedAt: now,
      );

      /// Store [ChatParticipants] in [Supabase]
      await supabase.from('chat_participants').insert(
        [firstParticipant.toMap(), secondParticipant.toMap()],
      );

      logger.t('ChatsTableService -> createChatAndParticipants() -> success!');
      return chat;
    } catch (e) {
      logger.e('ChatsTableService -> createChatAndParticipants() -> $e');
      return null;
    }
  }

  /// Returns [Chat] between `userId` and `otherUserId` or `null` if it doesn't exist
  Future<Chat?> fetchExistingChat({required String otherUserId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Find chat where both users are participants in a single query
      final chatResponse = await supabase
          .from('chats')
          .select('''
          *,
            chat_participants!inner(*)
          ''')
          .eq('chat_type', 'individual')
          .filter(
            'chat_participants.user_id',
            'in',
            '($userId,$otherUserId)',
          )
          .maybeSingle();

      logger.f('Chat response : $chatResponse');

      /// Parse fetched chat to proper model
      if (chatResponse != null) {
        final chat = Chat.fromMap(chatResponse);

        logger.t('ChatsTableService -> fetchExistingChat() -> success!');
        return chat;
      }

      logger.e('ChatsTableService -> fetchExistingChat() -> chatParticipant == null');
      return null;
    } catch (e) {
      logger.e('ChatsTableService -> fetchExistingChat() -> $e');
      return null;
    }
  }
}
