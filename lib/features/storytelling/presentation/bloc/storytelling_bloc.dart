import 'package:bloc/bloc.dart';
import 'package:buddy/features/storytelling/domain/usecases/emotion.dart';
import 'package:buddy/features/storytelling/domain/usecases/story_change.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/usecases/get_stories_usecase.dart';
import '../../domain/usecases/get_vocabulary_usecase.dart';

part 'storytelling_event.dart';
part 'storytelling_state.dart';

class StorytellingBloc extends Bloc<StorytellingEvent, StorytellingState> {
  final GetStoriesUseCase getStoriesUseCase;
  final GetVocabularyUseCase getVocabularyUseCase;
  final DetectEmotionusecase detectEmotion;
  final ChangeStoryusecase changeStory;

  StorytellingBloc({
    required this.getStoriesUseCase,
    required this.getVocabularyUseCase,
    required this.detectEmotion,
    required this.changeStory,
  }) : super(StorytellingInitial()) {
    on<LoadStories>(_onLoadStories);
    on<LoadVocabulary>(_onLoadVocabulary);
    on<DetectEmotion>(_onDetectEmotion);
    on<ChangeStory>(_onChangeStory);
  }

  Future<void> _onLoadStories(
    LoadStories event,
    Emitter<StorytellingState> emit,
  ) async {
    emit(StoriesLoading());

    final result = await getStoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        // Emit StoriesLoaded with empty list as fallback instead of StoriesError
        emit(StoriesLoaded([]));
      },
      (stories) => emit(StoriesLoaded(stories)),
    );
  }

  Future<void> _onLoadVocabulary(
    LoadVocabulary event,
    Emitter<StorytellingState> emit,
  ) async {
    emit(VocabularyLoading());

    final result = await getVocabularyUseCase(const NoParams());

    result.fold(
      (failure) => emit(VocabularyLoaded([])), // Fallback to empty vocabulary
      (vocabulary) => emit(VocabularyLoaded(vocabulary)),
    );
  }

  Future<void> _onDetectEmotion(
    DetectEmotion event,
    Emitter<StorytellingState> emit,
  ) async {
    emit(EmotionLoading());
    final result = await detectEmotion(event.frames);
    result.fold(
      (failure) => emit(EmotionError(failure.message)),
      (emotion) => emit(EmotionDetected(emotion: emotion, storyId: event.storyId)),
    );
  }

  Future<void> _onChangeStory(
    ChangeStory event,
    Emitter<StorytellingState> emit,
  ) async {
    emit(StoryChangeLoading());
    final result = await changeStory(event.storyId);
    result.fold(
      (failure) => emit(StoryChangeError(failure.message)),
      (story) => emit(StoryUpdated(story: story)),
    );
  }
}
