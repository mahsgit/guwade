
import 'package:buddy/features/science/data/models/achievement_model.dart';
import 'package:buddy/features/science/data/models/question_model.dart';
import 'package:buddy/features/science/domain/entities/answer_result.dart';

class AnswerResultModel extends AnswerResult {
  AnswerResultModel({
    required super.isCorrect,
    required QuestionModel super.question,
    required List<AchievementModel> super.newAchievements,
  });

  factory AnswerResultModel.fromJson(Map<String, dynamic> json) {
    return AnswerResultModel(
      isCorrect: json['is_correct'],
      question: QuestionModel.fromJson(json['question']),
      newAchievements: json['new_achievements'] != null
          ? List<AchievementModel>.from(
              json['new_achievements'].map((x) => AchievementModel.fromJson(x)))
          : [],
    );
  }
}
