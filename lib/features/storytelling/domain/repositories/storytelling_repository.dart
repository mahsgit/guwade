import 'package:buddy/core/error/failures.dart';
import 'package:buddy/features/storytelling/domain/entities/story.dart';
import 'package:buddy/features/storytelling/domain/entities/vocabulary.dart';
import 'package:dartz/dartz.dart';

abstract class StorytellingRepository {
  Future<Either<Failure, List<Story>>> getStories();
  Future<Either<Failure, List<Vocabulary>>> getVocabulary();
  Future<Either<Failure, String>> detectEmotion(List<List<int>> frames);
  Future<Either<Failure, Story>> changeStory(String currentStoryId);
}