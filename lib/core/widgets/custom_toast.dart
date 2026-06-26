import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

enum ToastType { error, success, warning, info }

class CustomToast extends StatelessWidget {
  final ToastType type;
  final String text;
  final VoidCallback? onDismiss;

  const CustomToast({
    super.key,
    required this.type,
    required this.text,
    this.onDismiss,
  });

  Color get _color {
    return switch (type) {
      ToastType.error => AppColors.error,
      ToastType.success => AppColors.success,
      ToastType.warning => AppColors.warning,
      ToastType.info => AppColors.primary,
    };
  }

  IconData get _icon {
    return switch (type) {
      ToastType.error => Icons.error_outline_rounded,
      ToastType.success => Icons.check_circle_outline_rounded,
      ToastType.warning => Icons.warning_amber_rounded,
      ToastType.info => Icons.info_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _color.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 12),
              color: _color.withValues(alpha: 0.14),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: ShapeDecoration(
                color: _color,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Icon(_icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (onDismiss != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
      ),
    );
  }
}
