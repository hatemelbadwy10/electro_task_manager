import 'package:electro_task_manager/modules/common/features/projects/data/models/project_model.dart';
import 'package:electro_task_manager/modules/common/features/projects/presentation/controller/projects_filter.dart';
import 'package:electro_task_manager/modules/common/features/projects/presentation/controller/projects_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectsState filtering', () {
    final projects = [
      _project(id: '1', status: 'pending'),
      _project(id: '2', status: 'inProgress'),
      _project(id: '3', status: 'done'),
      _project(id: '4', status: 'inProgress'),
    ];

    test('returns all projects for all filter', () {
      final state = ProjectsState(
        projects: projects,
        selectedFilter: ProjectsFilter.all,
      );

      expect(state.filteredProjects.map((project) => project.id), [
        '1',
        '2',
        '3',
        '4',
      ]);
      expect(state.countFor(ProjectsFilter.all), 4);
    });

    test('returns only active projects for active filter', () {
      final state = ProjectsState(
        projects: projects,
        selectedFilter: ProjectsFilter.active,
      );

      expect(state.filteredProjects.map((project) => project.id), ['2', '4']);
      expect(state.countFor(ProjectsFilter.active), 2);
    });

    test('returns only pending projects for pending filter', () {
      final state = ProjectsState(
        projects: projects,
        selectedFilter: ProjectsFilter.pending,
      );

      expect(state.filteredProjects.map((project) => project.id), ['1']);
      expect(state.countFor(ProjectsFilter.pending), 1);
    });

    test('returns only completed projects for done filter', () {
      final state = ProjectsState(
        projects: projects,
        selectedFilter: ProjectsFilter.done,
      );

      expect(state.filteredProjects.map((project) => project.id), ['3']);
      expect(state.countFor(ProjectsFilter.done), 1);
    });
  });
}

ProjectModel _project({required String id, required String status}) {
  return ProjectModel(
    id: id,
    title: 'Project $id',
    description: 'Description $id',
    status: status,
    summary: const ProjectTaskSummary(
      total: 0,
      done: 0,
      pending: 0,
      inProgress: 0,
    ),
  );
}
