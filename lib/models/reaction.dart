class Reaction {
  final String id;
  final String userId;
  final String messageId;
  final String reaction;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Reaction({
    required this.userId,
    required this.messageId,
    required this.reaction,
    required this.createdAt,
    this.id = '', // ID should be handled by Supabase
    this.updatedAt,
    this.deletedAt,
  });

  Reaction copyWith({
    String? id,
    String? userId,
    String? messageId,
    String? reaction,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      Reaction(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        messageId: messageId ?? this.messageId,
        reaction: reaction ?? this.reaction,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'user_id': userId,
        'message_id': messageId,
        'reaction': reaction,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  factory Reaction.fromMap(Map<String, dynamic> map) => Reaction(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        messageId: map['message_id'] as String,
        reaction: map['reaction'] as String,
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
        deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      );

  @override
  String toString() => 'Reaction(id: $id, userId: $userId, messageId: $messageId, reaction: $reaction, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';

  @override
  bool operator ==(covariant Reaction other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.userId == userId &&
        other.messageId == messageId &&
        other.reaction == reaction &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ messageId.hashCode ^ reaction.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ deletedAt.hashCode;
}
