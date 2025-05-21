part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  final bool isOfflineMode;

  const LoginRequested({
    required this.username,
    required this.password,
    this.isOfflineMode = false,
  });

  @override
  List<Object> get props => [username, password, isOfflineMode];
}

class GetProfileRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
