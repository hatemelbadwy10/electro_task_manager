import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class CustomStatusChip extends StatelessWidget {
  final String status;

  const CustomStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'done' => const Color(0xFF139B83),
      'inProgress' => AppColors.primary,
      _ => AppColors.warning,
    };

    return _PillChip(
      label: switch (status) {
        'done' => 'COMPLETED',
        'inProgress' => 'ACTIVE',
        _ => 'PENDING',
      },
      color: color,
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final Color color;

  const _PillChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
