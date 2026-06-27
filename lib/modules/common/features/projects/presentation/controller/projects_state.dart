import 'package:equatable/equatable.dart';

import '../../data/models/project_model.dart';
import 'projects_filter.dart';

enum ProjectsStatus {
  initial,
  loading,
  success,
  failure,
  refreshing,
  submitting,
}

class ProjectsState extends Equatable {
  final ProjectsStatus status;
  final List<ProjectModel> projects;
  final ProjectsFilter selectedFilter;
  final String? message;

  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.selectedFilter = ProjectsFilter.all,
    this.message,
  });

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<ProjectModel>? projects,
    ProjectsFilter? selectedFilter,
    String? message,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      message: message,
    );
  }

  List<ProjectModel> get filteredProjects =>
      projects.where(selectedFilter.matches).toList();

  int countFor(ProjectsFilter filter) => projects.where(filter.matches).length;

  @override
  List<Object?> get props => [status, projects, selectedFilter, message];
}
