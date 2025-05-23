import 'package:buddy/features/science/domain/entities/achievement.dart';
import 'package:buddy/features/science/domain/entities/question.dart';

class AnswerResult {
  final bool isCorrect;
  final Question question;
  final List<Achievement> newAchievements;

  AnswerResult({
    required this.isCorrect,
    required this.question,
    required this.newAchievements,
  });
}
