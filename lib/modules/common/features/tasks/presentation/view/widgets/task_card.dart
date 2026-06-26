import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/widgets/custom_priority_chip.dart';
import '../../../../../../../core/widgets/custom_status_chip.dart';
import '../../../data/models/task_model.dart';
import '../../controller/tasks_cubit.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'done';
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.textMuted : AppColors.text,
                  ),
                ).expand(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'done') {
                      context.read<TasksCubit>().markDone(task.id);
                    }
                    if (value == 'delete') {
                      context.read<TasksCubit>().deleteTask(task.id);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'done', child: Text('Mark done')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            12.gap,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomStatusChip(status: task.status),
                CustomPriorityChip(priority: task.priority),
              ],
            ),
          ],
        )
        .paddingAll(16)
        .setContainerToView(
          radius: 18,
          color: AppColors.surface.withValues(alpha: 0.92),
          borderColor: Colors.white.withValues(alpha: 0.78),
          shadows: [
            BoxShadow(
              blurRadius: 30,
              offset: const Offset(0, 14),
              color: AppColors.secondary.withValues(alpha: 0.08),
            ),
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        );
  }
}
