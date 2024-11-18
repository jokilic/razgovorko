import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/users_table_service.dart';

class LoginController implements Disposable {
  final LoggerService logger;
  final AuthService auth;
  final UsersTableService usersTable;

  LoginController({
    required this.logger,
    required this.auth,
    required this.usersTable,
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

  /// Registers `user` in [Supabase]
  Future<User?> signUp({
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
        logger.t('LoginController -> signUp() -> success!');
        return supabaseUser;
      } else {
        logger.e('LoginController -> signUp() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('LoginController -> signUp() -> $e');
      return null;
    }
  }

  /// Creates `user` in `users` table
  Future<RazgovorkoUser?> createUser({required User supabaseUser}) async {
    try {
      final razgovorkoUser = await usersTable.createUserProfile(
        supabaseUser: supabaseUser,
      );

      if (razgovorkoUser != null) {
        logger.t('LoginController -> createUser() -> success!');
        return razgovorkoUser;
      } else {
        logger.e('LoginController -> createUser() -> razgovorkoUser == null');
        return null;
      }
    } catch (e) {
      logger.e('LoginController -> createUser() -> $e');
      return null;
    }
  }
}
