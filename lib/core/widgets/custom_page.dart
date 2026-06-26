import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/app_colors_extension.dart';

class CustomPage extends StatelessWidget {
  final Widget child;
  final bool showAccent;

  const CustomPage({super.key, required this.child, this.showAccent = true});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors.pageGradientColors,
        ),
      ),
      child: Stack(
        children: [
          if (showAccent) ...[
            Positioned(
              top: -90,
              right: -88,
              child: _BlurCircle(
                color: AppColors.primary.withValues(
                  alpha: colors.accentCircleAlpha,
                ),
                size: 260,
              ),
            ),
            Positioned(
              top: 130,
              left: -110,
              child: _BlurCircle(
                color: colors.accentCircleColor,
                size: 220,
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
