import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:popup_quick_actions/models/configs_model.dart';
import 'package:popup_quick_actions/models/quick_action_option.dart';
import 'package:popup_quick_actions/popup_quick_actions.dart';

import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';

class ProjectCardQuickActions {
  static void show({
    required BuildContext context,
    required Widget triggerWidget,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    final colors = context.appColors;
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
        QuickActionOption(
          label: LocaleKeys.projects_view_details.tr(),
          icon: Icons.open_in_new_rounded,
          iconColor: AppColors.primary,
          textColor: colors.textPrimary,
          onTap: onTap,
        ),
        if (onDelete != null)
          QuickActionOption(
            label: LocaleKeys.projects_delete.tr(),
            icon: Icons.delete_rounded,
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: onDelete,
          ),
      ],
    );
  }
}
