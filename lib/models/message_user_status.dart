class MessageUserStatus {
  final String id;
  final String userId;
  final String messageId;
  final String? reaction;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? viewedAt;
  final DateTime? deletedAt;

  MessageUserStatus({
    required this.userId,
    required this.messageId,
    required this.createdAt,
    this.id = '', // ID should be handled by Supabase
    this.reaction,
    this.updatedAt,
    this.viewedAt,
    this.deletedAt,
  });

  MessageUserStatus copyWith({
    String? id,
    String? userId,
    String? messageId,
    String? reaction,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? viewedAt,
    DateTime? deletedAt,
  }) =>
      MessageUserStatus(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        messageId: messageId ?? this.messageId,
        reaction: reaction ?? this.reaction,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        viewedAt: viewedAt ?? this.viewedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'user_id': userId,
        'message_id': messageId,
        'reaction': reaction,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'viewed_at': viewedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  factory MessageUserStatus.fromMap(Map<String, dynamic> map) => MessageUserStatus(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        messageId: map['message_id'] as String,
        reaction: map['reaction'] != null ? map['reaction'] as String : null,
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
        viewedAt: map['viewed_at'] != null ? DateTime.parse(map['viewed_at']) : null,
        deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      );

  @override
  String toString() =>
      'MessageUserStatus(id: $id, userId: $userId, messageId: $messageId, reaction: $reaction, createdAt: $createdAt, updatedAt: $updatedAt, viewedAt: $viewedAt, deletedAt: $deletedAt)';

  @override
  bool operator ==(covariant MessageUserStatus other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.userId == userId &&
        other.messageId == messageId &&
        other.reaction == reaction &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.viewedAt == viewedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ messageId.hashCode ^ reaction.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ viewedAt.hashCode ^ deletedAt.hashCode;
}
