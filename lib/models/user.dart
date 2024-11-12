class RazgovorkoUser {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String displayName;
  final String? avatarUrl;
  final String? status;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  RazgovorkoUser({
    required this.id,
    required this.displayName,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.phoneNumber,
    this.status,
    this.avatarUrl,
  });

  factory RazgovorkoUser.fromJson(Map<String, dynamic> json) => RazgovorkoUser(
        id: json['id'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        displayName: json['display_name'],
        avatarUrl: json['avatar_url'],
        status: json['status'],
        lastSeen: DateTime.parse(json['last_seen']),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone_number': phoneNumber,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'status': status,
        'last_seen': lastSeen.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  RazgovorkoUser copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? avatarUrl,
    String? status,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      RazgovorkoUser(
        id: id ?? this.id,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        status: status ?? this.status,
        lastSeen: lastSeen ?? this.lastSeen,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() =>
      'RazgovorkoUser(id: $id, email: $email, phoneNumber: $phoneNumber, displayName: $displayName, avatarUrl: $avatarUrl, status: $status, lastSeen: $lastSeen, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant RazgovorkoUser other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.displayName == displayName &&
        other.avatarUrl == avatarUrl &&
        other.status == status &&
        other.lastSeen == lastSeen &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      displayName.hashCode ^
      avatarUrl.hashCode ^
      status.hashCode ^
      lastSeen.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
