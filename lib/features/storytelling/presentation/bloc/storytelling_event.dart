part of 'storytelling_bloc.dart';

abstract class StorytellingEvent extends Equatable {
  const StorytellingEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends StorytellingEvent {}

class LoadVocabulary extends StorytellingEvent {}
