import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/science/domain/entities/question.dart';
import 'package:buddy/features/science/domain/repositories/quiz_repository.dart';
import 'package:dartz/dartz.dart';

class GetQuestions {
  final QuizRepository repository;

  GetQuestions(this.repository);

  Future<Either<Failure, List<Question>>> call(String topic, int limit) {
    return repository.getQuestions(topic, limit);
  }
}
