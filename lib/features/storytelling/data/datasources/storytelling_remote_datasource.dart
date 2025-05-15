import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/story_model.dart';
import '../models/vocabulary_model.dart';

abstract class StorytellingRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<List<VocabularyModel>> getVocabulary();
}

class StorytellingRemoteDataSourceImpl implements StorytellingRemoteDataSource {
  final http.Client client;
  String token;

  StorytellingRemoteDataSourceImpl({
    required this.client,
    required this.token,
  });

  void updateToken(String newToken) {
    token = newToken;
  }

  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getStories),
        headers: ApiConstants.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => StoryModel.fromJson(json)).toList();
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
      final response = await client.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getVocabulary),
        headers: ApiConstants.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
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
