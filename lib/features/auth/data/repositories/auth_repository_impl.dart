import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<Either<Failure, String>> login(
      String username, String password) async {
    try {
      // Check internet connection
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        // Try online login
        final result = await remoteDataSource.login(username, password);
        // Cache the credentials for offline use
        await localDataSource.cacheUserCredentials(username, password);
        // Token is already cached in the remote data source
        return Right(result.accessToken);
      } else {
        // Try offline login
        final cachedCredentials = await localDataSource.getCachedCredentials();
        if (cachedCredentials != null &&
            cachedCredentials['username'] == username &&
            cachedCredentials['password'] == password) {
          // Get the cached token if available
          final token = await localDataSource.getToken();
          return Right(token ?? username); // Return token or username as fallback
        }
        return Left(ServerFailure(
            'No internet connection and invalid cached credentials'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear local session
      await localDataSource.clearUserCredentials();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getProfile() async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        final result = await remoteDataSource.getProfile();
        await localDataSource.cacheUserProfile(result);
        return Right(result);
      } else {
        final cachedProfile = await localDataSource.getCachedUserProfile();
        if (cachedProfile != null) {
          return Right(cachedProfile);
        }
        return Left(
            ServerFailure('No internet connection and no cached profile'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check if token exists
      final token = await localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}