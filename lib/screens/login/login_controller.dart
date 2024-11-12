import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/user_service.dart';

class LoginController implements Disposable {
  final LoggerService logger;
  final AuthService auth;
  final UserService user;

  LoginController({
    required this.logger,
    required this.auth,
    required this.user,
  });

  ///
  /// VARIABLES
  ///

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when pressing `Login` button
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
        logger.t('LoginController -> signIn() -> success!');
        return supabaseUser;
      } else {
        logger.e('LoginController -> signIn() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('LoginController -> signIn() -> $e');
      return null;
    }
  }

  /// Triggered when pressing `Register` button
  Future<RazgovorkoUser?> signUpAndStoreUserInDatabase({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await auth.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      final supabaseUser = authResponse?.user;

      if (supabaseUser != null) {
        final razgovorkoUser = await user.storeUserDataInDatabase(
          supabaseUser: supabaseUser,
        );

        logger.t('LoginController -> signUpAndStoreUserInDatabase() -> success!');
        return razgovorkoUser;
      } else {
        logger.e('LoginController -> signUpAndStoreUserInDatabase() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('LoginController -> signUpAndStoreUserInDatabase() -> $e');
      return null;
    }
  }
}
