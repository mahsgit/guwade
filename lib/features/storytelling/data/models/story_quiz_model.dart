import '../../domain/entities/story_quiz.dart';

class StoryQuizModel extends StoryQuiz {
  const StoryQuizModel({
    required super.id,
    required super.question,
    required super.options,
    required super.correctOptionIndex,
    required super.explanation,
    required super.learningObjective,
  });

  factory StoryQuizModel.fromJson(Map<String, dynamic> json) {
    return StoryQuizModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correct_option_index'],
      explanation: json['explanation'],
      learningObjective: json['learning_objective'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_option_index': correctOptionIndex,
      'explanation': explanation,
      'learning_objective': learningObjective,
    };
  }
}
