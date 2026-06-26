import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popup_quick_actions/models/configs_model.dart';
import 'package:popup_quick_actions/models/quick_action_option.dart';
import 'package:popup_quick_actions/popup_quick_actions.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
import '../../../../../../../core/widgets/custom_status_chip.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final visual = _ProjectCardVisual(project: project);
    return Builder(
      builder: (cardContext) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          onLongPress: () => _showQuickActions(cardContext, visual),
          child: visual,
        );
      },
    );
  }

  void _showQuickActions(BuildContext context, Widget triggerWidget) {
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
        backdropColor: Colors.black.withValues(alpha: colors.popupBackdropAlpha),
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
            onTap: onDelete!,
          ),
      ],
    );
  }
}

class _ProjectCardVisual extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCardVisual({required this.project});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content =
        Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: colors.cardTitle,
                            fontWeight: FontWeight.w900,
                          ),
                    ).expand(),
                    14.gap,
                    CustomStatusChip(status: project.status),
                  ],
                ),
                14.gap,
                Text(
                  project.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textMuted,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                36.gap,
                Row(
                  children: [
                    _TaskCount(value: project.summary.total),
                    const Spacer(),
                    Text(
                      LocaleKeys.projects_view_details.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    8.gap,
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            )
            .paddingAll(26)
            .setContainerToView(
              radius: 30,
              color: colors.projectCardSurface,
              borderColor: colors.projectCardBorder,
              shadows: [
                BoxShadow(
                  blurRadius: 18,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                  color: AppColors.primary.withValues(
                    alpha: colors.projectCardShadowAlpha,
                  ),
                ),
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  color: colors.projectCardBorder.withValues(
                    alpha: colors.projectCardSecondaryShadowAlpha,
                  ),
                ),
              ],
            );
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: content,
      ),
    );
  }
}

class _TaskCount extends StatelessWidget {
  final int value;

  const _TaskCount({required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_box_outlined,
          size: 22,
          color: const Color(0xFF8F98BD).withValues(alpha: 0.9),
        ),
        10.gap,
        Text(
          LocaleKeys.projects_tasks_count.tr(args: ['$value']),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF8F98BD),
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
