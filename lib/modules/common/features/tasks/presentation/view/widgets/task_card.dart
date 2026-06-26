import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_quick_actions/models/configs_model.dart';
import 'package:popup_quick_actions/models/quick_action_option.dart';
import 'package:popup_quick_actions/popup_quick_actions.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
import '../../../../../../../core/widgets/custom_priority_chip.dart';
import '../../../../../../../core/widgets/custom_status_chip.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/task_model.dart';
import '../../controller/tasks_cubit.dart';

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
          onTap: () => _showQuickActions(cardContext, visual),
          onLongPress: () => _showQuickActions(cardContext, visual),
          child: visual,
        );
      },
    );
  }

  void _showQuickActions(BuildContext context, Widget triggerWidget) {
    final colors = context.appColors;
    final tasksCubit = context.read<TasksCubit>();
    final renderBox = context.findRenderObject() as RenderBox?;
    final triggerWidth = renderBox?.size.width;
    final constrainedTrigger = triggerWidth != null
        ? SizedBox(width: triggerWidth, child: triggerWidget)
        : triggerWidget;
    showIOSQuickActions(
      context: context,
      triggerWidget: constrainedTrigger,
      config: QuickActionsConfig(
        cardWidth: 220,
        iconSize: 20,
        optionSpacing: 4,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        borderRadius: BorderRadius.circular(22),
        backgroundColor: colors.popupBackground,
        backdropColor: Colors.black.withValues(alpha: colors.popupBackdropAlpha),
        blurSigma: colors.popupBlurSigma,
        textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: colors.popupTextColor,
        ),
      ),
      options: [
        if (task.status != 'done')
          QuickActionOption(
            label: LocaleKeys.tasks_mark_done.tr(),
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.success,
            textColor: colors.textPrimary,
            onTap: () => tasksCubit.markDone(task.id),
          ),
        QuickActionOption(
          label: LocaleKeys.tasks_delete.tr(),
          icon: Icons.delete_rounded,
          iconColor: AppColors.error,
          textColor: AppColors.error,
          onTap: () => tasksCubit.deleteTask(task.id),
        ),
      ],
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
