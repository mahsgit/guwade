import 'package:buddy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:buddy/features/storytelling/data/datasources/story_local_data_source.dart';
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
  final AuthLocalDataSource authLocalDataSource;
  final StoryLocalDataSource localDataSource;

  StorytellingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.authLocalDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await authLocalDataSource.getToken();
        if (token == null) {
          return Left(AuthFailure('Session expired. Please login again.'));
        }
        final stories = await remoteDataSource.getStories();
        return Right(stories);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure('Failed to get stories'));
      }
    } else {
      final stories = await localDataSource.getStories();
      return Right(stories);
    }
  }

  @override
  Future<Either<Failure, List<Vocabulary>>> getVocabulary() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await authLocalDataSource.getToken();
        if (token == null) {
          return Left(AuthFailure('Session expired. Please login again.'));
        }
        final vocabulary = await remoteDataSource.getVocabulary();
        return Right(vocabulary);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure('Failed to get vocabulary'));
      }
    } else {
      final vocabulary = await localDataSource.getVocabulary();
      return Right(vocabulary);
    }
  }

  

  @override
  Future<Either<Failure, String>> detectEmotion(List<List<int>> frames) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await authLocalDataSource.getToken();
        if (token == null) {
          return Left(AuthFailure('Session expired. Please login again.'));
        }
        final emotion = await remoteDataSource.detectEmotion(frames);
        return Right(emotion);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure('Failed to detect emotion'));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Story>> changeStory(String currentStoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await authLocalDataSource.getToken();
        if (token == null) {
          return Left(AuthFailure('Session expired. Please login again.'));
        }
        final story = await remoteDataSource.changeStory(currentStoryId);
        return Right(story);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure('Failed to change story'));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }
}
