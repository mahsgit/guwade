import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vocabulary.dart';
import '../repositories/storytelling_repository.dart';

class GetVocabularyUseCase implements UseCase<List<Vocabulary>, NoParams> {
  final StorytellingRepository repository;

  GetVocabularyUseCase(this.repository);

  @override
  Future<Either<Failure, List<Vocabulary>>> call(NoParams params) async {
    return await repository.getVocabulary();
  }
}
