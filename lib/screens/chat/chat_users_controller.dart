import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/users_table_service.dart';

class ChatUsersController {
  final LoggerService logger;
  final AuthService auth;
  final UsersTableService usersTable;

  ChatUsersController({
    required this.logger,
    required this.auth,
    required this.usersTable,
  });

  ///
  /// STREAMS
  ///

  /// Returns a [Stream] which listens to the `currentUser` within the `users` table
  Stream<RazgovorkoUser?> streamCurrentUser() => usersTable.streamCurrentUser();

  /// Returns a [Stream] which listens to all users within the `users` table, except for the `currentUser`
  Stream<List<RazgovorkoUser>?> streamAllUsers() => usersTable.streamAllUsers();

  ///
  /// METHODS
  ///

  /// Update `user` profile
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

  /// Sign `user` out
  Future<void> signOut() async {
    /// Update online status before signing out
    await usersTable.updateOnlineStatus(isOnline: false);

    /// Sign out
    await auth.signOut();
  }
}
