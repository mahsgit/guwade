import '../../domain/entities/vocabulary.dart';

class VocabularyModel extends Vocabulary {
  const VocabularyModel({
    required super.word,
    required super.synonym,
    required super.relatedWords,
    required super.storyTitle,
    required super.createdAt,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      word: json['word'] as String,
      synonym: json['synonym'] as String,
      relatedWords: List<String>.from(json['related_words']),
      storyTitle: json['story_title'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'synonym': synonym,
        'related_words': relatedWords,
        'story_title': storyTitle,
        'created_at': createdAt.toIso8601String(),
      };
}
