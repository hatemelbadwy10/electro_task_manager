import '../../modules/common/features/projects/data/models/project_model.dart';
import '../../modules/common/features/tasks/data/models/task_model.dart';

class ProjectStatusResolver {
  static ProjectModel fromTasks(ProjectModel project, List<TaskModel> tasks) {
    final total = tasks.length;
    final done = tasks.where((task) => task.status == 'done').length;
    final inProgress = tasks
        .where((task) => task.status == 'inProgress')
        .length;
    final pending = tasks.where((task) => task.status == 'pending').length;

    final nextStatus = total == 0
        ? project.status
        : done == total
        ? 'done'
        : (done > 0 || inProgress > 0)
        ? 'inProgress'
        : 'pending';

    return project.copyWith(
      status: nextStatus,
      summary: project.summary.copyWith(
        total: total,
        done: done,
        pending: pending,
        inProgress: inProgress,
      ),
    );
  }
}
