import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final int totalQuestions;
  final int correctAnswers;
  final int diamonds;
  final int xp;
  final Duration timeSpent;
  final int accuracyPercentage;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.diamonds,
    required this.xp,
    required this.timeSpent,
    required this.accuracyPercentage,
  });

  @override
  List<Object?> get props => [
        totalQuestions,
        correctAnswers,
        diamonds,
        xp,
        timeSpent,
        accuracyPercentage,
      ];
}
