import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../modules/common/features/auth/data/datasource/auth_remote_datasource.dart';
import '../../../modules/common/features/auth/data/repository/auth_repository.dart';
import '../../../modules/common/features/auth/presentation/controller/auth_cubit.dart';
import '../../../modules/common/features/profile/presentation/controller/profile_cubit.dart';
import '../../../modules/common/features/projects/data/datasource/projects_remote_datasource.dart';
import '../../../modules/common/features/projects/data/repository/projects_repository.dart';
import '../../../modules/common/features/projects/presentation/controller/projects_cubit.dart';
import '../../../modules/common/features/tasks/data/datasource/tasks_remote_datasource.dart';
import '../../../modules/common/features/tasks/data/repository/tasks_repository.dart';
import '../../../modules/common/features/tasks/presentation/controller/tasks_cubit.dart';
import '../../data/client/api_client.dart';
import '../../data/storage/token_storage.dart';
import '../theme/theme_controller.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<ThemeController>(
    () => ThemeController(sl<FlutterSecureStorage>()),
  );
  await sl<ThemeController>().loadTheme();
  sl.registerLazySingleton<Dio>(Dio.new);
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl<Dio>(), tokenStorage: sl<TokenStorage>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));

  sl.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepository(sl<ProjectsRemoteDataSource>()),
  );
  sl.registerFactory<ProjectsCubit>(
    () => ProjectsCubit(sl<ProjectsRepository>()),
  );

  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepository(sl<TasksRemoteDataSource>()),
  );
  sl.registerFactoryParam<TasksCubit, String, void>(
    (projectId, _) =>
        TasksCubit(repository: sl<TasksRepository>(), projectId: projectId),
  );

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<AuthRepository>()));
}
