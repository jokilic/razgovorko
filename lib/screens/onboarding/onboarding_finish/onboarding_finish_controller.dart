import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/parsed_number.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/users_table_service.dart';

class OnboardingFinishController {
  final LoggerService logger;
  final AuthService auth;
  final UsersTableService usersTable;

  OnboardingFinishController({
    required this.logger,
    required this.auth,
    required this.usersTable,
  });

  ///
  /// METHODS
  ///

  /// Signs `user` in [Supabase]
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
  //       logger.t('OnboardingFinishController -> signIn() -> success!');
  //       return supabaseUser;
  //     } else {
  //       logger.e('OnboardingFinishController -> signIn() -> supabaseUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingFinishController -> signIn() -> $e');
  //     return null;
  //   }
  // }

  Future<bool> registerUser({
    required ParsedNumber parsedNumber,
    required String password,
    required String displayName,
    required String? avatarUrl,
    required String? aboutMe,
    required String? status,
    required String? location,
    required DateTime? dateOfBirth,
  }) async {
    final number = parsedNumber.international.replaceAll(' ', '');

    final supabaseUser = await signUpWithEmail(
      email: '$number@razgovorko.com',
      password: password,
    );

    if (supabaseUser != null) {
      logger.t('OnboardingFinishController -> registerUser() -> supabaseUser -> success!');

      final razgovorkoUser = await createUser(
        supabaseUser: supabaseUser,
        parsedNumber: parsedNumber,
        displayName: displayName,
        avatarUrl: avatarUrl,
        aboutMe: aboutMe,
        status: status,
        location: location,
        dateOfBirth: dateOfBirth,
      );

      if (razgovorkoUser != null) {
        logger.t('OnboardingFinishController -> registerUser() -> razgovorkoUser -> success!');
        return true;
      } else {
        logger.e('OnboardingFinishController -> registerUser() -> razgovorkoUser == null');
      }
    } else {
      logger.e('OnboardingFinishController -> registerUser() -> supabaseUser == null');
    }

    return false;
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
        logger.t('OnboardingFinishController -> signUpWithEmail() -> success!');
        return supabaseUser;
      } else {
        logger.e('OnboardingFinishController -> signUpWithEmail() -> supabaseUser == null');
        return null;
      }
    } catch (e) {
      logger.e('OnboardingFinishController -> signUpWithEmail() -> $e');
      return null;
    }
  }

  /// Creates `user` in `users` table
  Future<RazgovorkoUser?> createUser({
    required User supabaseUser,
    required ParsedNumber parsedNumber,
    required String displayName,
    required String? avatarUrl,
    required String? aboutMe,
    required String? status,
    required String? location,
    required DateTime? dateOfBirth,
  }) async {
    try {
      final razgovorkoUser = await usersTable.createUserProfile(
        supabaseUser: supabaseUser,
        internationalPhoneNumber: parsedNumber.international.replaceAll(' ', ''),
        nationalPhoneNumber: parsedNumber.national.replaceAll(' ', ''),
        displayName: displayName,
        avatarUrl: avatarUrl,
        aboutMe: aboutMe,
        status: status,
        location: location,
        dateOfBirth: dateOfBirth,
      );

      if (razgovorkoUser != null) {
        logger.t('OnboardingFinishController -> createUser() -> success!');
        return razgovorkoUser;
      } else {
        logger.e('OnboardingFinishController -> createUser() -> razgovorkoUser == null');
        return null;
      }
    } catch (e) {
      logger.e('OnboardingFinishController -> createUser() -> $e');
      return null;
    }
  }
}
