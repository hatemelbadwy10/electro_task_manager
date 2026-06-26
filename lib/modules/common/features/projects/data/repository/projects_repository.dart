import '../datasource/projects_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectsRepository {
  final ProjectsRemoteDataSource remoteDataSource;

  ProjectsRepository(this.remoteDataSource);

  Future<List<ProjectModel>> fetchProjects() =>
      remoteDataSource.fetchProjects();

  Future<ProjectModel> fetchProject(String projectId) {
    return remoteDataSource.fetchProject(projectId);
  }

  Future<ProjectModel> createProject({
    required String title,
    required String description,
    String status = 'pending',
  }) {
    return remoteDataSource.createProject(
      title: title,
      description: description,
      status: status,
    );
  }

  Future<ProjectModel> updateProject({
    required String projectId,
    String? title,
    String? description,
    String? status,
  }) {
    return remoteDataSource.updateProject(
      projectId: projectId,
      title: title,
      description: description,
      status: status,
    );
  }

  Future<void> deleteProject(String projectId) {
    return remoteDataSource.deleteProject(projectId);
  }
}
