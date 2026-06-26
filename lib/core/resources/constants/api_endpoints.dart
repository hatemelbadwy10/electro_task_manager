class ApiEndpoints {
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String me = '/api/me';
  static const String projects = '/api/projects';

  static String project(String projectId) => '/api/projects/$projectId';

  static String projectTasks(String projectId) =>
      '/api/projects/$projectId/tasks';

  static String task(String taskId) => '/api/tasks/$taskId';

  static String markTaskDone(String taskId) => '/api/tasks/$taskId/done';
}
