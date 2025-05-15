import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Storytelling feature
import '../../features/storytelling/data/datasources/story_local_data_source.dart';
import '../../features/storytelling/data/datasources/story_remote_data_source.dart';
import '../../features/storytelling/data/repositories/story_repository_impl.dart';
import '../../features/storytelling/domain/repositories/story_repository.dart';
import '../../features/storytelling/domain/usecases/get_stories_usecase.dart';
import '../../features/storytelling/domain/usecases/get_story_details_usecase.dart';
import '../../features/storytelling/domain/usecases/detect_emotion.dart';
import '../../features/storytelling/presentation/bloc/story_bloc.dart';

// Quiz feature
import '../../features/quiz/data/datasources/quiz_remote_data_source.dart';
import '../../features/quiz/data/repositories/quiz_repository_impl.dart';
import '../../features/quiz/data/repositories/streak_repository_impl.dart';
import '../../features/quiz/data/repositories/rewards_repository_impl.dart';
import '../../features/quiz/domain/repositories/quiz_repository.dart';
import '../../features/quiz/domain/repositories/streak_repository.dart';
import '../../features/quiz/domain/repositories/rewards_repository.dart';
import '../../features/quiz/domain/usecases/get_questions_usecase.dart';
import '../../features/quiz/domain/usecases/check_answer_usecase.dart';
import '../../features/quiz/domain/usecases/get_streak_usecase.dart';
import '../../features/quiz/domain/usecases/update_streak_usecase.dart';
import '../../features/quiz/domain/usecases/get_missions_usecase.dart';
import '../../features/quiz/domain/usecases/update_mission_usecase.dart';
import '../../features/quiz/presentation/bloc/quiz/quiz_bloc.dart';
import '../../features/quiz/presentation/bloc/streak/streak_bloc.dart';
import '../../features/quiz/presentation/bloc/missions/missions_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core and External dependencies - register these FIRST
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Register HTTP client
  sl.registerLazySingleton<http.Client>(() => http.Client());
  
  // Camera
  final cameras = await availableCameras();
  sl.registerLazySingleton(() => cameras);

  // Features - Storytelling
  // Bloc
  sl.registerFactory(
    () => StoryBloc(
      getStoriesUseCase: sl(),
      getStoryDetailsUseCase: sl(),
      detectEmotionUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetStoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetStoryDetailsUseCase(sl()));
  sl.registerLazySingleton(() => DetectEmotionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<StoryLocalDataSource>(
    () => StoryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Features - Quiz
  // Bloc
  sl.registerFactory(() => QuizBloc(
        getQuestionsUseCase: sl(),
        checkAnswerUseCase: sl(),
      ));
  sl.registerFactory(() => StreakBloc(
        getStreakUseCase: sl(),
        updateStreakUseCase: sl(),
      ));
  sl.registerFactory(() => MissionsBloc(
        getMissionsUseCase: sl(),
        updateMissionUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetQuestionsUseCase(sl()));
  sl.registerLazySingleton(() => CheckAnswerUseCase(sl()));
  sl.registerLazySingleton(() => GetStreakUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStreakUseCase(sl()));
  sl.registerLazySingleton(() => GetMissionsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMissionUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(remoteDataSource: sl()) as QuizRepository,
  );
  sl.registerLazySingleton<StreakRepository>(
    () => StreakRepositoryImpl() as StreakRepository,
  );
  sl.registerLazySingleton<RewardsRepository>(
    () => RewardsRepositoryImpl() as RewardsRepository,
  );

  // Data sources
  sl.registerLazySingleton<QuizRemoteDataSource>(
      () => QuizRemoteDataSourceImpl());
}
