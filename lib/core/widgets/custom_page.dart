import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class CustomPage extends StatelessWidget {
  final Widget child;
  final bool showAccent;

  const CustomPage({super.key, required this.child, this.showAccent = true});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF4F6FF), AppColors.background, Color(0xFFFFFFFF)],
        ),
      ),
      child: Stack(
        children: [
          if (showAccent) ...[
            Positioned(
              top: -90,
              right: -88,
              child: _BlurCircle(
                color: AppColors.primary.withValues(alpha: 0.14),
                size: 260,
              ),
            ),
            Positioned(
              top: 130,
              left: -110,
              child: _BlurCircle(
                color: AppColors.lavenderDeep.withValues(alpha: 0.7),
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
