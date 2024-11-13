import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/users_table_service.dart';

class ChatController {
  final LoggerService logger;
  final AuthService auth;
  final UsersTableService usersTable;

  ChatController({
    required this.logger,
    required this.auth,
    required this.usersTable,
  });

  ///
  /// METHODS
  ///

  /// Returns a [Stream] which listens to the `currentUser` within the `users` table
  Stream<RazgovorkoUser?> streamCurrentUser() => usersTable.streamCurrentUser();

  /// Returns a [Stream] which listens to all users within the `users` table, except for the `currentUser`
  Stream<List<RazgovorkoUser>?> streamAllUsers() => usersTable.streamAllUsers();

  /// Logs out user
  Future<void> signOut() async => auth.signOut();
}
