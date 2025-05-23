import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/science/domain/entities/answer_result.dart';
import 'package:buddy/features/science/domain/entities/question.dart';
import 'package:dartz/dartz.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<Question>>> getQuestions(String topic, int limit);
  Future<Either<Failure, AnswerResult>> submitAnswer(String questionId, int selectedIndex);
}
