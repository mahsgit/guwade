import 'package:buddy/features/quiz/data/models/question_model.dart';

abstract class QuizRemoteDataSource {
  /// Calls the API endpoint to get questions
  /// Throws a ServerException for all error codes
  Future<List<QuestionModel>> getQuestions();

  /// Calls the API endpoint to check if an answer is correct
  /// Throws a ServerException for all error codes
  Future<bool> checkAnswer(String questionId, String optionId);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  @override
  Future<List<QuestionModel>> getQuestions() async {
    // TODO: Implement actual API call when backend is ready
    // For now, return mock data
    await Future.delayed(
        const Duration(milliseconds: 800)); // Simulate network delay
    return _getMockQuestions();
  }

  @override
  Future<bool> checkAnswer(String questionId, String optionId) async {
    // TODO: Implement actual API call when backend is ready
    // For now, check against mock data
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay

    final questions = _getMockQuestions();
    final question = questions.firstWhere((q) => q.id == questionId);
    return question.correctOptionId == optionId;
  }

  List<QuestionModel> _getMockQuestions() {
    return [
      const QuestionModel(
        id: '1',
        questionText: 'What does the picture mean?',
        imagePath: 'assets/images/nose.png',
        options: [
          OptionModel(id: '1', text: 'Sampean', color: '#3498db'),
          OptionModel(id: '2', text: 'Soca', color: '#3498db'),
          OptionModel(id: '3', text: 'Cepil', color: '#e74c3c'),
          OptionModel(id: '4', text: 'Pangambung', color: '#3498db'),
        ],
        correctOptionId: '4',
      ),
      const QuestionModel(
        id: '2',
        questionText: 'What animal is this?',
        imagePath: 'assets/images/cat.png',
        options: [
          OptionModel(id: '1', text: 'Dog', color: '#3498db'),
          OptionModel(id: '2', text: 'Cat', color: '#3498db'),
          OptionModel(id: '3', text: 'Bird', color: '#3498db'),
          OptionModel(id: '4', text: 'Fish', color: '#3498db'),
        ],
        correctOptionId: '2',
      ),
      const QuestionModel(
        id: '3',
        questionText: 'What color is this?',
        imagePath: 'assets/images/red.png',
        options: [
          OptionModel(id: '1', text: 'Blue', color: '#3498db'),
          OptionModel(id: '2', text: 'Green', color: '#3498db'),
          OptionModel(id: '3', text: 'Red', color: '#3498db'),
          OptionModel(id: '4', text: 'Yellow', color: '#3498db'),
        ],
        correctOptionId: '3',
      ),
      const QuestionModel(
        id: '4',
        questionText: 'What shape is this?',
        imagePath: 'assets/images/circle.png',
        options: [
          OptionModel(id: '1', text: 'Square', color: '#3498db'),
          OptionModel(id: '2', text: 'Triangle', color: '#3498db'),
          OptionModel(id: '3', text: 'Circle', color: '#3498db'),
          OptionModel(id: '4', text: 'Star', color: '#3498db'),
        ],
        correctOptionId: '3',
      ),
      const QuestionModel(
        id: '5',
        questionText: 'What fruit is this?',
        imagePath: 'assets/images/apple.png',
        options: [
          OptionModel(id: '1', text: 'Apple', color: '#3498db'),
          OptionModel(id: '2', text: 'Banana', color: '#3498db'),
          OptionModel(id: '3', text: 'Orange', color: '#3498db'),
          OptionModel(id: '4', text: 'Grapes', color: '#3498db'),
        ],
        correctOptionId: '1',
      ),
    ];
  }
}
