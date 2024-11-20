enum ChatRole {
  owner,
  admin,
  member,
}

class ChatUserStatus {
  final String id;
  final String userId;
  final String chatId;
  final String? lastReadMessageId;
  final DateTime? lastReadAt;
  final bool isMuted;
  final bool isPinned;
  final bool isTyping;
  final ChatRole role;
  final DateTime joinedAt;
  final DateTime? leftAt;

  ChatUserStatus({
    required this.userId,
    required this.chatId,
    required this.isMuted,
    required this.isPinned,
    required this.isTyping,
    required this.role,
    required this.joinedAt,
    this.id = '', // ID should be handled by Supabase
    this.lastReadMessageId,
    this.lastReadAt,
    this.leftAt,
  });

  ChatUserStatus copyWith({
    String? id,
    String? userId,
    String? chatId,
    String? lastReadMessageId,
    DateTime? lastReadAt,
    bool? isMuted,
    bool? isPinned,
    bool? isTyping,
    ChatRole? role,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) =>
      ChatUserStatus(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        chatId: chatId ?? this.chatId,
        lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        isMuted: isMuted ?? this.isMuted,
        isPinned: isPinned ?? this.isPinned,
        isTyping: isTyping ?? this.isTyping,
        role: role ?? this.role,
        joinedAt: joinedAt ?? this.joinedAt,
        leftAt: leftAt ?? this.leftAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'user_id': userId,
        'chat_id': chatId,
        'last_read_message_id': lastReadMessageId,
        'last_read_at': lastReadAt?.toIso8601String(),
        'is_muted': isMuted,
        'is_pinned': isPinned,
        'is_typing': isTyping,
        'role': role.name,
        'joined_at': joinedAt.toIso8601String(),
        'left_at': leftAt?.toIso8601String(),
      };

  factory ChatUserStatus.fromMap(Map<String, dynamic> map) => ChatUserStatus(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        chatId: map['chat_id'] as String,
        lastReadMessageId: map['last_read_message_id'] != null ? map['last_read_message_id'] as String : null,
        lastReadAt: map['last_read_at'] != null ? DateTime.parse(map['last_read_at']) : null,
        isMuted: map['is_muted'] as bool,
        isPinned: map['is_pinned'] as bool,
        isTyping: map['is_typing'] as bool,
        role: ChatRole.values.byName(map['role'] as String),
        joinedAt: DateTime.parse(map['joined_at']),
        leftAt: map['left_at'] != null ? DateTime.parse(map['left_at']) : null,
      );

  @override
  String toString() =>
      'ChatUserStatus(id: $id, userId: $userId, chatId: $chatId, lastReadMessageId: $lastReadMessageId, lastReadAt: $lastReadAt, isMuted: $isMuted, isPinned: $isPinned, isTyping: $isTyping, role: $role, joinedAt: $joinedAt, leftAt: $leftAt)';

  @override
  bool operator ==(covariant ChatUserStatus other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.userId == userId &&
        other.chatId == chatId &&
        other.lastReadMessageId == lastReadMessageId &&
        other.lastReadAt == lastReadAt &&
        other.isMuted == isMuted &&
        other.isPinned == isPinned &&
        other.isTyping == isTyping &&
        other.role == role &&
        other.joinedAt == joinedAt &&
        other.leftAt == leftAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      chatId.hashCode ^
      lastReadMessageId.hashCode ^
      lastReadAt.hashCode ^
      isMuted.hashCode ^
      isPinned.hashCode ^
      isTyping.hashCode ^
      role.hashCode ^
      joinedAt.hashCode ^
      leftAt.hashCode;
}
