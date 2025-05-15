import 'package:equatable/equatable.dart';
import 'learning_preference.dart';

class ChildProgress extends Equatable {
  final String childId;
  final String childName;
  final int age;
  final Map<String, double> storyProgress; // storyId -> progress percentage
  final Map<String, double> courseProgress; // courseId -> progress percentage
  final Map<String, int> quizScores; // quizId -> score
  final int totalDiamondsEarned;
  final int totalXpEarned;
  final int streakDays;
  final List<LearningPreference> learningPreferences;
  final DateTime lastActive;

  const ChildProgress({
    required this.childId,
    required this.childName,
    required this.age,
    required this.storyProgress,
    required this.courseProgress,
    required this.quizScores,
    required this.totalDiamondsEarned,
    required this.totalXpEarned,
    required this.streakDays,
    required this.learningPreferences,
    required this.lastActive,
  });

  @override
  List<Object?> get props => [
    childId,
    childName,
    age,
    storyProgress,
    courseProgress,
    quizScores,
    totalDiamondsEarned,
    totalXpEarned,
    streakDays,
    learningPreferences,
    lastActive,
  ];
}
