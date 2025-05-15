import 'package:bloc/bloc.dart';
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

  StorytellingBloc({
    required this.getStoriesUseCase,
    required this.getVocabularyUseCase,
  }) : super(StorytellingInitial()) {
    on<LoadStories>(_onLoadStories);
    on<LoadVocabulary>(_onLoadVocabulary);
  }

  Future<void> _onLoadStories(
    LoadStories event,
    Emitter<StorytellingState> emit,
  ) async {
    emit(StoriesLoading());

    final result = await getStoriesUseCase(const NoParams());

    result.fold(
      (failure) => emit(StoriesError(failure.message)),
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
      (failure) => emit(VocabularyError(failure.message)),
      (vocabulary) => emit(VocabularyLoaded(vocabulary)),
    );
  }
}
