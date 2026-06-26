import 'package:equatable/equatable.dart';

import '../../data/models/project_model.dart';

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
  final String? message;

  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.message,
  });

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<ProjectModel>? projects,
    String? message,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, projects, message];
}
