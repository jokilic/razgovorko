import 'dart:convert';

class Chat {
  final String id;
  final String chatType;
  final String name;
  final String description;
  final String? avatarUrl;
  final DateTime createdAt;
  final String createdBy;

  Chat({
    required this.chatType,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    this.id = '', // ID should be handled by Supabase
    this.avatarUrl,
  });

  Chat copyWith({
    String? id,
    String? chatType,
    String? name,
    String? description,
    String? avatarUrl,
    DateTime? createdAt,
    String? createdBy,
  }) =>
      Chat(
        id: id ?? this.id,
        chatType: chatType ?? this.chatType,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'chat_type': chatType,
        'name': name,
        'description': description,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
        'created_by': createdBy,
      };

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
        id: map['id'] as String,
        chatType: map['chat_type'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        avatarUrl: map['avatar_url'] != null ? map['avatar_url'] as String : null,
        createdAt: DateTime.parse(map['created_at']),
        createdBy: map['created_by'] as String,
      );

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Chat(id: $id, chatType: $chatType, name: $name, description: $description, avatarUrl: $avatarUrl, createdAt: $createdAt, createdBy: $createdBy)';

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.chatType == chatType &&
        other.name == name &&
        other.description == description &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode => id.hashCode ^ chatType.hashCode ^ name.hashCode ^ description.hashCode ^ avatarUrl.hashCode ^ createdAt.hashCode ^ createdBy.hashCode;
}
