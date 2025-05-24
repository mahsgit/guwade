// import 'dart:convert';
// import 'dart:math';
// import 'package:buddy/features/storytelling/data/datasources/story_local_data_source.dart';
// import 'package:http/http.dart' as http;
// import '../../../../core/constants/api_constants.dart';
// import '../../../../core/error/exceptions.dart';
// import '../models/story_model.dart';
// import '../models/vocabulary_model.dart';
// import '../../../auth/data/datasources/auth_local_datasource.dart';

// abstract class StorytellingRemoteDataSource {
//   Future<List<StoryModel>> getStories();
//   Future<List<VocabularyModel>> getVocabulary();
//   Future<String> detectEmotion(List<List<int>> frames);
//   Future<StoryModel> changeStory(String currentStoryId);
  
// }

// class StorytellingRemoteDataSourceImpl implements StorytellingRemoteDataSource {
//   final http.Client client;
//   final AuthLocalDataSource authLocalDataSource;
//   final StoryLocalDataSource storyLocalDataSource;
  
//   StorytellingRemoteDataSourceImpl({
//     required this.client,
//     required this.authLocalDataSource,
//     required this.storyLocalDataSource,
//   });

//   // Helper method to get auth headers
//   Future<Map<String, String>> _getAuthHeaders() async {
//     final token = await authLocalDataSource.getToken();
//     if (token == null || token.isEmpty) {
//       throw UnauthorizedException(message: 'Not authenticated. Please login.');
//     }
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   @override
//   Future<List<StoryModel>> getStories() async {
//     try {
//       final headers = await _getAuthHeaders();
      
//       final response = await client.get(
//         Uri.parse(ApiConstants.baseUrl + ApiConstants.getStories),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = json.decode(response.body);
//         final stories = jsonList.map((json) => StoryModel.fromJson(json)).toList();
//         await storyLocalDataSource.cacheStories(stories);
//         return stories;
//       } else if (response.statusCode == 401) {
//         throw UnauthorizedException(
//             message: 'Session expired. Please login again.');
//       } else {
//         throw ServerException(message: 'Failed to fetch stories.');
//       }
//     } catch (e) {
//       if (e is UnauthorizedException) rethrow;
//       throw ServerException(
//           message: 'An error occurred while fetching stories.');
//     }
//   }

//   @override
//   Future<List<VocabularyModel>> getVocabulary() async {
//     try {
//       final headers = await _getAuthHeaders();
      
//       final response = await client.get(
//         Uri.parse(ApiConstants.baseUrl + ApiConstants.getVocabulary),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = json.decode(response.body);
//         final vocabulary = jsonList.map((json) => VocabularyModel.fromJson(json)).toList();
//         await storyLocalDataSource.cacheVocabulary(vocabulary);
//         return jsonList.map((json) => VocabularyModel.fromJson(json)).toList();
//       } else if (response.statusCode == 401) {
//         throw UnauthorizedException(
//             message: 'Session expired. Please login again.');
//       } else {
//         throw ServerException(message: 'Failed to fetch vocabulary.');
//       }
//     } catch (e) {
//       if (e is UnauthorizedException) rethrow;
//       throw ServerException(
//           message: 'An error occurred while fetching vocabulary.');
//     }
//   }

//   @override
//   Future<String> detectEmotion(List<List<int>> frames) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(seconds: 1));
//       // Simulate random emotion response
//       final emotions = ['happy', 'sad', 'neutral'];
//       return emotions[Random().nextInt(emotions.length)];
//     } catch (e) {
//       throw ServerException(message: 'An error occurred while detecting emotion.');
//     }
//   }

//   @override
//   Future<StoryModel> changeStory(String currentStoryId) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(seconds: 1));
//       // Dummy stories
//       final stories = [
//         StoryModel(
//           id: '1',
//           title: 'The Happy Adventure',
//           storyBody:
//               'Once upon a time, a cheerful explorer set out on a joyful journey through a vibrant forest.',
//           imageUrl: 'https://example.com/happy.jpg',
//           category: 'Adventure',
//           viewCount: 100,
//           isFeatured: true,
//         ),
//         StoryModel(
//           id: '2',
//           title: 'The Brave Knight',
//           storyBody:
//               'A brave knight ventured into a mysterious castle to rescue a lost treasure.',
//           imageUrl: 'https://example.com/knight.jpg',
//           category: 'Fantasy',
//           viewCount: 50,
//           isFeatured: false,
//         ),
//         StoryModel(
//           id: '3',
//           title: 'The Magic Garden',
//           storyBody:
//               'In a magical garden, flowers sang and animals danced under the moonlight.',
//           imageUrl: 'https://example.com/garden.jpg',
//           category: 'Fantasy',
//           viewCount: 75,
//           isFeatured: true,
//         ),
//       ];
//       // Return a different story
//       final availableStories =
//           stories.where((story) => story.id != currentStoryId).toList();
//       if (availableStories.isEmpty) {
//         throw ServerException(message: 'No alternative stories available.');
//       }
//       return availableStories[Random().nextInt(availableStories.length)];
//     } catch (e) {
//       throw ServerException(message: 'An error occurred while changing story.');
//     }
//   }
// }


import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/story_model.dart';
import '../models/vocabulary_model.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import 'story_local_data_source.dart';

abstract class StorytellingRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<List<VocabularyModel>> getVocabulary();
  Future<String> detectEmotion(List<List<int>> frames);
  Future<StoryModel> changeStory(String currentStoryId);
}

class StorytellingRemoteDataSourceImpl implements StorytellingRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;
  final StoryLocalDataSource storyLocalDataSource;

  StorytellingRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
    required this.storyLocalDataSource,
  });

  // Helper method to get auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await authLocalDataSource.getToken();
    if (token == null || token.isEmpty) {
      throw UnauthorizedException(message: 'Not authenticated. Please login.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await client.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getStories),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final stories = jsonList.map((json) => StoryModel.fromJson(json)).toList();
        await storyLocalDataSource.cacheStories(stories);
        return stories;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            message: 'Session expired. Please login again.');
      } else {
        throw ServerException(message: 'Failed to fetch stories.');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(
          message: 'An error occurred while fetching stories.');
    }
  }

  @override
  Future<List<VocabularyModel>> getVocabulary() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await client.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getVocabulary),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final vocabulary = jsonList.map((json) => VocabularyModel.fromJson(json)).toList();
        await storyLocalDataSource.cacheVocabulary(vocabulary);
        return vocabulary;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            message: 'Session expired. Please login again.');
      } else {
        throw ServerException(message: 'Failed to fetch vocabulary.');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(
          message: 'An error occurred while fetching vocabulary.');
    }
  }

  @override
  Future<String> detectEmotion(List<List<int>> frames) async {
    try {
      final headers = await _getAuthHeaders();
      final emotion = await sendFramesToServer(frames, headers);
      return emotion;
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: 'An error occurred while detecting emotion: $e');
    }
  }

  Future<String> sendFramesToServer(List<List<int>> frames, Map<String, String> headers) async {
    final uri = Uri.parse('https://emotion-backend-sh1h.onrender.com/predict');
    var request = http.MultipartRequest('POST', uri);

    // Update headers for multipart request
    request.headers.addAll({
      'Authorization': headers['Authorization'] ?? '',
    });

    // Add each frame as 'frames' in multipart form
    for (var i = 0; i < frames.length; i++) {
      var bytes = frames[i];
      var multipartFile = http.MultipartFile.fromBytes(
        'frames',
        bytes,
        filename: 'frame_$i.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response.body; // e.g., "happy", "sad", "neutral"
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(message: 'Session expired. Please login again.');
    } else {
      throw ServerException(message: 'Failed to get prediction. Status: ${response.statusCode}');
    }
  }

  @override
  Future<StoryModel> changeStory(String currentStoryId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Dummy stories
      final stories = [
        StoryModel(
          id: '1',
          title: 'The Happy Adventure',
          storyBody:
              'Once upon a time, a cheerful explorer set out on a joyful journey through a vibrant forest. The sun shone brightly, and the birds sang sweet melodies.',
          imageUrl: 'https://example.com/happy.jpg',
          category: 'Adventure',
          viewCount: 100,
          isFeatured: true,
        ),
        StoryModel(
          id: '2',
          title: 'The Brave Knight',
          storyBody:
              'A brave knight ventured into a mysterious castle to rescue a lost treasure. With courage in his heart, he faced many challenges.',
          imageUrl: 'https://example.com/knight.jpg',
          category: 'Fantasy',
          viewCount: 50,
          isFeatured: false,
        ),
        StoryModel(
          id: '3',
          title: 'The Magic Garden',
          storyBody:
              'In a magical garden, flowers sang and animals danced under the moonlight. Every night, the garden came alive with wonder.',
          imageUrl: 'https://example.com/garden.jpg',
          category: 'Fantasy',
          viewCount: 75,
          isFeatured: true,
        ),
      ];

      // Filter out the current story and select a random one
      final availableStories = stories.where((story) => story.id != currentStoryId).toList();
      if (availableStories.isEmpty) {
        throw ServerException(message: 'No alternative stories available.');
      }

      final newStory = availableStories[Random().nextInt(availableStories.length)];
      await storyLocalDataSource.cacheStories([newStory]);
      return newStory;
    } catch (e) {
      throw ServerException(message: 'An error occurred while changing story: $e');
    }
  }
}