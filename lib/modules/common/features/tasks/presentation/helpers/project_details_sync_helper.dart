import '../../../projects/data/models/project_model.dart';
import '../../data/models/task_model.dart';
import '../../../../../../../core/utils/project_status_resolver.dart';

class ProjectDetailsSyncHelper {
  static ProjectModel? resolve({
    required ProjectModel? currentProject,
    required List<TaskModel> tasks,
  }) {
    final project = currentProject;
    if (project == null) return null;

    final nextProject = ProjectStatusResolver.fromTasks(project, tasks);
    final hasChanged =
        project.status != nextProject.status ||
        project.summary.total != nextProject.summary.total ||
        project.summary.done != nextProject.summary.done ||
        project.summary.pending != nextProject.summary.pending ||
        project.summary.inProgress != nextProject.summary.inProgress;

    return hasChanged ? nextProject : null;
  }
}
