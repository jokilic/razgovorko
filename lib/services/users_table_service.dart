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

  /// Stream specific `users` by IDs
  Stream<List<RazgovorkoUser>?> streamUsersByIds(List<String> userIds) {
    if (userIds.isEmpty) {
      return Stream.value(null);
    }

    return supabase.from('users').stream(primaryKey: ['id']).inFilter('id', userIds).map(
          (data) => data.isNotEmpty ? data.map((json) => RazgovorkoUser.fromMap(json)).toList() : null,
        );
  }

  ///
  /// METHODS
  ///

  /// Stores user data in `users` table
  Future<RazgovorkoUser?> createUserProfile({
    required User supabaseUser,
    String? displayName,
    String? avatarUrl,
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
        phoneNumber: supabaseUser.phone,
        displayName: displayName ?? supabaseUser.email!.split('@')[0], // Use email username as default
        avatarUrl: avatarUrl,
        status: 'Hello, I am using Razgovorko!',
        aboutMe: aboutMe,
        location: location,
        dateOfBirth: dateOfBirth,
        lastSeen: now,
        createdAt: now,
        isOnline: true,
        isDeleted: false,
      );

      /// Insert into `users` table
      final userResponse = await supabase.from('users').upsert(user.toMap()).select().maybeSingle();

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
    String? status,
    String? aboutMe,
    String? location,
    DateTime? dateOfBirth,
    String? avatarUrl,
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
            if (status != null) 'status': status,
            if (aboutMe != null) 'about_me': aboutMe,
            if (location != null) 'location': location,
            if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
            if (avatarUrl != null) 'avatar_url': avatarUrl,
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
        'last_seen': DateTime.now().toIso8601String(),
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
      final users = response.map((json) => RazgovorkoUser.fromMap(json)).toList();

      logger.t('UsersTableService -> searchUsers() -> success!');
      return users;
    } catch (e) {
      logger.e('UsersTableService -> searchUsers() -> $e');
      return null;
    }
  }

  /// Get `user` by ID
  Future<RazgovorkoUser?> getUserById({required String userId}) async {
    try {
      final userResponse = await supabase.from('users').select().eq('id', userId).eq('is_deleted', false).maybeSingle();

      if (userResponse != null) {
        final user = RazgovorkoUser.fromMap(userResponse);

        logger.t('UsersTableService -> getUserById() -> success!');
        return user;
      } else {
        logger.e('UsersTableService -> getUserById() -> userResponse == null');
        return null;
      }
    } catch (e) {
      logger.e('UsersTableService -> getUserById() -> $e');
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

      await supabase.from('users').update({
        'is_deleted': true,
        'deleted_at': DateTime.now().toIso8601String(),
        'is_online': false,
      }).eq('id', userId);

      logger.t('UsersTableService -> deleteUserProfile() -> success!');
      return true;
    } catch (e) {
      logger.e('UsersTableService -> deleteUserProfile() -> $e');
      return false;
    }
  }
}
