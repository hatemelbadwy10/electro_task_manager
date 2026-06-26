import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_empty_view.dart';
import '../../../../../../../core/widgets/custom_error_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../projects/data/models/project_model.dart';
import '../../controller/tasks_cubit.dart';
import '../../controller/tasks_state.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  final ProjectModel? project;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: project?.title ?? 'Project Details'),
      body: CustomPage(
        child: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            if (state.status == TasksStatus.failure && state.message != null) {
              Toaster.error(state.message!);
            }
          },
          builder: (context, state) {
            if (state.status == TasksStatus.loading ||
                state.status == TasksStatus.initial) {
              return const CustomLoading(message: 'Loading tasks...');
            }

            if (state.status == TasksStatus.failure && state.tasks.isEmpty) {
              return CustomErrorView(
                message: state.message ?? 'Could not load tasks',
                onRetry: context.read<TasksCubit>().loadTasks,
              );
            }

            return RefreshIndicator.adaptive(
              onRefresh: context.read<TasksCubit>().refreshTasks,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                children: [
                  if (project != null) ...[
                    CustomSurface(
                      child: Text(
                        project!.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (state.tasks.isEmpty)
                    const SizedBox(
                      height: 420,
                      child: CustomEmptyView(
                        title: 'No tasks yet',
                        subtitle:
                            'Add a first task to start moving this project.',
                        icon: Icons.task_alt_rounded,
                      ),
                    )
                  else
                    ...state.tasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskCard(task: task),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Task'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => BlocProvider.value(
              value: context.read<TasksCubit>(),
              child: const AddTaskBottomSheet(),
            ),
          );
        },
      ),
    );
  }
}
