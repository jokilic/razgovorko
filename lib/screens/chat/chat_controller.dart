import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/user_service.dart';

class ChatController {
  final LoggerService logger;
  final AuthService auth;
  final UserService user;

  ChatController({
    required this.logger,
    required this.auth,
    required this.user,
  });

  ///
  /// METHODS
  ///

  /// Returns a [Stream] which listens to the `currentUser` within the `users` table
  Stream<RazgovorkoUser?> streamCurrentUser() => user.streamCurrentUser();

  /// Logs out user
  Future<void> signOut() async => auth.signOut();
}
