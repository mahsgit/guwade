import '../../domain/entities/auth_user.dart';

class UserProfileModel extends AuthUser {
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.email,
    super.profilePicture,
    required super.nickname,
    required super.birthDate,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['user_id'],
      username: json['username'],
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'],
      nickname: json['nickname'],
      birthDate: DateTime.parse(json['birth_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'user_id': id,
        'username': username,
        'email': email,
        'profile_picture': profilePicture,
        'nickname': nickname,
        'birth_date': birthDate.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}