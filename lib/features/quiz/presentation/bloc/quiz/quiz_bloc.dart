import 'package:buddy/features/quiz/domain/usecases/check_answer_usecase.dart';
import 'package:buddy/features/quiz/domain/usecases/get_questions_usecase.dart';
import 'package:buddy/features/quiz/presentation/bloc/quiz/quiz_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/quiz/quiz_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuestionsUseCase getQuestionsUseCase;
  final CheckAnswerUseCase checkAnswerUseCase;

  QuizBloc({
    required this.getQuestionsUseCase,
    required this.checkAnswerUseCase,
  }) : super(QuizInitial()) {
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<ResetQuizEvent>(_onResetQuiz);
  }

  Future<void> _onLoadQuiz(
    LoadQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());

    final result = await getQuestionsUseCase();

    result.fold(
      (failure) => emit(const QuizError(message: 'Failed to load questions')),
      (questions) => emit(QuizLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        correctAnswers: 0,
        startTime: DateTime.now(),
      )),
    );
  }

  Future<void> _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<QuizState> emit,
  ) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      
      emit(QuizAnswering(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex,
        correctAnswers: currentState.correctAnswers,
        selectedOptionId: event.optionId,
        startTime: currentState.startTime,
      ));

      final result = await checkAnswerUseCase(event.questionId, event.optionId);

      result.fold(
        (failure) => emit(const QuizError(message: 'Failed to check answer')),
        (isCorrect) {
          final newCorrectAnswers = isCorrect 
              ? currentState.correctAnswers + 1 
              : currentState.correctAnswers;
          
          emit(QuizAnswerResult(
            questions: currentState.questions,
            currentQuestionIndex: currentState.currentQuestionIndex,
            correctAnswers: newCorrectAnswers,
            selectedOptionId: event.optionId,
            isCorrect: isCorrect,
            startTime: currentState.startTime,
          ));
        },
      );
    }
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizAnswerResult) {
      final currentState = state as QuizAnswerResult;
      final nextIndex = currentState.currentQuestionIndex + 1;
      
      if (nextIndex < currentState.questions.length) {
        emit(QuizLoaded(
          questions: currentState.questions,
          currentQuestionIndex: nextIndex,
          correctAnswers: currentState.correctAnswers,
          startTime: currentState.startTime,
        ));
      } else {
        // Quiz completed
        final timeSpent = DateTime.now().difference(currentState.startTime);
        emit(QuizCompleted(
          questions: currentState.questions,
          correctAnswers: currentState.correctAnswers,
          timeSpent: timeSpent, totalQuestions: currentState.questions.length, onContinue: () {  },
        ));
      }
    }
  }

  void _onResetQuiz(
    ResetQuizEvent event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizCompleted) {
      final currentState = state as QuizCompleted;
      emit(QuizLoaded(
        questions: currentState.questions,
        currentQuestionIndex: 0,
        correctAnswers: 0,
        startTime: DateTime.now(),
      ));
    }
  }
}
