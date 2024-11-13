import 'dart:convert';

class ChatParticipant {
  final String chatId;
  final String userId;
  final String role;
  final bool isMuted;
  final DateTime joinedAt;

  ChatParticipant({
    required this.chatId,
    required this.userId,
    required this.role,
    required this.isMuted,
    required this.joinedAt,
  });

  ChatParticipant copyWith({
    String? chatId,
    String? userId,
    String? role,
    bool? isMuted,
    DateTime? joinedAt,
  }) =>
      ChatParticipant(
        chatId: chatId ?? this.chatId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        isMuted: isMuted ?? this.isMuted,
        joinedAt: joinedAt ?? this.joinedAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'chat_id': chatId,
        'user_id': userId,
        'role': role,
        'is_muted': isMuted,
        'joined_at': joinedAt.toIso8601String(),
      };

  factory ChatParticipant.fromMap(Map<String, dynamic> map) => ChatParticipant(
        chatId: map['chat_id'] as String,
        userId: map['user_id'] as String,
        role: map['role'] as String,
        isMuted: map['is_muted'] as bool,
        joinedAt: DateTime.parse(map['joined_at']),
      );

  String toJson() => json.encode(toMap());

  factory ChatParticipant.fromJson(String source) => ChatParticipant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatParticipant(chatId: $chatId, userId: $userId, role: $role, isMuted: $isMuted, joinedAt: $joinedAt)';

  @override
  bool operator ==(covariant ChatParticipant other) {
    if (identical(this, other)) {
      return true;
    }

    return other.chatId == chatId && other.userId == userId && other.role == role && other.isMuted == isMuted && other.joinedAt == joinedAt;
  }

  @override
  int get hashCode => chatId.hashCode ^ userId.hashCode ^ role.hashCode ^ isMuted.hashCode ^ joinedAt.hashCode;
}
