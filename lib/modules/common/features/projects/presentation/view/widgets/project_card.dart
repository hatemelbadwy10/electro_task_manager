import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/widgets/custom_status_chip.dart';
import '../../../data/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                            color: const Color(0xFF1D214A),
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
                    color: const Color(0xFF7D82AA),
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
                      'View Details',
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
            .onTap(onTap, borderRadius: 30.borderRadius)
            .setContainerToView(
              radius: 30,
              color: AppColors.lavender.withValues(alpha: 0.58),
              borderColor: Colors.white.withValues(alpha: 0.5),
              shadows: [
                BoxShadow(
                  blurRadius: 18,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                  color: AppColors.primary.withValues(alpha: 0.22),
                ),
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  color: Colors.white.withValues(alpha: 0.7),
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
          '$value Tasks',
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
