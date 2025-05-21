import 'package:buddy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:buddy/features/auth/domain/usecases/logout_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_profile_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/storytelling/data/datasources/storytelling_remote_datasource.dart';
import '../../features/storytelling/data/repositories/storytelling_repository_impl.dart';
import '../../features/storytelling/domain/repositories/storytelling_repository.dart';
import '../../features/storytelling/domain/usecases/get_stories_usecase.dart';
import '../../features/storytelling/domain/usecases/get_vocabulary_usecase.dart';
import '../../features/storytelling/presentation/bloc/storytelling_bloc.dart';
import 'package:camera/camera.dart';
import '../../features/storytelling/presentation/bloc/story_bloc.dart';
import '../../features/storytelling/domain/usecases/get_story_details_usecase.dart';
import '../../features/storytelling/domain/usecases/detect_emotion.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Register FlutterSecureStorage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // Auth Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(), // Add secureStorage
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      localDataSource: sl(), // Add localDataSource
    ),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      localDataSource: sl(),
    ),
  );

  // Auth Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      getProfileUseCase: sl(),
      logoutUseCase: sl(),
      // Removed authRepository parameter
    ),
  );

  // Storytelling Data sources
  sl.registerLazySingleton<StorytellingRemoteDataSource>(
    () => StorytellingRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Storytelling Repository
  sl.registerLazySingleton<StorytellingRepository>(
    () => StorytellingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      authRepository: sl(), // Keep authRepository as you've added it
    ),
  );

  // Storytelling Use cases
  sl.registerLazySingleton(() => GetStoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetVocabularyUseCase(sl()));
  sl.registerLazySingleton(() => GetStoryDetailsUseCase(sl()));
  sl.registerLazySingleton(() => DetectEmotionUseCase(sl()));

  // Storytelling Blocs
  sl.registerFactory(
    () => StorytellingBloc(
      getStoriesUseCase: sl(),
      getVocabularyUseCase: sl(),
    ),
  );

  sl.registerFactory(() => StoryBloc(
        getStoriesUseCase: sl(),
        getStoryDetailsUseCase: sl(),
        detectEmotionUseCase: sl(),
      ));

  // Camera
  final cameras = await availableCameras();
  sl.registerLazySingleton<List<CameraDescription>>(() => cameras);
}