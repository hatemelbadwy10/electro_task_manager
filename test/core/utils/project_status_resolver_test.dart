import 'package:electro_task_manager/core/utils/project_status_resolver.dart';
import 'package:electro_task_manager/modules/common/features/projects/data/models/project_model.dart';
import 'package:electro_task_manager/modules/common/features/tasks/data/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectStatusResolver', () {
    test('keeps current status when there are no tasks', () {
      final project = _project(status: 'pending');

      final resolved = ProjectStatusResolver.fromTasks(project, const []);

      expect(resolved.status, 'pending');
      expect(resolved.summary.total, 0);
    });

    test('marks project done when all tasks are done', () {
      final project = _project(status: 'pending');
      final tasks = [
        _task(id: '1', status: 'done'),
        _task(id: '2', status: 'done'),
      ];

      final resolved = ProjectStatusResolver.fromTasks(project, tasks);

      expect(resolved.status, 'done');
      expect(resolved.summary.total, 2);
      expect(resolved.summary.done, 2);
      expect(resolved.summary.pending, 0);
      expect(resolved.summary.inProgress, 0);
    });

    test('marks project in progress when at least one task is done', () {
      final project = _project(status: 'pending');
      final tasks = [
        _task(id: '1', status: 'done'),
        _task(id: '2', status: 'pending'),
      ];

      final resolved = ProjectStatusResolver.fromTasks(project, tasks);

      expect(resolved.status, 'inProgress');
      expect(resolved.summary.done, 1);
      expect(resolved.summary.pending, 1);
    });

    test('marks project in progress when task is in progress', () {
      final project = _project(status: 'pending');
      final tasks = [
        _task(id: '1', status: 'inProgress'),
        _task(id: '2', status: 'pending'),
      ];

      final resolved = ProjectStatusResolver.fromTasks(project, tasks);

      expect(resolved.status, 'inProgress');
      expect(resolved.summary.inProgress, 1);
    });

    test('keeps project pending when all tasks are pending', () {
      final project = _project(status: 'done');
      final tasks = [
        _task(id: '1', status: 'pending'),
        _task(id: '2', status: 'pending'),
      ];

      final resolved = ProjectStatusResolver.fromTasks(project, tasks);

      expect(resolved.status, 'pending');
      expect(resolved.summary.pending, 2);
    });
  });
}

ProjectModel _project({required String status}) {
  return ProjectModel(
    id: 'project_1',
    title: 'Project',
    description: 'Description',
    status: status,
    summary: const ProjectTaskSummary(
      total: 0,
      done: 0,
      pending: 0,
      inProgress: 0,
    ),
  );
}

TaskModel _task({required String id, required String status}) {
  return TaskModel(
    id: id,
    projectId: 'project_1',
    title: 'Task $id',
    status: status,
    priority: 'medium',
  );
}
