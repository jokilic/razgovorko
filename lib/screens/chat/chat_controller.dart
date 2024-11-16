import '../../models/chat.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
import '../../services/supabase_service.dart';
import '../../services/users_table_service.dart';

class ChatController {
  final LoggerService logger;
  final AuthService auth;
  final UsersTableService usersTable;
  final ChatsTableService chatsTable;
  final ChatUserStatusTableService chatUserStatusTable;
  final MessagesTableService messagesTable;

  ChatController({
    required this.logger,
    required this.auth,
    required this.usersTable,
    required this.chatsTable,
    required this.chatUserStatusTable,
    required this.messagesTable,
  });

  ///
  /// USER MANAGEMENT
  ///

  /// Returns a [Stream] which listens to the `currentUser` within the `users` table
  Stream<RazgovorkoUser?> streamCurrentUser() => usersTable.streamCurrentUser();

  /// Returns a [Stream] which listens to all users within the `users` table, except for the `currentUser`
  Stream<List<RazgovorkoUser>?> streamAllUsers() => usersTable.streamAllUsers();

  /// Update user profile
  Future<RazgovorkoUser?> updateProfile({
    String? email,
    String? phoneNumber,
    String? displayName,
    String? status,
    String? aboutMe,
    String? location,
    DateTime? dateOfBirth,
    String? avatarUrl,
  }) =>
      usersTable.updateUserProfile(
        email: email,
        phoneNumber: phoneNumber,
        displayName: displayName,
        status: status,
        aboutMe: aboutMe,
        location: location,
        dateOfBirth: dateOfBirth,
        avatarUrl: avatarUrl,
      );

  /// Sign user out
  Future<void> signOut() async {
    try {
      /// Update online status before signing out
      await usersTable.updateOnlineStatus(isOnline: false);
      await auth.signOut();
      logger.t('ChatController -> signOut() -> success!');
    } catch (e) {
      logger.e('ChatController -> signOut() -> $e');
    }
  }

  ///
  /// CHAT MANAGEMENT
  ///

  /// Start or get existing `chat` with users
  Future<Chat?> startChat({
    required List<String> otherUserIds,
    required ChatType chatType,
    String? name,
    String? description,
  }) async {
    try {
      if (chatType == ChatType.individual) {
        /// For individual `chats`, ensure exactly 2 participants
        if (otherUserIds.length != 1) {
          throw Exception('Individual chat must have exactly one other participant');
        }

        /// Check for existing `chat`
        final existingChat = await chatsTable.getChat(
          otherUserIds: otherUserIds,
          chatType: chatType,
          name: name,
        );

        if (existingChat != null) {
          return existingChat;
        }
      }

      /// Create new `chat`
      final chat = await chatsTable.createChat(
        otherUserIds: otherUserIds,
        chatType: chatType,
        name: name,
        description: description,
      );

      /// Create [ChatUserStatus] for each `participant`
      await chatUserStatusTable.createChatUserStatus(
        participants: [supabase.auth.currentUser!.id, ...otherUserIds],
        chatId: chat!.id,
      );

      logger.t('ChatController -> startChat() -> success!');
      return chat;
    } catch (e) {
      logger.e('ChatController -> startChat() -> $e');
      return null;
    }
  }

  /// Stream current users `chats`
  Stream<List<({Chat chat, int? unreadCount})>> streamChatsWithUnreadCounts() => chatsTable.streamCurrentUserChats().asyncMap((chats) async {
        final counts = await Future.wait(
          chats.map((chat) async {
            final count = await chatUserStatusTable.getUnreadCount(
              chatId: chat.id,
            );

            return (
              chat: chat,
              unreadCount: count,
            );
          }),
        );
        return counts;
      });

  ///
  /// MESSAGE MANAGEMENT
  ///

  /// Stream `messages` for a `chat`
  Stream<List<Message>?> streamMessages({
    required String chatId,
  }) =>
      messagesTable.streamMessages(
        chatId: chatId,
      );

  /// Send `message`
  Future<Message?> sendMessage({
    required String chatId,
    required String content,
    required MessageType messageType,
    required bool isViewOnce,
    String? replyToMessageId,
  }) async {
    try {
      Message? message;

      switch (messageType) {
        case MessageType.text:
          message = await messagesTable.sendMessage(
            chatId: chatId,
            content: content,
            messageType: messageType,
            isViewOnce: isViewOnce,
            replyToMessageId: replyToMessageId,
          );
          break;

        default:
          logger.e('ChatController -> sendMessage() -> messageType != MessageType.text');
      }

      /// Message is created
      if (message != null) {
        /// Update typing status and last read
        await Future.wait([
          chatUserStatusTable.updateTypingStatus(
            chatId: chatId,
            isTyping: false,
          ),
          chatUserStatusTable.markChatAsRead(
            chatId: chatId,
            lastMessageId: message.id,
          ),
        ]);
      }

      logger.t('ChatController -> sendMessage() -> success!');
      return message;
    } catch (e) {
      logger.e('ChatController -> sendMessage() -> $e');
      return null;
    }
  }

  ///
  /// TYPING INDICATORS
  ///

  /// Handle typing status
  Future<void> updateTypingStatus({
    required String chatId,
    required bool isTyping,
  }) =>
      chatUserStatusTable.updateTypingStatus(
        chatId: chatId,
        isTyping: isTyping,
      );

  /// Stream typing users
  Stream<List<String>> streamTypingUsers({
    required String chatId,
  }) =>
      chatUserStatusTable.streamTypingUsers(
        chatId: chatId,
      );

  ///
  /// CHAT ACTIONS
  ///

  /// Mark `chat` as read
  Future<void> markChatAsRead({
    required String chatId,
    required String lastMessageId,
  }) =>
      chatUserStatusTable.markChatAsRead(
        chatId: chatId,
        lastMessageId: lastMessageId,
      );

  /// Mute `chat`
  Future<void> muteChat({
    required String chatId,
    required bool isMuted,
  }) =>
      chatUserStatusTable.updateMuteSettings(
        chatId: chatId,
        isMuted: isMuted,
      );

  /// Leave `chat`
  Future<void> leaveChat({required String chatId}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await Future.wait([
        chatUserStatusTable.leaveChat(chatId: chatId),
        chatsTable.deleteParticipants(
          chatId: chatId,
          participantIds: [userId],
        ),
      ]);
      logger.t('ChatController -> leaveChat() -> success!');
    } catch (e) {
      logger.e('ChatController -> leaveChat() -> $e');
    }
  }

  /// Add `participants` to `chat`
  Future<bool> addParticipants({
    required String chatId,
    required List<String> userIds,
  }) =>
      chatsTable.addParticipants(
        chatId: chatId,
        newParticipantIds: userIds,
      );

  ///
  /// REACTIONS
  ///

  /// Add `reaction` to `message`
  Future<bool> addReaction({
    required String messageId,
    required String reaction,
  }) =>
      messagesTable.addReaction(
        messageId: messageId,
        reaction: reaction,
      );

  /// Remove `reaction` from `message`
  Future<bool> removeReaction({
    required String messageId,
    required String reaction,
  }) =>
      messagesTable.removeReaction(
        messageId: messageId,
        reaction: reaction,
      );
}
