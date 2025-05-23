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





class EmotionLoading extends StorytellingState {}

class EmotionDetected extends StorytellingState {
  final String emotion;
  final String storyId;

  const EmotionDetected({required this.emotion, required this.storyId});

  @override
  List<Object?> get props => [emotion, storyId];
}

class EmotionError extends StorytellingState {
  final String message;

  const EmotionError(this.message);

  @override
  List<Object?> get props => [message];
}

class StoryChangeLoading extends StorytellingState {}

class StoryUpdated extends StorytellingState {
  final Story story;

  const StoryUpdated({required this.story});

  @override
  List<Object?> get props => [story];
}

class StoryChangeError extends StorytellingState {
  final String message;

  const StoryChangeError(this.message);

  @override
  List<Object?> get props => [message];
}