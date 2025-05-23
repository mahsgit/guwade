import 'package:buddy/features/science/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required String questionId,
    required String chunkId,
    required String question,
    required List<String> options,
    required int correctOptionIndex,
    required String difficultyLevel,
    required String ageRange,
    required String topic,
    required DateTime createdAt,
    required String childId,
    required bool solved,
    int? selectedAnswer,
    required bool scored,
    DateTime? answeredAt,
    required int attempts,
  }) : super(
          questionId: questionId,
          chunkId: chunkId,
          question: question,
          options: options,
          correctOptionIndex: correctOptionIndex,
          difficultyLevel: difficultyLevel,
          ageRange: ageRange,
          topic: topic,
          createdAt: createdAt,
          childId: childId,
          solved: solved,
          selectedAnswer: selectedAnswer,
          scored: scored,
          answeredAt: answeredAt,
          attempts: attempts,
        );

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
