import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/error/app_exception.dart';
import '../../data/repository/projects_repository.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final ProjectsRepository repository;

  ProjectsCubit(this.repository) : super(const ProjectsState());

  Future<void> loadProjects() async {
    emit(state.copyWith(status: ProjectsStatus.loading));
    await _fetch();
  }

  Future<void> refreshProjects() async {
    emit(state.copyWith(status: ProjectsStatus.refreshing));
    await _fetch();
  }

  Future<void> createProject({
    required String title,
    required String description,
    String status = 'pending',
  }) async {
    emit(state.copyWith(status: ProjectsStatus.submitting));
    try {
      final project = await repository.createProject(
        title: title,
        description: description,
        status: status,
      );
      emit(
        state.copyWith(
          status: ProjectsStatus.success,
          projects: [project, ...state.projects],
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProjectsStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not create project',
        ),
      );
    }
  }

  Future<void> _fetch() async {
    try {
      final projects = await repository.fetchProjects();
      emit(state.copyWith(status: ProjectsStatus.success, projects: projects));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProjectsStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not load projects',
        ),
      );
    }
  }
}
