import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/repositories/storytelling_repository.dart';
import '../datasources/storytelling_remote_datasource.dart';

class StorytellingRepositoryImpl implements StorytellingRepository {
  final StorytellingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StorytellingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    if (await networkInfo.isConnected) {
      try {
        final stories = await remoteDataSource.getStories();
        return Right(stories);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure('Failed to get stories'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Vocabulary>>> getVocabulary() async {
    if (await networkInfo.isConnected) {
      try {
        final vocabulary = await remoteDataSource.getVocabulary();
        return Right(vocabulary);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure('Failed to get vocabulary'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
