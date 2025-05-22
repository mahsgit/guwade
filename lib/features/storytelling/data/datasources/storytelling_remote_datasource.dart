import 'dart:convert';
import 'package:buddy/features/storytelling/data/datasources/story_local_data_source.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/story_model.dart';
import '../models/vocabulary_model.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

abstract class StorytellingRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<List<VocabularyModel>> getVocabulary();
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
        return jsonList.map((json) => VocabularyModel.fromJson(json)).toList();
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
}