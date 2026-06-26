import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/resources.dart';
import '../models/project_model.dart';

class ProjectsRemoteDataSource {
  final ApiClient apiClient;

  ProjectsRemoteDataSource(this.apiClient);

  Future<List<ProjectModel>> fetchProjects() async {
    final response = await apiClient.get(ApiEndpoints.projects);
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((item) => ProjectModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ProjectModel> fetchProject(String projectId) async {
    final response = await apiClient.get(ApiEndpoints.project(projectId));
    final data = (response.data as Map<String, dynamic>)['data'];
    return ProjectModel.fromJson(data as Map<String, dynamic>);
  }

  Future<ProjectModel> createProject({
    required String title,
    required String description,
    String status = 'pending',
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.projects,
      data: {'title': title, 'description': description, 'status': status},
    );
    final data = (response.data as Map<String, dynamic>)['data'];
    return ProjectModel.fromJson(data as Map<String, dynamic>);
  }

  Future<ProjectModel> updateProject({
    required String projectId,
    String? title,
    String? description,
    String? status,
  }) async {
    final payload = <String, dynamic>{};
    if (title != null) payload['title'] = title;
    if (description != null) payload['description'] = description;
    if (status != null) payload['status'] = status;

    final response = await apiClient.patch(
      ApiEndpoints.project(projectId),
      data: payload,
    );
    final data = (response.data as Map<String, dynamic>)['data'];
    return ProjectModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteProject(String projectId) async {
    await apiClient.delete(ApiEndpoints.project(projectId));
  }
}
