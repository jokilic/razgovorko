class RazgovorkoUser {
  final String id;
  final String email;
  final String? internationalPhoneNumber;
  final String? nationalPhoneNumber;
  final String displayName;
  final String? avatarUrl;
  final String? status;
  final String? aboutMe;
  final String? location;
  final DateTime? dateOfBirth;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? pushNotificationToken;

  RazgovorkoUser({
    required this.id,
    required this.email,
    required this.internationalPhoneNumber,
    required this.nationalPhoneNumber,
    required this.displayName,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
    this.status,
    this.aboutMe,
    this.location,
    this.dateOfBirth,
    this.deletedAt,
    this.pushNotificationToken,
  });

  RazgovorkoUser copyWith({
    String? id,
    String? email,
    String? internationalPhoneNumber,
    String? nationalPhoneNumber,
    String? displayName,
    String? avatarUrl,
    String? status,
    String? aboutMe,
    String? location,
    DateTime? dateOfBirth,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? pushNotificationToken,
  }) =>
      RazgovorkoUser(
        id: id ?? this.id,
        email: email ?? this.email,
        internationalPhoneNumber: internationalPhoneNumber ?? this.internationalPhoneNumber,
        nationalPhoneNumber: nationalPhoneNumber ?? this.nationalPhoneNumber,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        status: status ?? this.status,
        aboutMe: aboutMe ?? this.aboutMe,
        location: location ?? this.location,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        isOnline: isOnline ?? this.isOnline,
        lastSeen: lastSeen ?? this.lastSeen,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        pushNotificationToken: pushNotificationToken ?? this.pushNotificationToken,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'email': email,
        'international_phone_number': internationalPhoneNumber,
        'national_phone_number': nationalPhoneNumber,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'status': status,
        'about_me': aboutMe,
        'location': location,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'is_online': isOnline,
        'last_seen': lastSeen.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
        'push_notification_token': pushNotificationToken,
      };

  factory RazgovorkoUser.fromMap(Map<String, dynamic> map) => RazgovorkoUser(
        id: map['id'] as String,
        email: map['email'] as String,
        internationalPhoneNumber: map['international_phone_number'] as String,
        nationalPhoneNumber: map['national_phone_number'] as String,
        displayName: map['display_name'] as String,
        avatarUrl: map['avatar_url'] != null ? map['avatar_url'] as String : null,
        status: map['status'] != null ? map['status'] as String : null,
        aboutMe: map['about_me'] != null ? map['about_me'] as String : null,
        location: map['location'] != null ? map['location'] as String : null,
        dateOfBirth: map['date_of_birth'] != null ? DateTime.parse(map['date_of_birth']) : null,
        isOnline: map['is_online'] as bool,
        lastSeen: DateTime.parse(map['last_seen']),
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
        deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
        pushNotificationToken: map['push_notification_token'] != null ? map['push_notification_token'] as String : null,
      );

  @override
  String toString() =>
      'RazgovorkoUser(id: $id, email: $email, internationalPhoneNumber: $internationalPhoneNumber, nationalPhoneNumber: $nationalPhoneNumber, displayName: $displayName, avatarUrl: $avatarUrl, status: $status, aboutMe: $aboutMe, location: $location, dateOfBirth: $dateOfBirth, isOnline: $isOnline, lastSeen: $lastSeen, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, pushNotificationToken: $pushNotificationToken)';

  @override
  bool operator ==(covariant RazgovorkoUser other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.email == email &&
        other.internationalPhoneNumber == internationalPhoneNumber &&
        other.nationalPhoneNumber == nationalPhoneNumber &&
        other.displayName == displayName &&
        other.avatarUrl == avatarUrl &&
        other.status == status &&
        other.aboutMe == aboutMe &&
        other.location == location &&
        other.dateOfBirth == dateOfBirth &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.pushNotificationToken == pushNotificationToken;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      internationalPhoneNumber.hashCode ^
      nationalPhoneNumber.hashCode ^
      displayName.hashCode ^
      avatarUrl.hashCode ^
      status.hashCode ^
      aboutMe.hashCode ^
      location.hashCode ^
      dateOfBirth.hashCode ^
      isOnline.hashCode ^
      lastSeen.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode ^
      pushNotificationToken.hashCode;
}
