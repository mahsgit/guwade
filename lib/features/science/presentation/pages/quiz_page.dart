import 'package:buddy/features/science/domain/entities/achievement.dart';
import 'package:buddy/features/science/presentation/bloc/quiz_bloc.dart';
import 'package:buddy/features/science/presentation/widgets/achievement_popup.dart';
import 'package:buddy/features/science/presentation/widgets/answer_feedback.dart';
import 'package:buddy/features/science/presentation/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizPage extends StatefulWidget {
  final String topic;

  const QuizPage({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(LoadQuestions(topic: widget.topic));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: Text(
          'Quiz',
          style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizQuestionsLoaded && state.lastAnswerResult != null) {
            // Check if we have new achievements to display
            if (state.lastAnswerResult!.newAchievements.isNotEmpty) {
              _showAchievementPopup(context, state.lastAnswerResult!.newAchievements);
            }
          }
        },
        builder: (context, state) {
          if (state is QuizLoading) {
            return _buildLoadingState();
          } else if (state is QuizQuestionsLoaded) {
            return _buildQuizContent(context, state);
          } else if (state is QuizError) {
            return _buildErrorState(state.message);
          } else {
            return _buildLoadingState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading questions...",
            style: TextStyle(
              color: Colors.amber[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Error: $message",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<QuizBloc>().add(LoadQuestions(topic: widget.topic));
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuizQuestionsLoaded state) {
    if (state.questions.isEmpty) {
      return Center(
        child: Text(
          "No questions available for ${widget.topic}",
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    final currentQuestion = state.questions[state.currentQuestionIndex];
    final totalQuestions = state.questions.length;
    final hasAnswered = state.lastAnswerResult != null;

    return SafeArea(
      child: Column(
        children: [
          // Question counter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Question ${state.currentQuestionIndex + 1}/$totalQuestions",
                    style: TextStyle(
                      color: Colors.brown[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Question card
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    QuestionCard(
                      question: currentQuestion,
                      onAnswerSelected: hasAnswered
                          ? null
                          : (index) {
                              context.read<QuizBloc>().add(
                                    SubmitQuizAnswer(
                                      questionId: currentQuestion.questionId,
                                      selectedIndex: index,
                                    ),
                                  );
                            },
                      selectedAnswerIndex: state.lastAnswerResult?.question.selectedAnswer,
                      correctAnswerIndex: hasAnswered ? currentQuestion.correctOptionIndex : null,
                    ),
                    
                    // Answer feedback
                    if (hasAnswered)
                      AnswerFeedback(
                        isCorrect: state.lastAnswerResult!.isCorrect,
                        correctAnswer: currentQuestion.options[currentQuestion.correctOptionIndex],
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Next button
          if (hasAnswered)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(NextQuestion());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.brown[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next Question",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAchievementPopup(BuildContext context, List<Achievement> achievements) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AchievementPopup(achievements: achievements),
      );
    });
  }
}
