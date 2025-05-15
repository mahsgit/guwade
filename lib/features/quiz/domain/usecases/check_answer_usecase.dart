import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quiz_repository.dart';

class CheckAnswerUseCase {
  final QuizRepository repository;

  CheckAnswerUseCase(this.repository);

  Future<Either<Failure, bool>> call(String questionId, String optionId) {
    return repository.checkAnswer(questionId, optionId);
  }
}
