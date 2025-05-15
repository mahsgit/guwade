import 'package:buddy/features/quiz/presentation/bloc/missions/missions_bloc.dart';
import 'package:buddy/features/quiz/presentation/bloc/missions/missions_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/quiz/quiz_bloc.dart';
import 'package:buddy/features/quiz/presentation/bloc/quiz/quiz_event.dart';
import 'package:buddy/features/quiz/presentation/bloc/quiz/quiz_state.dart' as quiz_state;
import 'package:buddy/features/quiz/presentation/pages/missions_page.dart';
import 'package:buddy/features/quiz/presentation/widgets/answer_feedback.dart';
import 'package:buddy/features/quiz/presentation/widgets/progress_bar.dart';
import 'package:buddy/features/quiz/presentation/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    // Load questions when screen initializes
    context.read<QuizBloc>().add(LoadQuizEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: BlocBuilder<QuizBloc, quiz_state.QuizState>(
          builder: (context, state) {
            if (state is quiz_state.QuizLoaded || 
                state is quiz_state.QuizAnswering || 
                state is quiz_state.QuizAnswerResult) {
              final questions = state is quiz_state.QuizLoaded 
                  ? state.questions 
                  : state is quiz_state.QuizAnswering 
                      ? state.questions 
                      : (state as quiz_state.QuizAnswerResult).questions;
              
              final currentIndex = state is quiz_state.QuizLoaded 
                  ? state.currentQuestionIndex + 1 
                  : state is quiz_state.QuizAnswering 
                      ? state.currentQuestionIndex + 1 
                      : (state as quiz_state.QuizAnswerResult).currentQuestionIndex + 1;
              
              return ProgressBar(
                currentStep: currentIndex,
                totalSteps: questions.length,
              );
            }
            return const SizedBox();
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<QuizBloc, quiz_state.QuizState>(
        listener: (context, state) {
          if (state is quiz_state.QuizCompleted) {
            // Update missions when quiz is completed
            context.read<MissionsBloc>()
              ..add(AddDiamondsEvent(amount: state.diamonds))
              ..add(AddXpEvent(amount: state.xp));
          }
        },
        builder: (context, state) {
          if (state is quiz_state.QuizLoading || state is quiz_state.QuizInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is quiz_state.QuizError) {
            return Center(
              child: Text(state.message),
            );
          }
          
          if (state is quiz_state.QuizCompleted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quiz Completed!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('Correct Answers: ${state.correctAnswers}'),
                  Text('Total Questions: ${state.totalQuestions}'),
                  Text('Time Spent: ${state.timeSpent} seconds'),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to missions page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MissionsPage(),
                        ),
                      );
                    },
                    child: const Text('Continue'),
                  ),
                ],
              ),
            );
          }
          
          if (state is quiz_state.QuizAnswerResult) {
            return AnswerFeedback(
              isCorrect: state.isCorrect,
              correctAnswer: state.currentQuestion.options
                  .firstWhere((o) => o.id == state.currentQuestion.correctOptionId)
                  .text,
              onNext: () {
                context.read<QuizBloc>().add(NextQuestionEvent());
              },
            );
          }
          
          if (state is quiz_state.QuizLoaded) {
            final question = state.currentQuestion;
            if (question == null) {
              return const Center(
                child: Text('No questions available'),
              );
            }
            
            return QuestionCard(
              question: question,
              onOptionSelected: (optionId) {
                context.read<QuizBloc>().add(AnswerQuestionEvent(
                  questionId: question.id,
                  optionId: optionId,
                ));
              },
              selectedOptionId: state.selectedOptionId,
              isAnswering: false,
            );
          }
          
          if (state is quiz_state.QuizAnswering) {
            return QuestionCard(
              question: state.currentQuestion,
              onOptionSelected: (_) {}, // Disabled during answering
              selectedOptionId: state.selectedOptionId,
              isAnswering: true,
            );
          }
          
          return const Center(
            child: Text('Unexpected state'),
          );
        },
      ),
    );
  }
}
