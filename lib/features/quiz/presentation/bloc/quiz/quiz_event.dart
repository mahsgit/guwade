import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizEvent extends QuizEvent {}

class AnswerQuestionEvent extends QuizEvent {
  final String questionId;
  final String optionId;

  const AnswerQuestionEvent({
    required this.questionId,
    required this.optionId,
  });

  @override
  List<Object?> get props => [questionId, optionId];
}

class NextQuestionEvent extends QuizEvent {}

class ResetQuizEvent extends QuizEvent {}
