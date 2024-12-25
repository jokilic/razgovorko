import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../services/logger_service.dart';

class OnboardingAdditionalController extends ValueNotifier<
    ({
      String? avatarUrl,
      String? aboutMe,
      String? status,
      String? location,
      DateTime? dateOfBirth,
    })> implements Disposable {
  final LoggerService logger;

  OnboardingAdditionalController({
    required this.logger,
  }) : super(
          (
            avatarUrl: null,
            aboutMe: null,
            status: null,
            location: null,
            dateOfBirth: null,
          ),
        );

  ///
  /// VARIABLES
  ///

  final dateController = TextEditingController();

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    dateController.dispose();
  }

  ///
  /// METHODS
  ///

  void updateState({
    String? avatarUrl,
    String? aboutMe,
    String? status,
    String? location,
    DateTime? dateOfBirth,
  }) {
    if (avatarUrl != null) {
      final oldValue = value;

      value = (
        avatarUrl: avatarUrl.trim(),
        aboutMe: oldValue.aboutMe,
        status: oldValue.status,
        location: oldValue.location,
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (aboutMe != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: aboutMe.trim(),
        status: oldValue.status,
        location: oldValue.location,
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (status != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: oldValue.aboutMe,
        status: status.trim(),
        location: oldValue.location,
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (location != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: oldValue.aboutMe,
        status: oldValue.status,
        location: location.trim(),
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (dateOfBirth != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: oldValue.aboutMe,
        status: oldValue.status,
        location: oldValue.location,
        dateOfBirth: dateOfBirth,
      );
    }
  }

  void updateDateOfBirth({required DateTime newDate}) {
    final formattedDate = DateFormat(
      'd. MMMM yyyy.',
      'hr',
    ).format(newDate);

    dateController.text = formattedDate;

    updateState(dateOfBirth: newDate);
  }

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
  //       logger.t('OnboardingAdditionalController -> signIn() -> success!');
  //       return supabaseUser;
  //     } else {
  //       logger.e('OnboardingAdditionalController -> signIn() -> supabaseUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingAdditionalController -> signIn() -> $e');
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
  //       logger.t('OnboardingAdditionalController -> signUpWithEmail() -> success!');
  //       return supabaseUser;
  //     } else {
  //       logger.e('OnboardingAdditionalController -> signUpWithEmail() -> supabaseUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingAdditionalController -> signUpWithEmail() -> $e');
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
  //       logger.t('OnboardingAdditionalController -> createUser() -> success!');
  //       return razgovorkoUser;
  //     } else {
  //       logger.e('OnboardingAdditionalController -> createUser() -> razgovorkoUser == null');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('OnboardingAdditionalController -> createUser() -> $e');
  //     return null;
  //   }
  // }
}
