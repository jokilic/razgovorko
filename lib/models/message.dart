import 'dart:convert';

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String messageType;
  final String? content;
  final String? mediaUrl;
  final bool isViewOnce;
  final String? replyTo;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Message({
    required this.chatId,
    required this.senderId,
    required this.messageType,
    required this.isViewOnce,
    required this.isDeleted,
    required this.createdAt,
    this.id = '', // ID should be handled by Supabase
    this.content,
    this.mediaUrl,
    this.replyTo,
    this.updatedAt,
  });

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? messageType,
    String? content,
    String? mediaUrl,
    bool? isViewOnce,
    String? replyTo,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Message(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId,
        messageType: messageType ?? this.messageType,
        content: content ?? this.content,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        isViewOnce: isViewOnce ?? this.isViewOnce,
        replyTo: replyTo ?? this.replyTo,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        // 'id': id,
        'chat_id': chatId,
        'sender_id': senderId,
        'message_type': messageType,
        'content': content,
        'media_url': mediaUrl,
        'is_view_once': isViewOnce,
        'reply_to': replyTo,
        'is_deleted': isDeleted,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        id: map['id'] as String,
        chatId: map['chat_id'] as String,
        senderId: map['sender_id'] as String,
        messageType: map['message_type'] as String,
        content: map['content'] != null ? map['content'] as String : null,
        mediaUrl: map['media_url'] != null ? map['media_url'] as String : null,
        isViewOnce: map['is_view_once'] as bool,
        replyTo: map['reply_to'] != null ? map['reply_to'] as String : null,
        isDeleted: map['is_deleted'] as bool,
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      );

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Message(id: $id, chatId: $chatId, senderId: $senderId, messageType: $messageType, content: $content, mediaUrl: $mediaUrl, isViewOnce: $isViewOnce, replyTo: $replyTo, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.chatId == chatId &&
        other.senderId == senderId &&
        other.messageType == messageType &&
        other.content == content &&
        other.mediaUrl == mediaUrl &&
        other.isViewOnce == isViewOnce &&
        other.replyTo == replyTo &&
        other.isDeleted == isDeleted &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      chatId.hashCode ^
      senderId.hashCode ^
      messageType.hashCode ^
      content.hashCode ^
      mediaUrl.hashCode ^
      isViewOnce.hashCode ^
      replyTo.hashCode ^
      isDeleted.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
