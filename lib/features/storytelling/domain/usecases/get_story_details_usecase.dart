import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story_detail.dart';
import '../repositories/story_repository.dart';

class GetStoryDetailsUseCase {
  final StoryRepository repository;

  GetStoryDetailsUseCase(this.repository);

  Future<Either<Failure, StoryDetail>> call(String storyId) {
    return repository.getStoryDetails(storyId);
  }
}
