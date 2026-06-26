import '../datasource/tasks_remote_datasource.dart';
import '../models/task_model.dart';

class TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepository(this.remoteDataSource);

  Future<List<TaskModel>> fetchTasks(String projectId) {
    return remoteDataSource.fetchTasks(projectId);
  }

  Future<TaskModel> addTask({
    required String projectId,
    required String title,
    required String priority,
  }) {
    return remoteDataSource.addTask(
      projectId: projectId,
      title: title,
      priority: priority,
    );
  }

  Future<TaskModel> markDone(String taskId) =>
      remoteDataSource.markDone(taskId);

  Future<void> deleteTask(String taskId) => remoteDataSource.deleteTask(taskId);
}
