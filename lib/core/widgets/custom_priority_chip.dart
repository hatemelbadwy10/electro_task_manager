import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class CustomPriorityChip extends StatelessWidget {
  final String priority;

  const CustomPriorityChip({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'high' => AppColors.error,
      'medium' => AppColors.warning,
      _ => AppColors.textMuted,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        priority[0].toUpperCase() + priority.substring(1),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
