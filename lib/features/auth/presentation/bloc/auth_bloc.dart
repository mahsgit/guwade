import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../features/storytelling/data/datasources/storytelling_remote_datasource.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetProfileUseCase getProfileUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.getProfileUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<GetProfileRequested>(_onGetProfileRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        username: event.username,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) {
        // Update the token in StorytellingRemoteDataSource
        final storytellingDataSource = sl<StorytellingRemoteDataSource>()
            as StorytellingRemoteDataSourceImpl;
        storytellingDataSource.updateToken(token);
        emit(AuthAuthenticated(token));
      },
    );
  }

  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Clear local storage/token
    emit(AuthInitial());
  }
}
