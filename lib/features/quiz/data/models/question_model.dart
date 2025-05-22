import 'package:buddy/features/quiz/domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.questionText,
    required super.imagePath,
    required List<OptionModel> super.options,
    required super.correctOptionId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      questionText: json['question_text'],
      imagePath: json['image_path'],
      options: (json['options'] as List)
          .map((option) => OptionModel.fromJson(option))
          .toList(),
      correctOptionId: json['correct_option_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'image_path': imagePath,
      'options': (options as List<OptionModel>)
          .map((option) => option.toJson())
          .toList(),
      'correct_option_id': correctOptionId,
    };
  }
}

class OptionModel extends Option {
  const OptionModel({
    required super.id,
    required super.text,
    super.color,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      text: json['text'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'color': color,
    };
  }
}
