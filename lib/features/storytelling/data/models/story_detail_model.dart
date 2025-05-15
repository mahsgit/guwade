import '../../domain/entities/story_detail.dart';
import 'story_model.dart';
import 'story_page_model.dart';
import 'story_quiz_model.dart';

class StoryDetailModel extends StoryDetail {
  const StoryDetailModel({
    required StoryModel super.story,
    required super.pages,
    required super.quizzes,
    required super.audioUrl,
    required super.readTimeMinutes,
    required super.keywords,
    required super.adaptedContent,
  });

  factory StoryDetailModel.fromJson(Map<String, dynamic> json) {
    return StoryDetailModel(
      story: StoryModel.fromJson(json['story']),
      pages: (json['pages'] as List)
          .map((page) => StoryPageModel.fromJson(page))
          .toList(),
      quizzes: (json['quizzes'] as List)
          .map((quiz) => StoryQuizModel.fromJson(quiz))
          .toList(),
      audioUrl: json['audio_url'],
      readTimeMinutes: json['read_time_minutes'],
      keywords: List<String>.from(json['keywords']),
      adaptedContent: Map<String, String>.from(json['adapted_content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story': (story as StoryModel).toJson(),
      'pages': pages.map((page) => (page as StoryPageModel).toJson()).toList(),
      'quizzes':
          quizzes.map((quiz) => (quiz as StoryQuizModel).toJson()).toList(),
      'audio_url': audioUrl,
      'read_time_minutes': readTimeMinutes,
      'keywords': keywords,
      'adapted_content': adaptedContent,
    };
  }

  // Create a dummy story detail for development
  factory StoryDetailModel.dummy(StoryModel story) {
    return StoryDetailModel(
      story: story,
      pages: const [],
      quizzes: const [],
      audioUrl: '',
      readTimeMinutes: 5,
      keywords: const [],
      adaptedContent: const {},
    );
  }
}
