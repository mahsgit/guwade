import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String role;
  final String? email;
  final DateTime? birthDate;
  final String? nickname;
  final DateTime createdAt;

  const AuthUser({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.email,
    this.birthDate,
    this.nickname,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        firstName,
        lastName,
        role,
        email,
        birthDate,
        nickname,
        createdAt,
      ];
}
