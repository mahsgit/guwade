// part of 'storytelling_bloc.dart';

// abstract class StorytellingEvent extends Equatable {
//   const StorytellingEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadStories extends StorytellingEvent {}

// class LoadVocabulary extends StorytellingEvent {}


// class DetectEmotion extends StorytellingEvent {
//   final List<List<int>> frames;
//   final String storyId;

//   const DetectEmotion({required this.frames, required this.storyId});

  
// }

// class ChangeStory extends StorytellingEvent {
//   final String storyId;

//   const ChangeStory({required this.storyId});
// }


part of 'storytelling_bloc.dart';

abstract class StorytellingEvent extends Equatable {
  const StorytellingEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends StorytellingEvent {}

class LoadVocabulary extends StorytellingEvent {}

class DetectEmotion extends StorytellingEvent {
  final String emotion;
  final String storyId;
  final List<List<int>> frames;

  const DetectEmotion({
    required this.emotion,
    required this.storyId,
    required this.frames,
  });

  @override
  List<Object> get props => [emotion, storyId, frames];
}

class ChangeStory extends StorytellingEvent {
  final String storyId;

  const ChangeStory({required this.storyId});

  @override
  List<Object> get props => [storyId];
}