import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/quiz/domain/entities/question.dart';
import 'package:dartz/dartz.dart';


abstract class QuizRepository {
  Future<Either<Failure, List<Question>>> getQuestions();
  Future<Either<Failure, bool>> checkAnswer(String questionId, String optionId);
}
