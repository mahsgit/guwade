import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/science/domain/entities/answer_result.dart';
import 'package:buddy/features/science/domain/repositories/quiz_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitAnswer {
  final QuizRepository repository;

  SubmitAnswer(this.repository);

  Future<Either<Failure, AnswerResult>> call(String questionId, int selectedIndex) {
    return repository.submitAnswer(questionId, selectedIndex);
  }
}
