import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
import '../../../../../../../core/widgets/custom_status_chip.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/project_model.dart';
import 'project_card_quick_actions.dart';

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
          onLongPress: () => ProjectCardQuickActions.show(
            context: cardContext,
            triggerWidget: visual,
            onTap: onTap,
            onDelete: onDelete,
          ),
          child: visual,
        );
      },
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
