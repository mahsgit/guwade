import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/story.dart';
import '../repositories/storytelling_repository.dart';

class GetStoriesUseCase implements UseCase<List<Story>, NoParams> {
  final StorytellingRepository repository;

  GetStoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Story>>> call(NoParams params) async {
    return await repository.getStories();
  }
}
