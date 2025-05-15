import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:buddy/features/quiz/domain/entities/question.dart';
import 'package:buddy/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:dartz/dartz.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Question>>> getQuestions() async {
    try {
      final questions = await remoteDataSource.getQuestions();
      return Right(questions);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch questions'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAnswer(
      String questionId, String optionId) async {
    try {
      final isCorrect =
          await remoteDataSource.checkAnswer(questionId, optionId);
      return Right(isCorrect);
    } catch (e) {
      return Left(ServerFailure('Failed to check answer'));
    }
  }
}
