// import 'package:camera/camera.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import '../../../../core/usecases/usecase.dart';
// import '../../domain/entities/story.dart';
// import '../../domain/entities/story_detail.dart';
// import '../../domain/usecases/get_stories_usecase.dart';


// // Events
// abstract class StoryEvent extends Equatable {
//   const StoryEvent();

//   @override
//   List<Object> get props => [];
// }

// class GetStoriesEvent extends StoryEvent {}

// class GetStoryDetailsEvent extends StoryEvent {
//   final String storyId;

//   const GetStoryDetailsEvent(this.storyId);

//   @override
//   List<Object> get props => [storyId];
// }

// class UpdateMoodEvent extends StoryEvent {
//   final String mood;

//   const UpdateMoodEvent(this.mood);

//   @override
//   List<Object> get props => [mood];
// }

// class DetectEmotionEvent extends StoryEvent {
//   final List<XFile> images;

//   const DetectEmotionEvent(this.images);

//   @override
//   List<Object> get props => [images];
// }

// class GetNextStoryEvent extends StoryEvent {
//   final String currentStoryId;

//   const GetNextStoryEvent(this.currentStoryId);

//   @override
//   List<Object> get props => [currentStoryId];
// }

// // States
// abstract class StoryState extends Equatable {
//   const StoryState();

//   @override
//   List<Object?> get props => [];
// }

// class StoryInitial extends StoryState {}

// class StoriesLoading extends StoryState {}

// class StoriesLoaded extends StoryState {
//   final List<Story> stories;

//   const StoriesLoaded(this.stories);

//   @override
//   List<Object> get props => [stories];
// }

// class StoryDetailsLoading extends StoryState {}

// class StoryDetailsLoaded extends StoryState {
//   final StoryDetail storyDetail;
//   final String currentMood;
//   final bool isInterested;

//   const StoryDetailsLoaded(
//     this.storyDetail, {
//     this.currentMood = 'neutral',
//     this.isInterested = true,
//   });

//   @override
//   List<Object> get props => [storyDetail, currentMood, isInterested];

//   StoryDetailsLoaded copyWith({
//     StoryDetail? storyDetail,
//     String? currentMood,
//     bool? isInterested,
//   }) {
//     return StoryDetailsLoaded(
//       storyDetail ?? this.storyDetail,
//       currentMood: currentMood ?? this.currentMood,
//       isInterested: isInterested ?? this.isInterested,
//     );
//   }
// }

// class EmotionDetecting extends StoryState {}

// class EmotionDetected extends StoryState {
//   final bool isInterested;
//   final String emotion;

//   const EmotionDetected({
//     required this.isInterested,
//     required this.emotion,
//   });

//   @override
//   List<Object> get props => [isInterested, emotion];
// }

// class NextStoryLoaded extends StoryState {
//   final StoryDetail storyDetail;

//   const NextStoryLoaded(this.storyDetail);

//   @override
//   List<Object> get props => [storyDetail];
// }

// class StoryError extends StoryState {
//   final String message;

//   const StoryError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// // BLoC
// class StoryBloc extends Bloc<StoryEvent, StoryState> {
//   final GetStoriesUseCase getStoriesUseCase;

//   StoryBloc({
//     required this.getStoriesUseCase,
//   }) : super(StoryInitial()) {
//     on<GetStoriesEvent>(_onGetStories);
   
//   }

//   Future<void> _onGetStories(
//     GetStoriesEvent event,
//     Emitter<StoryState> emit,
//   ) async {
//     emit(StoriesLoading());
//     final result = await getStoriesUseCase(NoParams());
//     result.fold(
//       (failure) => emit(StoryError(failure.message)),
//       (stories) => emit(StoriesLoaded(stories)),
//     );
//   }

 

  

// }
