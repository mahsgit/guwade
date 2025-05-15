part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated(this.token);

  @override
  List<Object> get props => [token];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileLoading extends AuthState {}

class ProfileLoaded extends AuthState {
  final AuthUser user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends AuthState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
