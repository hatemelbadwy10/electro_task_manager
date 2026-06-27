import 'package:electro_task_manager/modules/common/features/projects/data/models/project_model.dart';
import 'package:electro_task_manager/modules/common/features/tasks/data/models/task_model.dart';
import 'package:electro_task_manager/modules/common/features/tasks/presentation/helpers/project_details_sync_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectDetailsSyncHelper', () {
    test('returns null when project is null', () {
      final resolved = ProjectDetailsSyncHelper.resolve(
        currentProject: null,
        tasks: const [],
      );

      expect(resolved, isNull);
    });

    test('returns null when resolved project does not change', () {
      final project = _project(
        status: 'pending',
        summary: const ProjectTaskSummary(
          total: 2,
          done: 0,
          pending: 2,
          inProgress: 0,
        ),
      );
      final tasks = [
        _task(id: '1', status: 'pending'),
        _task(id: '2', status: 'pending'),
      ];

      final resolved = ProjectDetailsSyncHelper.resolve(
        currentProject: project,
        tasks: tasks,
      );

      expect(resolved, isNull);
    });

    test('returns updated project when status or summary changes', () {
      final project = _project(
        status: 'pending',
        summary: const ProjectTaskSummary(
          total: 1,
          done: 0,
          pending: 1,
          inProgress: 0,
        ),
      );
      final tasks = [
        _task(id: '1', status: 'done'),
        _task(id: '2', status: 'done'),
      ];

      final resolved = ProjectDetailsSyncHelper.resolve(
        currentProject: project,
        tasks: tasks,
      );

      expect(resolved, isNotNull);
      expect(resolved!.status, 'done');
      expect(resolved.summary.total, 2);
      expect(resolved.summary.done, 2);
    });
  });
}

ProjectModel _project({
  required String status,
  required ProjectTaskSummary summary,
}) {
  return ProjectModel(
    id: 'project_1',
    title: 'Project',
    description: 'Description',
    status: status,
    summary: summary,
  );
}

TaskModel _task({required String id, required String status}) {
  return TaskModel(
    id: id,
    projectId: 'project_1',
    title: 'Task $id',
    status: status,
    priority: 'high',
  );
}
