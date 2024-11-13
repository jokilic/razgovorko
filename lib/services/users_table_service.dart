// ignore_for_file: unnecessary_lambdas

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

class UsersTableService {
  final LoggerService logger;

  UsersTableService({
    required this.logger,
  });

  ///
  /// METHODS
  ///

  /// Stores user data in `users` table
  Future<RazgovorkoUser?> storeUserDataInDatabase({required User supabaseUser}) async {
    if (supabaseUser.email == null) {
      logger.e('UsersTableService -> storeUserDataInDatabase() -> supabaseUser.email == null');
      return null;
    }

    try {
      final now = DateTime.now();

      /// Create new [RazgovorkoUser]
      final user = RazgovorkoUser(
        id: supabaseUser.id,
        email: supabaseUser.email!,
        phoneNumber: supabaseUser.phone,
        displayName: 'My name new',
        status: 'Hello there',
        createdAt: now,
        updatedAt: now,
        lastSeen: now,
        avatarUrl: 'https://faroutmagazine.co.uk/static/uploads/1/2022/12/How-Danny-DeVito-joined-Its-Always-Sunny-in-Philadelphia-1140x855.jpeg',
      );

      /// Insert into `users` table
      await supabase.from('users').upsert(user).select().single();

      logger.t('UsersTableService -> storeUserDataInDatabase() -> success!');
      return user;
    } catch (e) {
      logger.e('UsersTableService -> storeUserDataInDatabase() -> $e');
      return null;
    }
  }

  /// Updates user data in `users` table
  Future<bool> updateUserDataInDatabase({
    String? email,
    String? phoneNumber,
    String? displayName,
    String? status,
    String? lastSeen,
    String? avatarUrl,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      /// Update relevent user from `users` table
      await supabase.from('users').update({
        if (email != null) 'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (displayName != null) 'display_name': displayName,
        if (status != null) 'status': status,
        if (lastSeen != null) 'last_seen': lastSeen,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      logger.t('UsersTableService -> updateUserDataInDatabase() -> success!');
      return true;
    } catch (e) {
      logger.e('UsersTableService -> updateUserDataInDatabase() -> $e');
      return false;
    }
  }

  /// [Stream] which listens to `currentUser` data
  Stream<RazgovorkoUser?> streamCurrentUser() {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return Stream.value(null);
    }

    return supabase
        .from('users')
        .stream(
          primaryKey: ['id'],
        )
        .eq('id', userId)
        .map((data) => data.isNotEmpty ? RazgovorkoUser.fromMap(data.first) : null);
  }

  /// Stream all users except the current user
  Stream<List<RazgovorkoUser>?> streamAllUsers() {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return Stream.value(null);
    }

    return supabase
        .from('users')
        .stream(primaryKey: ['id'])
        .neq('id', userId) // Exclude current user
        .order('display_name') // Order by name
        .map((data) => data.isNotEmpty ? data.map((json) => RazgovorkoUser.fromMap(json)).toList() : null);
  }
}
