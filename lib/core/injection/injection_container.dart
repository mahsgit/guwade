import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      getProfileUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // Features - Storytelling
  // Bloc
  sl.registerFactory(
    () => StorytellingBloc(
      getStoriesUseCase: sl(),
      getVocabularyUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetStoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetVocabularyUseCase(sl()));

  // Repository
  sl.registerLazySingleton<StorytellingRepository>(
    () => StorytellingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<StorytellingRemoteDataSource>(
    () => StorytellingRemoteDataSourceImpl(
      client: sl(),
      token: '', // Will be updated after successful login
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
