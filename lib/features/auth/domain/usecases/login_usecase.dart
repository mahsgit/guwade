import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<String, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    try {
      // Try online login first
      final result =
          await authRepository.login(params.username, params.password);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  final bool isOfflineMode;

  const LoginParams({
    required this.username,
    required this.password,
    this.isOfflineMode = false,
  });

  @override
  List<Object> get props => [username, password, isOfflineMode];
}
