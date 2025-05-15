import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_detail.dart';
import '../../domain/usecases/get_stories_usecase.dart';
import '../../domain/usecases/get_story_details_usecase.dart';
import '../../domain/usecases/detect_emotion.dart';

// Events
abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

class GetStoriesEvent extends StoryEvent {}

class GetStoryDetailsEvent extends StoryEvent {
  final String storyId;

  const GetStoryDetailsEvent(this.storyId);

  @override
  List<Object> get props => [storyId];
}

class UpdateMoodEvent extends StoryEvent {
  final String mood;

  const UpdateMoodEvent(this.mood);

  @override
  List<Object> get props => [mood];
}

class DetectEmotionEvent extends StoryEvent {
  final List<XFile> images;

  const DetectEmotionEvent(this.images);

  @override
  List<Object> get props => [images];
}

class GetNextStoryEvent extends StoryEvent {
  final String currentStoryId;

  const GetNextStoryEvent(this.currentStoryId);

  @override
  List<Object> get props => [currentStoryId];
}

// States
abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoriesLoading extends StoryState {}

class StoriesLoaded extends StoryState {
  final List<Story> stories;

  const StoriesLoaded(this.stories);

  @override
  List<Object> get props => [stories];
}

class StoryDetailsLoading extends StoryState {}

class StoryDetailsLoaded extends StoryState {
  final StoryDetail storyDetail;
  final String currentMood;
  final bool isInterested;

  const StoryDetailsLoaded(
    this.storyDetail, {
    this.currentMood = 'neutral',
    this.isInterested = true,
  });

  @override
  List<Object> get props => [storyDetail, currentMood, isInterested];

  StoryDetailsLoaded copyWith({
    StoryDetail? storyDetail,
    String? currentMood,
    bool? isInterested,
  }) {
    return StoryDetailsLoaded(
      storyDetail ?? this.storyDetail,
      currentMood: currentMood ?? this.currentMood,
      isInterested: isInterested ?? this.isInterested,
    );
  }
}

class EmotionDetecting extends StoryState {}

class EmotionDetected extends StoryState {
  final bool isInterested;
  final String emotion;

  const EmotionDetected({
    required this.isInterested,
    required this.emotion,
  });

  @override
  List<Object> get props => [isInterested, emotion];
}

class NextStoryLoaded extends StoryState {
  final StoryDetail storyDetail;

  const NextStoryLoaded(this.storyDetail);

  @override
  List<Object> get props => [storyDetail];
}

class StoryError extends StoryState {
  final String message;

  const StoryError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final GetStoriesUseCase getStoriesUseCase;
  final GetStoryDetailsUseCase getStoryDetailsUseCase;
  final DetectEmotionUseCase detectEmotionUseCase;

  StoryBloc({
    required this.getStoriesUseCase,
    required this.getStoryDetailsUseCase,
    required this.detectEmotionUseCase,
  }) : super(StoryInitial()) {
    on<GetStoriesEvent>(_onGetStories);
    on<GetStoryDetailsEvent>(_onGetStoryDetails);
    on<UpdateMoodEvent>(_onUpdateMood);
    on<DetectEmotionEvent>(_onDetectEmotion);
    on<GetNextStoryEvent>(_onGetNextStory);
  }

  Future<void> _onGetStories(
    GetStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoriesLoading());
    final result = await getStoriesUseCase(NoParams());
    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (stories) => emit(StoriesLoaded(stories)),
    );
  }

  Future<void> _onGetStoryDetails(
    GetStoryDetailsEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryDetailsLoading());
    final result = await getStoryDetailsUseCase(event.storyId);
    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (storyDetail) => emit(StoryDetailsLoaded(storyDetail)),
    );
  }

  Future<void> _onUpdateMood(
    UpdateMoodEvent event,
    Emitter<StoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is StoryDetailsLoaded) {
      emit(currentState.copyWith(currentMood: event.mood));
    }
  }

  Future<void> _onDetectEmotion(
    DetectEmotionEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(EmotionDetecting());

    final result = await detectEmotionUseCase(event.images);

    result.fold(
      (failure) => emit(StoryError(failure.message)),
      (emotionResult) {
        emit(EmotionDetected(
          isInterested: emotionResult.isInterested,
          emotion: emotionResult.emotion,
        ));

        // Update the story detail state with the emotion result
        final currentState = state;
        if (currentState is StoryDetailsLoaded) {
          emit(currentState.copyWith(
            isInterested: emotionResult.isInterested,
            currentMood: emotionResult.emotion,
          ));
        }
      },
    );
  }

  Future<void> _onGetNextStory(
    GetNextStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryDetailsLoading());

    try {
      // First, get all available stories
      final storiesResult = await getStoriesUseCase(NoParams());

      await storiesResult.fold(
        (failure) {
          emit(StoryError(failure.message));
        },
        (stories) async {
          if (stories.isEmpty) {
            emit(const StoryError("No stories available"));
            return;
          }

          // Find the current story index
          final currentIndex =
              stories.indexWhere((story) => story.id == event.currentStoryId);

          // Get the next story (or the first one if we're at the end)
          final nextIndex = (currentIndex + 1) % stories.length;
          // print("Current Index: $currentIndex, Next Index: $nextIndex");
          final nextStoryId = stories[nextIndex].id;
          // print("Next Story ID: $nextStoryId");

          // Get the details of the next story
          final nextStoryResult = await getStoryDetailsUseCase(nextStoryId);

          nextStoryResult.fold(
            (failure) => emit(StoryError(failure.message)),
            (storyDetail) {
              // Emit a specific NextStoryLoaded state to trigger navigation
              emit(NextStoryLoaded(storyDetail));

              // Then update the story details state
              emit(StoryDetailsLoaded(
                storyDetail,
                // Reset mood to neutral for the new story
                currentMood: 'neutral',
                isInterested: true,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(StoryError(e.toString()));
    }
  }
}
