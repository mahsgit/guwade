import 'package:buddy/core/error/exceptions.dart';
import 'package:buddy/core/error/failures.dart';
import 'package:buddy/core/network/network_info.dart';
import 'package:buddy/features/science/data/datasources/quiz_local_data_source.dart';
import 'package:buddy/features/science/data/datasources/quiz_remote_data_source.dart';
import 'package:buddy/features/science/domain/entities/answer_result.dart';
import 'package:buddy/features/science/domain/entities/question.dart';
import 'package:buddy/features/science/domain/repositories/quiz_repository.dart';
import 'package:dartz/dartz.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;
  final QuizLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuizRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Question>>> getQuestions(
      String topic, int limit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuestions =
            await remoteDataSource.getQuestions(topic, limit);
        await localDataSource.cacheQuestions(topic, remoteQuestions);
        return Right(remoteQuestions);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        // Try to get cached questions if server fails
        try {
          final localQuestions =
              await localDataSource.getCachedQuestions(topic);
          if (localQuestions.isNotEmpty) {
            return Right(localQuestions);
          }
          return Left(ServerFailure(e.message));
        } catch (localError) {
          return Left(ServerFailure(e.message));
        }
      }
    } else {
      try {
        final localQuestions = await localDataSource.getCachedQuestions(topic);
        if (localQuestions.isNotEmpty) {
          return Right(localQuestions);
        }
        return Left(NetworkFailure(
            'No internet connection and no cached questions available.'));
      } catch (e) {
        return Left(CacheFailure('Failed to load cached questions.'));
      }
    }
  }

  @override
  Future<Either<Failure, AnswerResult>> submitAnswer(
      String questionId, int selectedIndex) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await remoteDataSource.submitAnswer(questionId, selectedIndex);
        return Right(result);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(
          NetworkFailure('No internet connection. Cannot submit answer.'));
    }
  }
}
