part of 'storytelling_bloc.dart';

abstract class StorytellingState extends Equatable {
  const StorytellingState();

  @override
  List<Object?> get props => [];
}

class StorytellingInitial extends StorytellingState {}

// Stories States
class StoriesLoading extends StorytellingState {}

class StoriesLoaded extends StorytellingState {
  final List<Story> stories;

  const StoriesLoaded(this.stories);

  @override
  List<Object> get props => [stories];
}

class StoriesError extends StorytellingState {
  final String message;

  const StoriesError(this.message);

  @override
  List<Object> get props => [message];
}

// Vocabulary States
class VocabularyLoading extends StorytellingState {}

class VocabularyLoaded extends StorytellingState {
  final List<Vocabulary> vocabulary;

  const VocabularyLoaded(this.vocabulary);

  @override
  List<Object> get props => [vocabulary];
}

class VocabularyError extends StorytellingState {
  final String message;

  const VocabularyError(this.message);

  @override
  List<Object> get props => [message];
}
