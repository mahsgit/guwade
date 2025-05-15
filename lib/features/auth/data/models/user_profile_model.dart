import '../../domain/entities/auth_user.dart';

class UserProfileModel extends AuthUser {
  const UserProfileModel({
    required super.userId,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.role,
    super.email,
    super.birthDate,
    super.nickname,
    required super.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      email: json['email'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      nickname: json['nickname'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        'email': email,
        'birth_date': birthDate?.toIso8601String(),
        'nickname': nickname,
        'created_at': createdAt.toIso8601String(),
      };
}
