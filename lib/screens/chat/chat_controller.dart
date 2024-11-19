import '../../models/chat.dart';
import '../../services/auth_service.dart';
import '../../services/chat_user_status_table_service.dart';
import '../../services/chats_table_service.dart';
import '../../services/logger_service.dart';
import '../../services/messages_table_service.dart';
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
  /// STREAMS
  ///

  /// Stream current users `chats`
  Stream<List<({Chat chat, int? unreadCount})>?> streamChatsWithUnreadCounts() => chatsTable.streamCurrentUserChats().asyncMap(
        (chats) async {
          if (chats != null) {
            final counts = await Future.wait(
              chats.map(
                (chat) async {
                  final count = await chatUserStatusTable.getUnreadCount(
                    chatId: chat.id,
                  );

                  return (
                    chat: chat,
                    unreadCount: count,
                  );
                },
              ),
            );

            return counts;
          }

          return null;
        },
      );
}
