import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/auth_service.dart';
import '../../../services/logger_service.dart';

class LoginPasswordController extends ValueNotifier<String?> {
  final LoggerService logger;
  final AuthService auth;

  LoginPasswordController({
    required this.logger,
    required this.auth,
  }) : super(null);

  ///
  /// METHODS
  ///

  /// Check if `password` is proper
  bool isStateProper(String? passedPassword) => (passedPassword?.trim().length ?? 0) >= 8;

  /// Signs `user` in [Supabase]
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final supabaseUser = authResponse?.user;

      if (supabaseUser != null) {
        logger.t('LoginPasswordController -> signIn() -> success!');
        return supabaseUser;
      } else {
        logger.e('LoginPasswordController -> signIn() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('LoginPasswordController -> signIn() -> $e');
      return null;
    }
  }
}
