import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> login(
      String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.login(username, password);
        return Right(response.accessToken);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure('Failed to login'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getProfile();
        return Right(user);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure('Failed to get profile'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
