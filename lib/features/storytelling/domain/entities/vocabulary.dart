import 'package:equatable/equatable.dart';

class Vocabulary extends Equatable {
  final String word;
  final String synonym;
  final List<String> relatedWords;
  final String storyTitle;
  final DateTime createdAt;

  const Vocabulary({
    required this.word,
    required this.synonym,
    required this.relatedWords,
    required this.storyTitle,
    required this.createdAt,
  });

  @override
  List<Object> get props =>
      [word, synonym, relatedWords, storyTitle, createdAt];
}
