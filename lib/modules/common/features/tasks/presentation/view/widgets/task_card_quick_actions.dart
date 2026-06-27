import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_quick_actions/models/configs_model.dart';
import 'package:popup_quick_actions/models/quick_action_option.dart';
import 'package:popup_quick_actions/popup_quick_actions.dart';

import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import '../../../data/models/task_model.dart';
import '../../controller/tasks_cubit.dart';

class TaskCardQuickActions {
  static void show({
    required BuildContext context,
    required Widget triggerWidget,
    required TaskModel task,
  }) {
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
        backdropColor: Colors.black.withValues(
          alpha: colors.popupBackdropAlpha,
        ),
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
