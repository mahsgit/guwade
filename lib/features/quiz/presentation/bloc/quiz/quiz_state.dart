import 'package:buddy/features/quiz/domain/entities/question.dart';
import 'package:equatable/equatable.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int correctAnswers;
  final String? selectedOptionId;
  final DateTime startTime;

  const QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.correctAnswers,
    this.selectedOptionId,
    required this.startTime,
  });

  Question? get currentQuestion => 
      questions.isNotEmpty && currentQuestionIndex < questions.length 
          ? questions[currentQuestionIndex] 
          : null;

  QuizLoaded copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? correctAnswers,
    String? selectedOptionId,
    DateTime? startTime,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      selectedOptionId: selectedOptionId,
      startTime: startTime ?? this.startTime,
    );
  }

  @override
  List<Object?> get props => [
    questions, 
    currentQuestionIndex, 
    correctAnswers, 
    selectedOptionId,
    startTime,
  ];
}

class QuizAnswering extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int correctAnswers;
  final String selectedOptionId;
  final DateTime startTime;

  const QuizAnswering({
    required this.questions,
    required this.currentQuestionIndex,
    required this.correctAnswers,
    required this.selectedOptionId,
    required this.startTime,
  });

  Question get currentQuestion => questions[currentQuestionIndex];

  @override
  List<Object?> get props => [
    questions, 
    currentQuestionIndex, 
    correctAnswers, 
    selectedOptionId,
    startTime,
  ];
}

class QuizAnswerResult extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int correctAnswers;
  final String selectedOptionId;
  final bool isCorrect;
  final DateTime startTime;

  const QuizAnswerResult({
    required this.questions,
    required this.currentQuestionIndex,
    required this.correctAnswers,
    required this.selectedOptionId,
    required this.isCorrect,
    required this.startTime,
  });

  Question get currentQuestion => questions[currentQuestionIndex];

  @override
  List<Object?> get props => [
    questions, 
    currentQuestionIndex, 
    correctAnswers, 
    selectedOptionId,
    isCorrect,
    startTime,
  ];
}

class QuizCompleted extends QuizState {
  final List<Question> questions;
  final int correctAnswers;
  final Duration timeSpent;

  const QuizCompleted({
    required this.questions,
    required this.correctAnswers,
    required this.timeSpent, required int totalQuestions, required Null Function() onContinue,
  });

  int get totalQuestions => questions.length;
  int get accuracyPercentage => 
      totalQuestions > 0 ? (correctAnswers * 100 ~/ totalQuestions) : 0;
  int get diamonds => correctAnswers * 3;
  int get xp => correctAnswers * 5;

  @override
  List<Object?> get props => [questions, correctAnswers, timeSpent];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}
