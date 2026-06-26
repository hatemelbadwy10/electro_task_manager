import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/app_colors_extension.dart';

class CustomSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const CustomSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: padding,
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 14),
            color: AppColors.primary.withValues(
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
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
