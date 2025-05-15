import 'package:equatable/equatable.dart';
import 'story.dart';
import 'story_page.dart';
import 'story_quiz.dart' as quiz;


class StoryDetail extends Equatable {
  final Story story;
  final List<StoryPage> pages;
  final List<quiz.StoryQuiz> quizzes;
  final String audioUrl;
  final int readTimeMinutes;
  final List<String> keywords;
  final Map<String, String> adaptedContent; // Mood-based content variations

  const StoryDetail({
    required this.story,
    required this.pages,
    required this.quizzes,
    required this.audioUrl,
    required this.readTimeMinutes,
    required this.keywords,
    required this.adaptedContent,
  });

  @override
  List<Object?> get props => [
    story,
    pages,
    quizzes,
    audioUrl,
    readTimeMinutes,
    keywords,
    adaptedContent,
  ];
}
