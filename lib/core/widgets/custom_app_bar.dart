import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/extensions/all_extensions.dart';
import '../config/router/route_manager.dart';
import '../config/theme/app_colors_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final colors = context.appColors;
    context.locale;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.appBarBorder),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.appBarBackground.withValues(
                      alpha: colors.appBarInnerGlowAlpha,
                    ),
                    colors.appBarBackground,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: colors.appBarShadowAlpha,
                    ),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    if (showBack && canPop) ...[
                      6.gap,
                      CustomGlassIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onBack ?? BaseRouter.pop,
                        size: 44,
                      ),
                      10.gap,
                    ] else
                      18.gap,
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.appBarTitle,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    if (actions != null) ...[10.gap, ...actions!, 6.gap],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: CustomGlassIconButton(icon: icon, onTap: onTap),
    );
  }
}

class CustomGlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const CustomGlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.iconSize = 21,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: colors.glassButtonShadowAlpha,
              ),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Material(
              color: colors.glassButtonBackground,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onTap,
                splashColor: colors.appBarTitle.withValues(alpha: 0.08),
                highlightColor: colors.appBarTitle.withValues(alpha: 0.04),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.glassButtonBorder),
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [
                        colors.glassButtonBackground.withValues(alpha: 0.92),
                        colors.glassButtonBackground.withValues(alpha: 0.64),
                      ],
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: colors.glassButtonIcon,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
