// import 'package:dartz/dartz.dart';
// import '../../../../core/error/exceptions.dart';
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/story.dart';
// import '../../domain/entities/story_detail.dart';
// import '../../domain/repositories/story_repository.dart';
// import '../datasources/story_local_data_source.dart';
// import '../datasources/story_remote_data_source.dart';

// class StoryRepositoryImpl implements StoryRepository {
//   final StoryRemoteDataSource remoteDataSource;
//   final StoryLocalDataSource localDataSource;

//   StoryRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//   });

//   @override
//   Future<Either<Failure, List<Story>>> getStories() async {
//     try {
//       final remoteStories = await remoteDataSource.getStories();
//       localDataSource.cacheStories(remoteStories);
//       return Right(remoteStories);
//     } on ServerException catch (e) {
//       try {
//         final localStories = await localDataSource.getStories();
//         return Right(localStories);
//       } on CacheException {
//         return Left(ServerFailure(message: e.message));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, List<Story>>> getStoriesByCategory(String category) async {
//     try {
//       final remoteStories = await remoteDataSource.getStories();
//       final filteredStories = remoteStories.where((story) => story.category == category).toList();
//       return Right(filteredStories);
//     } on ServerException catch (e) {
//       try {
//         final localStories = await localDataSource.getStories();
//         final filteredStories = localStories.where((story) => story.category == category).toList();
//         return Right(filteredStories);
//       } on CacheException {
//         return Left(ServerFailure(message: e.message));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, List<Story>>> getFeaturedStories() async {
//     try {
//       final remoteStories = await remoteDataSource.getStories();
//       final featuredStories = remoteStories.where((story) => story.isFeatured).toList();
//       return Right(featuredStories);
//     } on ServerException catch (e) {
//       try {
//         final localStories = await localDataSource.getStories();
//         final featuredStories = localStories.where((story) => story.isFeatured).toList();
//         return Right(featuredStories);
//       } on CacheException {
//         return Left(ServerFailure(message: e.message));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, List<Story>>> getRecommendedStories() async {
//     try {
//       final remoteStories = await remoteDataSource.getStories();
//       // In a real app, this would use an algorithm to determine recommendations
//       // For now, just return the most viewed stories
//       final sortedStories = remoteStories..sort((a, b) => b.viewCount.compareTo(a.viewCount));
//       return Right(sortedStories.take(5).toList());
//     } on ServerException catch (e) {
//       try {
//         final localStories = await localDataSource.getStories();
//         final sortedStories = localStories..sort((a, b) => b.viewCount.compareTo(a.viewCount));
//         return Right(sortedStories.take(5).toList());
//       } on CacheException {
//         return Left(ServerFailure(message: e.message));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, StoryDetail>> getStoryDetails(String storyId) async {
//     try {
//       final remoteStoryDetail = await remoteDataSource.getStoryDetails(storyId);
//       localDataSource.cacheStoryDetails(remoteStoryDetail);
//       return Right(remoteStoryDetail);
//     } on ServerException catch (e) {
//       try {
//         final localStoryDetail = await localDataSource.getStoryDetails(storyId);
//         return Right(localStoryDetail);
//       } on CacheException {
//         return Left(ServerFailure(message: e.message));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateStoryProgress(String storyId, double progress) async {
//     try {
//       await remoteDataSource.updateStoryProgress(storyId, progress);
//       await localDataSource.updateStoryProgress(storyId, progress);
//       return const Right(null);
//     } on ServerException catch (e) {
//       try {
//         await localDataSource.updateStoryProgress(storyId, progress);
//         return const Right(null);
//       } on CacheException {
//         return Left(ServerFailure(message: e.message));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, String>> getAdaptedStoryContent(String storyId, String mood) async {
//     try {
//       final adaptedContent = await remoteDataSource.getAdaptedStoryContent(storyId, mood);
//       return Right(adaptedContent);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(message: e.message));
//     }
//   }
// }
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_detail.dart';
import '../../domain/entities/emotion_result.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_local_data_source.dart';
import '../datasources/story_remote_data_source.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;
  final StoryLocalDataSource localDataSource;

  StoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, EmotionResult>> detectEmotion(
      List<XFile> images) async {
    try {
      final result = await remoteDataSource.detectEmotion(images);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to detect emotion'));
    } catch (e) {
      return Left(ServerFailure('Failed to detect emotion'));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    try {
      final remoteStories = await remoteDataSource.getStories();
      localDataSource.cacheStories(remoteStories);
      return Right(remoteStories);
    } on ServerException catch (e) {
      try {
        final localStories = await localDataSource.getStories();
        return Right(localStories);
      } on CacheException {
        return Left(ServerFailure('Failed to get stories'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getStoriesByCategory(
      String category) async {
    try {
      final remoteStories = await remoteDataSource.getStories();
      final filteredStories =
          remoteStories.where((story) => story.category == category).toList();
      return Right(filteredStories);
    } on ServerException catch (e) {
      try {
        final localStories = await localDataSource.getStories();
        final filteredStories =
            localStories.where((story) => story.category == category).toList();
        return Right(filteredStories);
      } on CacheException {
        return Left(ServerFailure('Failed to get stories'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getFeaturedStories() async {
    try {
      final remoteStories = await remoteDataSource.getStories();
      final featuredStories =
          remoteStories.where((story) => story.isFeatured).toList();
      return Right(featuredStories);
    } on ServerException catch (e) {
      try {
        final localStories = await localDataSource.getStories();
        final featuredStories =
            localStories.where((story) => story.isFeatured).toList();
        return Right(featuredStories);
      } on CacheException {
        return Left(ServerFailure('Failed to get stories'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getRecommendedStories() async {
    try {
      final remoteStories = await remoteDataSource.getStories();
      // In a real app, this would use an algorithm to determine recommendations
      // For now, just return the most viewed stories
      final sortedStories = remoteStories
        ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
      return Right(sortedStories.take(5).toList());
    } on ServerException catch (e) {
      try {
        final localStories = await localDataSource.getStories();
        final sortedStories = localStories
          ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
        return Right(sortedStories.take(5).toList());
      } on CacheException {
        return Left(ServerFailure('Failed to get recommended stories'));
      }
    }
  }

  @override
  Future<Either<Failure, StoryDetail>> getStoryDetails(String storyId) async {
    try {
      final remoteStoryDetail = await remoteDataSource.getStoryDetails(storyId);
      localDataSource.cacheStoryDetails(remoteStoryDetail);
      return Right(remoteStoryDetail);
    } on ServerException catch (e) {
      try {
        final localStoryDetail = await localDataSource.getStoryDetails(storyId);
        return Right(localStoryDetail);
      } on CacheException {
        return Left(ServerFailure('Failed to get story details'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateStoryProgress(
      String storyId, double progress) async {
    try {
      await remoteDataSource.updateStoryProgress(storyId, progress);
      await localDataSource.updateStoryProgress(storyId, progress);
      return const Right(null);
    } on ServerException catch (e) {
      try {
        await localDataSource.updateStoryProgress(storyId, progress);
        return const Right(null);
      } on CacheException {
        return Left(ServerFailure('Failed to update story progress'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> getAdaptedStoryContent(
      String storyId, String mood) async {
    try {
      final adaptedContent =
          await remoteDataSource.getAdaptedStoryContent(storyId, mood);
      return Right(adaptedContent);
    } on ServerException catch (e) {
      return Left(ServerFailure('Failed to get adapted story content'));
    }
  }
}
