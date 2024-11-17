enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  location,
  contact,
  voice,
  sticker,
  gif,
}

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final MessageType messageType;
  final String content;
  final String? replyToMessageId;
  final bool isViewOnce;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Message({
    required this.chatId,
    required this.senderId,
    required this.messageType,
    required this.content,
    required this.isViewOnce,
    required this.isDeleted,
    required this.createdAt,
    this.id = '', // ID should be handled by Supabase
    this.replyToMessageId,
    this.updatedAt,
    this.deletedAt,
  });

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    MessageType? messageType,
    String? content,
    String? replyToMessageId,
    bool? isViewOnce,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? viewedAt,
    DateTime? deletedAt,
  }) =>
      Message(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId,
        messageType: messageType ?? this.messageType,
        content: content ?? this.content,
        replyToMessageId: replyToMessageId ?? this.replyToMessageId,
        isViewOnce: isViewOnce ?? this.isViewOnce,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'chat_id': chatId,
        'sender_id': senderId,
        'message_type': messageType.name,
        'content': content,
        'reply_to_message_id': replyToMessageId,
        'is_view_once': isViewOnce,
        'is_deleted': isDeleted,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        id: map['id'] as String,
        chatId: map['chat_id'] as String,
        senderId: map['sender_id'] as String,
        messageType: MessageType.values.byName(map['message_type'] as String),
        content: map['content'] as String,
        replyToMessageId: map['reply_to_message_id'] != null ? map['reply_to_message_id'] as String : null,
        isViewOnce: map['is_view_once'] as bool,
        isDeleted: map['is_deleted'] as bool,
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
        deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      );

  @override
  String toString() =>
      'Message(id: $id, chatId: $chatId, senderId: $senderId, messageType: $messageType, content: $content, replyToMessageId: $replyToMessageId, isViewOnce: $isViewOnce, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';

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
        other.replyToMessageId == replyToMessageId &&
        other.isViewOnce == isViewOnce &&
        other.isDeleted == isDeleted &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      chatId.hashCode ^
      senderId.hashCode ^
      messageType.hashCode ^
      content.hashCode ^
      replyToMessageId.hashCode ^
      isViewOnce.hashCode ^
      isDeleted.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
}
