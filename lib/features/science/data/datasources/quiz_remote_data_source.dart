import 'dart:convert';
import 'package:buddy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:buddy/core/constants/api_constants.dart';
import 'package:buddy/core/error/exceptions.dart';
import 'package:buddy/features/science/data/models/answer_result_model.dart';
import 'package:buddy/features/science/data/models/question_model.dart';
import 'package:http/http.dart' as http;

abstract class QuizRemoteDataSource {
  Future<List<QuestionModel>> getQuestions(String topic, int limit);
  Future<AnswerResultModel> submitAnswer(String questionId, int selectedIndex);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  QuizRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
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
  Future<List<QuestionModel>> getQuestions(String topic, int limit) async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/science/questions?topic=$topic&limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => QuestionModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            message: 'Session expired. Please login again.');
      } else {
        throw ServerException(message: 'Failed to load questions.');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(
          message: 'An error occurred while fetching questions.');
    }
  }

  @override
  Future<AnswerResultModel> submitAnswer(String questionId, int selectedIndex) async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/science/answer'),
        headers: headers,
        body: json.encode({
          'question_id': questionId,
          'selected_index': selectedIndex,
        }),
      );

      if (response.statusCode == 200) {
        return AnswerResultModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            message: 'Session expired. Please login again.');
      } else {
        throw ServerException(message: 'Failed to submit answer.');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(
          message: 'An error occurred while submitting answer.');
    }
  }
}
