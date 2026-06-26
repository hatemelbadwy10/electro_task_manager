import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/resources.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  final ApiClient apiClient;

  TasksRemoteDataSource(this.apiClient);

  Future<List<TaskModel>> fetchTasks(String projectId) async {
    final response = await apiClient.get(ApiEndpoints.projectTasks(projectId));
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> addTask({
    required String projectId,
    required String title,
    required String priority,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.projectTasks(projectId),
      data: {'title': title, 'priority': priority},
    );
    final data = (response.data as Map<String, dynamic>)['data'];
    return TaskModel.fromJson(data as Map<String, dynamic>);
  }

  Future<TaskModel> markDone(String taskId) async {
    final response = await apiClient.patch(ApiEndpoints.markTaskDone(taskId));
    final data = (response.data as Map<String, dynamic>)['data'];
    return TaskModel.fromJson(data as Map<String, dynamic>);
  }

  Future<TaskModel> updateTask({
    required String taskId,
    String? title,
    String? status,
    String? priority,
  }) async {
    final payload = <String, dynamic>{};
    if (title != null) payload['title'] = title;
    if (status != null) payload['status'] = status;
    if (priority != null) payload['priority'] = priority;

    final response = await apiClient.patch(
      ApiEndpoints.task(taskId),
      data: payload,
    );
    final data = (response.data as Map<String, dynamic>)['data'];
    return TaskModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteTask(String taskId) async {
    await apiClient.delete(ApiEndpoints.task(taskId));
  }
}
