import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/logger_service.dart';

class OnboardingNameController implements Disposable {
  final LoggerService logger;

  OnboardingNameController({
    required this.logger,
  });

  ///
  /// VARIABLES
  ///

  final nameController = TextEditingController();

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameController.dispose();
  }

  ///
  /// METHODS
  ///

  // /// Signs `user` in [Supabase]
  // Future<User?> signIn({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final authResponse = await auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     final supabaseUser = authResponse?.user;

  //     if (supabaseUser != null) {
  //       logger.t('OnboardingNameController -> signIn() -> success!');
  //       return supabaseUser;
  //     } else {
  //       logger.e('OnboardingNameController -> signIn() -> supabaseUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingNameController -> signIn() -> $e');
  //     return null;
  //   }
  // }

  // /// Registers `user` with `email` in [Supabase]
  // Future<User?> signUpWithEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final authResponse = await auth.signUpWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     final supabaseUser = authResponse?.user;

  //     if (supabaseUser != null) {
  //       logger.t('OnboardingNameController -> signUpWithEmail() -> success!');
  //       return supabaseUser;
  //     } else {
  //       logger.e('OnboardingNameController -> signUpWithEmail() -> supabaseUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingNameController -> signUpWithEmail() -> $e');
  //     return null;
  //   }
  // }

  // /// Creates `user` in `users` table
  // Future<RazgovorkoUser?> createUser({
  //   required User supabaseUser,
  //   required String internationalPhoneNumber,
  //   required String nationalPhoneNumber,
  // }) async {
  //   try {
  //     final razgovorkoUser = await usersTable.createUserProfile(
  //       supabaseUser: supabaseUser,
  //       internationalPhoneNumber: internationalPhoneNumber,
  //       nationalPhoneNumber: nationalPhoneNumber,
  //     );

  //     if (razgovorkoUser != null) {
  //       logger.t('OnboardingNameController -> createUser() -> success!');
  //       return razgovorkoUser;
  //     } else {
  //       logger.e('OnboardingNameController -> createUser() -> razgovorkoUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingNameController -> createUser() -> $e');
  //     return null;
  //   }
  // }
}
