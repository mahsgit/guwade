import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String questionText;
  final String imagePath;
  final List<Option> options;
  final String correctOptionId;

  const Question({
    required this.id,
    required this.questionText,
    required this.imagePath,
    required this.options,
    required this.correctOptionId,
  });

  @override
  List<Object?> get props => [id, questionText, imagePath, options, correctOptionId];
}

class Option extends Equatable {
  final String id;
  final String text;
  final String? color;

  const Option({
    required this.id,
    required this.text,
    this.color,
  });

  @override
  List<Object?> get props => [id, text, color];
}
