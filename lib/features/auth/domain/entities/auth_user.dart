import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? profilePicture;
  final String nickname;
  final DateTime birthDate;
  final DateTime createdAt;
  final DateTime? updatedAt; // Made optional as it's not in the JSON

  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    this.profilePicture,
    required this.nickname,
    required this.birthDate,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
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

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['user_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profilePicture: json['profile_picture'] as String?,
      nickname: json['nickname'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        profilePicture,
        nickname,
        birthDate,
        createdAt,
        updatedAt,
      ];
}