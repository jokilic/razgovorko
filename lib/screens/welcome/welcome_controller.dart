import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../../services/users_table_service.dart';

class WelcomeController implements Disposable {
  final LoggerService logger;
  final AuthService auth;
  final UsersTableService usersTable;

  WelcomeController({
    required this.logger,
    required this.auth,
    required this.usersTable,
  });

  ///
  /// VARIABLES
  ///

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameController.dispose();
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
        logger.t('WelcomeController -> signIn() -> success!');
        return supabaseUser;
      } else {
        logger.e('WelcomeController -> signIn() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('WelcomeController -> signIn() -> $e');
      return null;
    }
  }

  /// Registers `user` with `email` in [Supabase]
  Future<User?> signUpWithEmail({
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
        logger.t('WelcomeController -> signUpWithEmail() -> success!');
        return supabaseUser;
      } else {
        logger.e('WelcomeController -> signUpWithEmail() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('WelcomeController -> signUpWithEmail() -> $e');
      return null;
    }
  }

  /// Creates `user` in `users` table
  Future<RazgovorkoUser?> createUser({
    required User supabaseUser,
    required String internationalPhoneNumber,
    required String nationalPhoneNumber,
  }) async {
    try {
      final razgovorkoUser = await usersTable.createUserProfile(
        supabaseUser: supabaseUser,
        internationalPhoneNumber: internationalPhoneNumber,
        nationalPhoneNumber: nationalPhoneNumber,
      );

      if (razgovorkoUser != null) {
        logger.t('WelcomeController -> createUser() -> success!');
        return razgovorkoUser;
      } else {
        logger.e('WelcomeController -> createUser() -> razgovorkoUser == null');
        return null;
      }
    } catch (e) {
      logger.e('WelcomeController -> createUser() -> $e');
      return null;
    }
  }
}
