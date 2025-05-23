import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/storytelling/domain/entities/story.dart';
import 'package:buddy/features/storytelling/domain/repositories/storytelling_repository.dart';
import 'package:dartz/dartz.dart';

class ChangeStoryusecase {
  final StorytellingRepository repository;

  ChangeStoryusecase(this.repository);

  Future<Either<Failure, Story>> call(String currentStoryId) async {
    return await repository.changeStory(currentStoryId);
  }
}