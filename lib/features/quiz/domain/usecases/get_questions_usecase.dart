import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/question.dart';
import '../repositories/quiz_repository.dart';

class GetQuestionsUseCase {
  final QuizRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<Either<Failure, List<Question>>> call() {
    return repository.getQuestions();
  }
}
