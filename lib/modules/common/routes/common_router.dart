import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/router/app_route.dart';
import '../../../core/config/router/route_manager.dart';
import '../../../core/config/service_locator/injection.dart';
import '../features/auth/presentation/controller/auth_cubit.dart';
import '../features/auth/presentation/view/screens/login_screen.dart';
import '../features/auth/presentation/view/screens/register_screen.dart';
import '../features/profile/presentation/controller/profile_cubit.dart';
import '../features/profile/presentation/view/screens/profile_settings_screen.dart';
import '../features/projects/presentation/controller/projects_cubit.dart';
import '../features/projects/presentation/view/screens/projects_home_screen.dart';
import '../features/splash/presentation/view/screens/splash_screen.dart';
import '../features/tasks/presentation/args/project_details_args.dart';
import '../features/tasks/presentation/controller/tasks_cubit.dart';
import '../features/tasks/presentation/view/screens/project_details_screen.dart';

class CommonRouter extends BaseRouter {
  @override
  void registerRoutes() {
    BaseRouter.routes.addAll([
      GoRoute(
        name: AppRoutes.splash.name,
        path: AppRoutes.splash.path,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>()..checkSession(),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.login.name,
        path: AppRoutes.login.path,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.register.name,
        path: AppRoutes.register.path,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.projects.name,
        path: AppRoutes.projects.path,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ProjectsCubit>()..loadProjects(),
          child: const ProjectsHomeScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.projectDetails.name,
        path: AppRoutes.projectDetails.path,
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final args = state.extra as ProjectDetailsArgs?;

          return BlocProvider(
            create: (_) => sl<TasksCubit>(param1: projectId)..loadTasks(),
            child: ProjectDetailsScreen(
              projectId: projectId,
              project: args?.project,
              onProjectSaved: args?.onProjectSaved,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.profile.name,
        path: AppRoutes.profile.path,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ProfileCubit>()..loadProfile()),
            BlocProvider(create: (_) => sl<AuthCubit>()),
          ],
          child: const ProfileSettingsScreen(),
        ),
      ),
    ]);
  }
}