import 'package:buddy/features/science/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.questionId,
    required super.chunkId,
    required super.question,
    required super.options,
    required super.correctOptionIndex,
    required super.difficultyLevel,
    required super.ageRange,
    required super.topic,
    required super.createdAt,
    required super.childId,
    required super.solved,
    super.selectedAnswer,
    required super.scored,
    super.answeredAt,
    required super.attempts,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['question_id'],
      chunkId: json['chunk_id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correct_option_index'],
      difficultyLevel: json['difficulty_level'],
      ageRange: json['age_range'],
      topic: json['topic'],
      createdAt: DateTime.parse(json['created_at']),
      childId: json['child_id'],
      solved: json['solved'],
      selectedAnswer: json['selected_answer'],
      scored: json['scored'],
      answeredAt: json['answered_at'] != null
          ? DateTime.parse(json['answered_at'])
          : null,
      attempts: json['attempts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'chunk_id': chunkId,
      'question': question,
      'options': options,
      'correct_option_index': correctOptionIndex,
      'difficulty_level': difficultyLevel,
      'age_range': ageRange,
      'topic': topic,
      'created_at': createdAt.toIso8601String(),
      'child_id': childId,
      'solved': solved,
      'selected_answer': selectedAnswer,
      'scored': scored,
      'answered_at': answeredAt?.toIso8601String(),
      'attempts': attempts,
    };
  }
}
