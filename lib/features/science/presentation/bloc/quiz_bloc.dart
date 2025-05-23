import 'package:buddy/features/science/domain/entities/achievement.dart';
import 'package:buddy/features/science/domain/entities/answer_result.dart';
import 'package:buddy/features/science/domain/entities/question.dart';
import 'package:buddy/features/science/domain/usecases/get_questions.dart';
import 'package:buddy/features/science/domain/usecases/submit_answer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buddy/core/error/failures.dart';

// Events
abstract class QuizEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadQuestions extends QuizEvent {
  final String topic;
  final int limit;

  LoadQuestions({required this.topic, this.limit = 10});

  @override
  List<Object?> get props => [topic, limit];
}

class SubmitQuizAnswer extends QuizEvent {
  final String questionId;
  final int selectedIndex;

  SubmitQuizAnswer({required this.questionId, required this.selectedIndex});

  @override
  List<Object?> get props => [questionId, selectedIndex];
}

class NextQuestion extends QuizEvent {}

class ResetQuiz extends QuizEvent {}

// States
abstract class QuizState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizQuestionsLoaded extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final AnswerResult? lastAnswerResult;
  final List<Achievement> achievements;

  QuizQuestionsLoaded({
    required this.questions,
    this.currentQuestionIndex = 0,
    this.lastAnswerResult,
    this.achievements = const [],
  });

  QuizQuestionsLoaded copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    AnswerResult? lastAnswerResult,
    List<Achievement>? achievements,
  }) {
    return QuizQuestionsLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      lastAnswerResult: lastAnswerResult,
      achievements: achievements ?? this.achievements,
    );
  }

  @override
  List<Object?> get props => [questions, currentQuestionIndex, lastAnswerResult, achievements];
}

class QuizError extends QuizState {
  final String message;
  final bool isAuthError;

  QuizError({required this.message, this.isAuthError = false});

  @override
  List<Object?> get props => [message, isAuthError];
}

// Bloc
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuestions getQuestions;
  final SubmitAnswer submitAnswer;

  QuizBloc({
    required this.getQuestions,
    required this.submitAnswer,
  }) : super(QuizInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SubmitQuizAnswer>(_onSubmitAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<ResetQuiz>(_onResetQuiz);
  }

  Future<void> _onLoadQuestions(LoadQuestions event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    
    final result = await getQuestions(event.topic, event.limit);
    
    result.fold(
      (failure) {
        final isAuthError = failure is AuthFailure;
        emit(QuizError(
          message: _mapFailureToMessage(failure),
          isAuthError: isAuthError,
        ));
      },
      (questions) {
        if (questions.isNotEmpty) {
          emit(QuizQuestionsLoaded(questions: questions));
        } else {
          emit(QuizError(message: 'No questions available for ${event.topic}'));
        }
      },
    );
  }

  Future<void> _onSubmitAnswer(SubmitQuizAnswer event, Emitter<QuizState> emit) async {
    if (state is QuizQuestionsLoaded) {
      final currentState = state as QuizQuestionsLoaded;
      
      final result = await submitAnswer(event.questionId, event.selectedIndex);
      
      result.fold(
        (failure) {
          final isAuthError = failure is AuthFailure;
          emit(QuizError(
            message: _mapFailureToMessage(failure),
            isAuthError: isAuthError,
          ));
        },
        (answerResult) {
          // If we have achievements, add them to the state
          final updatedAchievements = answerResult.newAchievements.isNotEmpty
              ? [...currentState.achievements, ...answerResult.newAchievements]
              : currentState.achievements;
          
          emit(currentState.copyWith(
            lastAnswerResult: answerResult,
            achievements: updatedAchievements,
          ));
        },
      );
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizQuestionsLoaded) {
      final currentState = state as QuizQuestionsLoaded;
      final nextIndex = currentState.currentQuestionIndex + 1;
      
      if (nextIndex < currentState.questions.length) {
        emit(currentState.copyWith(
          currentQuestionIndex: nextIndex,
          lastAnswerResult: null,
        ));
      } else {
        // Load more questions for the same topic
        final currentTopic = currentState.questions.first.topic;
        add(LoadQuestions(topic: currentTopic));
      }
    }
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    emit(QuizInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case AuthFailure:
        return failure.message;
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return failure.message;
      case CacheFailure:
        return failure.message;
      default:
        return 'An unexpected error occurred';
    }
  }
}
