// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/story.dart';
// import '../entities/story_detail.dart';

// abstract class StoryRepository {
//   Future<Either<Failure, List<Story>>> getStories();
//   Future<Either<Failure, List<Story>>> getStoriesByCategory(String category);
//   Future<Either<Failure, List<Story>>> getFeaturedStories();
//   Future<Either<Failure, List<Story>>> getRecommendedStories();
//   Future<Either<Failure, StoryDetail>> getStoryDetails(String storyId);
//   Future<Either<Failure, void>> updateStoryProgress(String storyId, double progress);
//   Future<Either<Failure, String>> getAdaptedStoryContent(String storyId, String mood);
// }
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story.dart';
import '../entities/story_detail.dart';
import '../entities/emotion_result.dart';

abstract class StoryRepository {
  Future<Either<Failure, List<Story>>> getStories();
  Future<Either<Failure, List<Story>>> getStoriesByCategory(String category);
  Future<Either<Failure, List<Story>>> getFeaturedStories();
  Future<Either<Failure, List<Story>>> getRecommendedStories();
  Future<Either<Failure, StoryDetail>> getStoryDetails(String storyId);
  Future<Either<Failure, void>> updateStoryProgress(String storyId, double progress);
  Future<Either<Failure, String>> getAdaptedStoryContent(String storyId, String mood);
  Future<Either<Failure, EmotionResult>> detectEmotion(List<XFile> images);
}
