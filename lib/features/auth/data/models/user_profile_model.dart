import '../../domain/entities/auth_user.dart';

class UserProfileModel extends AuthUser {
  const UserProfileModel({
    required String id,
    required String username,
    required String email,
    String? profilePicture,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          username: username,
          email: email,
          profilePicture: profilePicture,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['user_id'],
      username: json['username'],
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': id,
        'username': username,
        'email': email,
        'profile_picture': profilePicture,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
