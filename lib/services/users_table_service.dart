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
  /// STREAMS
  ///

  /// Stream `currentUser` data
  Stream<RazgovorkoUser?> streamCurrentUser() {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return Stream.value(null);
    }

    return supabase.from('users').stream(primaryKey: ['id']).eq('id', userId).map(
          (data) => data.isNotEmpty ? RazgovorkoUser.fromMap(data.first) : null,
        );
  }

  /// Stream all `users` except `currentUser`
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
        .map(
          (data) => data.isNotEmpty ? data.map((json) => RazgovorkoUser.fromMap(json)).toList() : null,
        );
  }

  ///
  /// METHODS
  ///

  /// Stores user data in `users` table
  Future<RazgovorkoUser?> createUserProfile({
    required User supabaseUser,
    required String internationalPhoneNumber,
    required String nationalPhoneNumber,
    String? displayName,
    String? avatarUrl,
    String? status,
    String? aboutMe,
    String? location,
    DateTime? dateOfBirth,
  }) async {
    if (supabaseUser.email == null) {
      logger.e('UsersTableService -> createUserProfile() -> supabaseUser.email == null');
      return null;
    }

    try {
      final now = DateTime.now();

      /// Create new [RazgovorkoUser]
      final user = RazgovorkoUser(
        id: supabaseUser.id,
        email: supabaseUser.email!,
        internationalPhoneNumber: internationalPhoneNumber,
        nationalPhoneNumber: nationalPhoneNumber,
        displayName: displayName ?? supabaseUser.email!.split('@').first, // Use email username as default
        avatarUrl: avatarUrl,
        status: status,
        aboutMe: aboutMe,
        location: location,
        dateOfBirth: dateOfBirth,
        lastSeen: now,
        createdAt: now,
        updatedAt: now,
        isOnline: true,
      );

      /// Insert into `users` table
      final userResponse = await supabase.from('users').insert(user.toMap()).select().maybeSingle();

      if (userResponse != null) {
        final parsedUser = RazgovorkoUser.fromMap(userResponse);

        logger.t('UsersTableService -> createUserProfile() -> success!');
        return parsedUser;
      } else {
        logger.e('UsersTableService -> createUserProfile() -> userResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('UsersTableService -> createUserProfile() -> $e');
      return null;
    }
  }

  /// Updates user data in `users` table
  Future<RazgovorkoUser?> updateUserProfile({
    String? email,
    String? phoneNumber,
    String? displayName,
    String? avatarUrl,
    String? status,
    String? aboutMe,
    String? location,
    DateTime? dateOfBirth,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final userResponse = await supabase
          .from('users')
          .update({
            if (email != null) 'email': email,
            if (phoneNumber != null) 'phone_number': phoneNumber,
            if (displayName != null) 'display_name': displayName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
            if (status != null) 'status': status,
            if (aboutMe != null) 'about_me': aboutMe,
            if (location != null) 'location': location,
            if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (userResponse != null) {
        final parsedUser = RazgovorkoUser.fromMap(userResponse);

        logger.t('UsersTableService -> updateUserProfile() -> success!');
        return parsedUser;
      } else {
        logger.e('UsersTableService -> updateUserProfile() -> userResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('UsersTableService -> updateUserProfile() -> $e');
      return null;
    }
  }

  /// Update `user` online status
  Future<bool> updateOnlineStatus({required bool isOnline}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      await supabase.from('users').update({
        'is_online': isOnline,
        if (!isOnline) 'last_seen': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      logger.t('UsersTableService -> updateOnlineStatus() -> success!');
      return true;
    } catch (e) {
      logger.e('UsersTableService -> updateOnlineStatus() -> $e');
      return false;
    }
  }

  /// Searches `display_name`, `email` and `phone_number` columns in the `users` table using the passed `query`
  Future<List<RazgovorkoUser>?> searchUsers({required String query}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final response = await supabase
          .from('users')
          .select()
          .neq('id', userId)
          .eq('is_deleted', false)
          .or('display_name.ilike.%$query%,email.ilike.%$query%,phone_number.ilike.%$query%')
          .order('display_name');

      final users = response.isNotEmpty ? response.map((json) => RazgovorkoUser.fromMap(json)).toList() : null;

      logger.t('UsersTableService -> searchUsers() -> success!');
      return users;
    } catch (e) {
      logger.e('UsersTableService -> searchUsers() -> $e');
      return null;
    }
  }

  /// Soft delete `user` account
  Future<bool> deleteUserProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final now = DateTime.now();

      await supabase.from('users').update({
        'deleted_at': now.toIso8601String(),
        'is_online': false,
        'last_seen': now.toIso8601String(),
        'pushNotificationToken': null,
        'updated_at': now.toIso8601String(),
      }).eq('id', userId);

      logger.t('UsersTableService -> deleteUserProfile() -> success!');
      return true;
    } catch (e) {
      logger.e('UsersTableService -> deleteUserProfile() -> $e');
      return false;
    }
  }
}
