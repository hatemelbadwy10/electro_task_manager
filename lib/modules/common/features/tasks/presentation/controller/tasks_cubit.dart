import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/error/app_exception.dart';
import '../../data/repository/tasks_repository.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository repository;
  final String projectId;

  TasksCubit({required this.repository, required this.projectId})
    : super(const TasksState());

  Future<void> loadTasks() async {
    emit(state.copyWith(status: TasksStatus.loading));
    await _fetch();
  }

  Future<void> refreshTasks() => _fetch();

  Future<void> addTask({
    required String title,
    required String priority,
  }) async {
    emit(state.copyWith(status: TasksStatus.submitting));
    try {
      await repository.addTask(
        projectId: projectId,
        title: title,
        priority: priority,
      );
      await _fetch();
    } catch (error) {
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          message: error is AppException ? error.message : 'Could not add task',
        ),
      );
    }
  }

  Future<void> markDone(String taskId) async {
    try {
      await repository.markDone(taskId);
      await _fetch();
    } catch (error) {
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not update task',
        ),
      );
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await repository.deleteTask(taskId);
      await _fetch();
    } catch (error) {
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not delete task',
        ),
      );
    }
  }

  Future<void> _fetch() async {
    try {
      final tasks = await repository.fetchTasks(projectId);
      emit(state.copyWith(status: TasksStatus.success, tasks: tasks));
    } catch (error) {
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not load tasks',
        ),
      );
    }
  }
}
