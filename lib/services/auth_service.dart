import 'package:supabase_flutter/supabase_flutter.dart';

import 'logger_service.dart';
import 'supabase_service.dart';

class AuthService {
  final LoggerService logger;

  AuthService({
    required this.logger,
  });

  ///
  /// STREAMS
  ///

  Stream<AuthState> onAuthStateChange() => supabase.auth.onAuthStateChange;

  ///
  /// METHODS
  ///

  /// Signs user in [Supabase] using `email` & `password`
  Future<AuthResponse?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      logger.t('AuthService -> signInWithEmailAndPassword() -> success!');
      return authResponse;
    } catch (e) {
      logger.e('AuthService -> signInWithEmailAndPassword() -> $e');
      return null;
    }
  }

  /// Registers user in [Supabase] using `email` & `password`
  /// Uses phone number instead of a proper `email`
  Future<AuthResponse?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      logger.t('AuthService -> signUpWithEmailAndPassword() -> success!');
      return authResponse;
    } catch (e) {
      logger.e('AuthService -> signUpWithEmailAndPassword() -> $e');
      return null;
    }
  }

  /// Registers user in [Supabase] using `phone number` & `password`
  Future<AuthResponse?> signUpWithPhoneNumberAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final authResponse = await supabase.auth.signUp(
        phone: phoneNumber,
        password: password,
      );

      logger.t('AuthService -> signUpWithPhoneNumberAndPassword() -> success!');
      return authResponse;
    } catch (e) {
      logger.e('AuthService -> signUpWithPhoneNumberAndPassword() -> $e');
      return null;
    }
  }

  /// Logs out user
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      logger.t('AuthService -> signOut() -> success!');
    } catch (e) {
      logger.e('AuthService -> signOut() -> $e');
    }
  }
}
