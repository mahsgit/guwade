// import 'package:http/http.dart' as http;
// import '../../../../core/error/exceptions.dart';
// import '../models/story_model.dart';
// import '../models/story_detail_model.dart';

// abstract class StoryRemoteDataSource {
//   /// Calls the API endpoint to get all stories
//   ///
//   /// Throws a [ServerException] for all error codes.
//   Future<List<StoryModel>> getStories();

//   /// Calls the API endpoint to get story details
//   ///
//   /// Throws a [ServerException] for all error codes.
//   Future<StoryDetailModel> getStoryDetails(String storyId);

//   Future<void> updateStoryProgress(String storyId, double progress);
//   Future<String> getAdaptedStoryContent(String storyId, String mood);
// }

// class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
//   final http.Client client;

//   StoryRemoteDataSourceImpl({required this.client});

//     @override
//   Future<Either<Failure, EmotionResult>> detectEmotion(List<XFile> images) async {
//     try {
//       final result = await remoteDataSource.detectEmotion(images);
//       return Right(result);
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<List<StoryModel>> getStories() async {
//     // This would be a real API call in production
//     // For now, we'll simulate a network delay and return dummy data
//     await Future.delayed(const Duration(milliseconds: 800));

//     // Simulate API response
//     return _getDummyStories();
//   }

//   @override
//   Future<StoryDetailModel> getStoryDetails(String storyId) async {
//     // This would be a real API call in production
//     // For now, we'll simulate a network delay and return dummy data
//     await Future.delayed(const Duration(milliseconds: 1000));

//     // Find the story from dummy stories
//     final story = _getDummyStories().firstWhere(
//       (s) => s.id == storyId,
//       orElse: () => _getDummyStories().first,
//     );

//     return StoryDetailModel.dummy(story);
//   }

//   @override
//   Future<void> updateStoryProgress(String storyId, double progress) async {
//     // This would be a real API call in production
//     await Future.delayed(const Duration(milliseconds: 500));
//     // In a real app, this would send the progress to the server
//     return;
//   }

//   @override
//   Future<String> getAdaptedStoryContent(String storyId, String mood) async {
//     // This would be a real API call in production
//     await Future.delayed(const Duration(milliseconds: 700));

//     // Simulate different content based on mood
//     switch (mood) {
//       case 'happy':
//         return 'Once upon a time, there was a very happy princess who loved to dance and sing all day long!';
//       case 'sad':
//         return 'Once upon a time, there was a princess who felt lonely, but she was about to discover wonderful friends who would cheer her up.';
//       case 'bored':
//         return 'Once upon a time, there was an adventurous princess who went on exciting quests full of action and surprises!';
//       default:
//         return 'Once upon a time, there was a princess who lived in a beautiful castle surrounded by a magical forest.';
//     }
//   }

//   // Dummy data for development
//   List<StoryModel> _getDummyStories() {
//     return [
//       StoryModel(
//         id: '1',
//         title: 'Fairy Tale Story',
//         description: 'Cinderella lived with a wicked step-mother and two step-sisters...',
//         imageUrl: 'https://via.placeholder.com/300',
//         category: 'Fairy Tales',
//         viewCount: 1200,
//         isFeatured: true,
//         ageRange: const ['4', '8'],
//         learningObjectives: const ['Kindness', 'Perseverance'],
//         createdAt: DateTime.now().subtract(const Duration(days: 30)),
//       ),
//       StoryModel(
//         id: '2',
//         title: 'The Brave Little Robot',
//         description: 'A story about a small robot who saves his friends...',
//         imageUrl: 'https://via.placeholder.com/300',
//         category: 'Science Fiction',
//         viewCount: 980,
//         isFeatured: false,
//         ageRange: const ['5', '8'],
//         learningObjectives: const ['Courage', 'Friendship', 'Problem Solving'],
//         createdAt: DateTime.now().subtract(const Duration(days: 15)),
//       ),
//       StoryModel(
//         id: '3',
//         title: 'The Counting Adventure',
//         description: 'Join Max as he learns to count with forest animals...',
//         imageUrl: 'https://via.placeholder.com/300',
//         category: 'Educational',
//         viewCount: 1500,
//         isFeatured: true,
//         ageRange: const ['4', '6'],
//         learningObjectives: const ['Counting', 'Animals', 'Nature'],
//         createdAt: DateTime.now().subtract(const Duration(days: 7)),
//       ),
//     ];
//   }
// }
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/story_model.dart';
import '../models/story_detail_model.dart';
import '../../domain/entities/emotion_result.dart';

abstract class StoryRemoteDataSource {
  /// Calls the API endpoint to get all stories
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<StoryModel>> getStories();

  /// Calls the API endpoint to get story details
  ///
  /// Throws a [ServerException] for all error codes.
  Future<StoryDetailModel> getStoryDetails(String storyId);

  Future<void> updateStoryProgress(String storyId, double progress);
  Future<String> getAdaptedStoryContent(String storyId, String mood);

  /// Detects emotion from a list of images
  ///
  /// Throws a [ServerException] for all error codes.
  Future<EmotionResult> detectEmotion(List<XFile> images);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final http.Client client;

  StoryRemoteDataSourceImpl({required this.client});

  @override
  Future<EmotionResult> detectEmotion(List<XFile> images) async {
    // This would be a real API call in production
    // For now, we'll simulate a network delay and return dummy data
    await Future.delayed(const Duration(seconds: 2));

    // Randomly determine if the child is interested or not
    final random = Random();
    final isInterested = random.nextBool();

    return EmotionResult(
      isInterested: isInterested,
      confidence: random.nextDouble() * 100,
      emotion: isInterested ? 'happy' : 'bored',
    );
  }

  @override
  Future<List<StoryModel>> getStories() async {
    // This would be a real API call in production
    // For now, we'll simulate a network delay and return dummy data
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate API response
    return _getDummyStories();
  }

  @override
  Future<StoryDetailModel> getStoryDetails(String storyId) async {
    // This would be a real API call in production
    // For now, we'll simulate a network delay and return dummy data
    await Future.delayed(const Duration(milliseconds: 1000));

    // Find the story from dummy stories
    final story = _getDummyStories().firstWhere(
      (s) =>
          s.title ==
          storyId, // Using title as identifier since we don't have id anymore
      orElse: () => _getDummyStories().first,
    );

    return StoryDetailModel.dummy(story);
  }

  @override
  Future<void> updateStoryProgress(String storyId, double progress) async {
    // This would be a real API call in production
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would send the progress to the server
    return;
  }

  @override
  Future<String> getAdaptedStoryContent(String storyId, String mood) async {
    // This would be a real API call in production
    await Future.delayed(const Duration(milliseconds: 700));

    // Simulate different content based on mood
    switch (mood) {
      case 'happy':
        return 'Once upon a time, there was a very happy princess who loved to dance and sing all day long!';
      case 'sad':
        return 'Once upon a time, there was a princess who felt lonely, but she was about to discover wonderful friends who would cheer her up.';
      case 'bored':
        return 'Once upon a time, there was an adventurous princess who went on exciting quests full of action and surprises!';
      default:
        return 'Once upon a time, there was a princess who lived in a beautiful castle surrounded by a magical forest.';
    }
  }

  // Dummy data for development
  List<StoryModel> _getDummyStories() {
    return [
      StoryModel(
        id: '1',
        title: 'Fairy Tale Story',
        storyBody:
            'Once upon a time, in a far-off kingdom, there lived a beautiful young woman named Cinderella...',
        imageUrl: 'assets/images/stories/fairy_tale.jpg',
      ),
      StoryModel(
        id: '2',
        title: 'The Brave Little Robot',
        storyBody:
            'Once upon a time there was a brave little robot who loved helping others...',
        imageUrl: 'assets/images/stories/robot.jpg',
      ),
      StoryModel(
        id: '3',
        title: 'The Counting Adventure',
        storyBody:
            'Once upon a time, Max went on an adventure in the forest where he met many animal friends who helped him learn to count...',
        imageUrl: 'assets/images/stories/counting.jpg',
      ),
    ];
  }
}
