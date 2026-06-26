import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/error/app_exception.dart';
import '../../data/models/project_model.dart';
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

  Future<void> deleteProject(String projectId) async {
    final previousProjects = state.projects;
    emit(
      state.copyWith(
        status: ProjectsStatus.submitting,
        projects: previousProjects
            .where((project) => project.id != projectId)
            .toList(),
      ),
    );
    try {
      await repository.deleteProject(projectId);
      emit(state.copyWith(status: ProjectsStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProjectsStatus.failure,
          projects: previousProjects,
          message: error is AppException
              ? error.message
              : 'Could not delete project',
        ),
      );
    }
  }

  void updateProjectLocally(ProjectModel updatedProject) {
    final updatedProjects = state.projects.map((project) {
      return project.id == updatedProject.id ? updatedProject : project;
    }).toList();

    emit(
      state.copyWith(status: ProjectsStatus.success, projects: updatedProjects),
    );
  }

  Future<void> syncProject(ProjectModel project) async {
    try {
      final updatedProject = await repository.updateProject(
        projectId: project.id,
        title: project.title,
        description: project.description,
        status: project.status,
      );

      final updatedProjects = state.projects.map((item) {
        return item.id == updatedProject.id ? updatedProject : item;
      }).toList();

      emit(
        state.copyWith(
          status: ProjectsStatus.success,
          projects: updatedProjects,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProjectsStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not sync project',
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
