import 'dart:convert';
import 'package:buddy/features/science/data/models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class QuizLocalDataSource {
  Future<List<QuestionModel>> getCachedQuestions(String topic);
  Future<void> cacheQuestions(String topic, List<QuestionModel> questions);
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  final SharedPreferences sharedPreferences;

  QuizLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<QuestionModel>> getCachedQuestions(String topic) async {
    final jsonString = sharedPreferences.getString('CACHED_QUESTIONS_$topic');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => QuestionModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheQuestions(String topic, List<QuestionModel> questions) async {
    final List<Map<String, dynamic>> jsonList = questions.map((question) => question.toJson()).toList();
    await sharedPreferences.setString('CACHED_QUESTIONS_$topic', json.encode(jsonList));
  }
}
