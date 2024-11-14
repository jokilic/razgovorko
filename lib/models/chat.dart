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
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? deletedAt;
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
    this.lastMessageId,
    this.lastMessageAt,
    this.deletedAt,
    this.usersTyping,
  });

  Chat copyWith({
    String? id,
    ChatType? chatType,
    String? name,
    String? description,
    String? avatarUrl,
    String? lastMessageId,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    String? createdBy,
    DateTime? deletedAt,
    List<String>? participants,
    List<String>? usersTyping,
  }) =>
      Chat(
        id: id ?? this.id,
        chatType: chatType ?? this.chatType,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        deletedAt: deletedAt ?? this.deletedAt,
        participants: participants ?? this.participants,
        usersTyping: usersTyping ?? this.usersTyping,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'chat_type': chatType.name,
        'name': name,
        'description': description,
        'avatar_url': avatarUrl,
        'last_message_id': lastMessageId,
        'last_message_at': lastMessageAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'created_by': createdBy,
        'deleted_at': deletedAt?.toIso8601String(),
        'participants': participants,
        'users_typing': usersTyping,
      };

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
        id: map['id'] as String,
        chatType: ChatType.values.byName(map['chat_type'] as String),
        name: map['name'] as String,
        description: map['description'] != null ? map['description'] as String : null,
        avatarUrl: map['avatar_url'] != null ? map['avatar_url'] as String : null,
        lastMessageId: map['last_message_id'] != null ? map['last_message_id'] as String : null,
        lastMessageAt: map['last_message_at'] != null ? DateTime.parse(map['last_message_at']) : null,
        createdAt: DateTime.parse(map['created_at']),
        createdBy: map['created_by'] as String,
        deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
        participants: List<String>.from(map['participants'] as List<String>),
        usersTyping: map['users_typing'] != null ? List<String>.from(map['users_typing'] as List<String>) : null,
      );

  @override
  String toString() =>
      'Chat(id: $id, chatType: $chatType, name: $name, description: $description, avatarUrl: $avatarUrl, lastMessageId: $lastMessageId, lastMessageAt: $lastMessageAt, createdAt: $createdAt, createdBy: $createdBy, deletedAt: $deletedAt, participants: $participants, usersTyping: $usersTyping)';

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
        other.lastMessageId == lastMessageId &&
        other.lastMessageAt == lastMessageAt &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.deletedAt == deletedAt &&
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
      lastMessageId.hashCode ^
      lastMessageAt.hashCode ^
      createdAt.hashCode ^
      createdBy.hashCode ^
      deletedAt.hashCode ^
      participants.hashCode ^
      usersTyping.hashCode;
}
