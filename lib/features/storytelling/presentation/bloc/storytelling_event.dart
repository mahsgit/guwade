part of 'storytelling_bloc.dart';

abstract class StorytellingEvent extends Equatable {
  const StorytellingEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends StorytellingEvent {}

class LoadVocabulary extends StorytellingEvent {}


class DetectEmotion extends StorytellingEvent {
  final List<List<int>> frames;
  final String storyId;

  const DetectEmotion({required this.frames, required this.storyId});

  
}

class ChangeStory extends StorytellingEvent {
  final String storyId;

  const ChangeStory({required this.storyId});
}