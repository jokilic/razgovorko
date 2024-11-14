import 'package:flutter/foundation.dart';

enum ChatType {
  individual,
  group,
}

class Chat {
  final String id;
  final ChatType chatType;
  final String name;
  final String? description;
  final String? avatarUrl;
  final DateTime createdAt;
  final String createdBy;
  final List<String> participants;
  final List<String>? usersTyping;

  Chat({
    required this.chatType,
    required this.name,
    required this.createdAt,
    required this.createdBy,
    required this.participants,
    this.id = '', // ID should be handled by Supabase
    this.description,
    this.avatarUrl,
    this.usersTyping,
  });

  Chat copyWith({
    String? id,
    ChatType? chatType,
    String? name,
    String? description,
    String? avatarUrl,
    DateTime? createdAt,
    String? createdBy,
    List<String>? participants,
    List<String>? usersTyping,
  }) =>
      Chat(
        id: id ?? this.id,
        chatType: chatType ?? this.chatType,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        participants: participants ?? this.participants,
        usersTyping: usersTyping ?? this.usersTyping,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'chat_type': chatType.name,
        'name': name,
        'description': description,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
        'created_by': createdBy,
        'participants': participants,
        'users_typing': usersTyping,
      };

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
        id: map['id'] as String,
        chatType: ChatType.values.byName(map['chat_type'] as String),
        name: map['name'] as String,
        description: map['description'] != null ? map['description'] as String : null,
        avatarUrl: map['avatar_url'] != null ? map['avatar_url'] as String : null,
        createdAt: DateTime.parse(map['created_at']),
        createdBy: map['created_by'] as String,
        participants: List<String>.from(map['participants'] as List),
        usersTyping: map['users_typing'] != null ? List<String>.from(map['users_typing'] as List) : null,
      );

  @override
  String toString() =>
      'Chat(id: $id, chatType: $chatType, name: $name, description: $description, avatarUrl: $avatarUrl, createdAt: $createdAt, createdBy: $createdBy, participants: $participants, usersTyping: $usersTyping)';

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
        other.createdBy == createdBy &&
        listEquals(other.participants, participants) &&
        listEquals(other.usersTyping, usersTyping);
  }

  @override
  int get hashCode =>
      id.hashCode ^
      chatType.hashCode ^
      name.hashCode ^
      description.hashCode ^
      avatarUrl.hashCode ^
      createdAt.hashCode ^
      createdBy.hashCode ^
      participants.hashCode ^
      usersTyping.hashCode;
}
