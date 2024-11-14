import '../models/chat.dart';
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

  /// Returns [Chat] between `userId` and `otherUserIds` or `null` if it doesn't exist
  Future<Chat?> fetchExistingChat({required List<String> otherUserIds}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Find `chat` which has relevant `participants`
      final chatResponse = await supabase.from('chats').select().contains(
        'participants',
        [userId, ...otherUserIds],
      ).maybeSingle();

      /// Parse fetched `chat` to proper model
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

  /// Creates new [Chat] for `userId` and `otherUserIds`
  Future<Chat?> createChat({required List<String> otherUserIds}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final now = DateTime.now();

      /// Create a new [Chat]
      final newChat = Chat(
        chatType: ChatType.individual,
        name: 'My chat!',
        createdAt: now,
        createdBy: userId,
        participants: [userId, ...otherUserIds],
      );

      /// Store [Chat] in [Supabase]
      final chatResponse = await supabase.from('chats').insert(newChat.toMap()).select().single();
      final chat = Chat.fromMap(chatResponse);

      logger.t('ChatsTableService -> createChat() -> success!');
      return chat;
    } catch (e) {
      logger.e('ChatsTableService -> createChat() -> $e');
      return null;
    }
  }
}
