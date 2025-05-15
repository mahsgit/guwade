import 'package:equatable/equatable.dart';

class StoryQuiz extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String learningObjective;

  const StoryQuiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.learningObjective,
  });

  @override
  List<Object?> get props => [
    id,
    question,
    options,
    correctOptionIndex,
    explanation,
    learningObjective,
  ];
}
