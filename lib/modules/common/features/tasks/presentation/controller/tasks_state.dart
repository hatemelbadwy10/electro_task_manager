import 'package:equatable/equatable.dart';

import '../../data/models/task_model.dart';

enum TasksStatus { initial, loading, success, failure, submitting }

class TasksState extends Equatable {
  final TasksStatus status;
  final List<TaskModel> tasks;
  final String? message;

  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.message,
  });

  TasksState copyWith({
    TasksStatus? status,
    List<TaskModel>? tasks,
    String? message,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, tasks, message];
}
