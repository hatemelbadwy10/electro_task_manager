import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
import '../../../../../../../core/widgets/custom_priority_chip.dart';
import '../../../../../../../core/widgets/custom_status_chip.dart';
import '../../../data/models/task_model.dart';
import 'task_card_quick_actions.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final visual = _TaskCardVisual(task: task);
    return Builder(
      builder: (cardContext) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => TaskCardQuickActions.show(
            context: cardContext,
            triggerWidget: visual,
            task: task,
          ),
          onLongPress: () => TaskCardQuickActions.show(
            context: cardContext,
            triggerWidget: visual,
            task: task,
          ),
          child: visual,
        );
      },
    );
  }
}

class _TaskCardVisual extends StatelessWidget {
  final TaskModel task;

  const _TaskCardVisual({required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'done';
    final colors = context.appColors;
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppColors.success.withValues(alpha: 0.14)
                        : AppColors.primary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: isDone ? AppColors.success : AppColors.primary,
                    ),
                  ),
                  child: Icon(
                    isDone
                        ? Icons.check_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: isDone ? AppColors.success : AppColors.primary,
                  ),
                ),
                12.gap,
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? colors.textMuted : colors.textPrimary,
                  ),
                ).expand(),
                Icon(
                  Icons.bolt_rounded,
                  color: AppColors.primary.withValues(alpha: 0.72),
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
          color: colors.cardSurface,
          borderColor: colors.cardBorder,
          shadows: [
            BoxShadow(
              blurRadius: 30,
              offset: const Offset(0, 14),
              color: AppColors.secondary.withValues(
                alpha: colors.cardShadowAlpha,
              ),
            ),
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(
                alpha: colors.secondaryCardShadowAlpha,
              ),
            ),
          ],
        );
  }
}
