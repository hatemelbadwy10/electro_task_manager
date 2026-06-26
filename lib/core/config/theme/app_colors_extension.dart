import 'package:flutter/material.dart';

import 'app_colors.dart';

/// A [ThemeExtension] that provides all semantic color tokens for the app.
///
/// Instead of checking `isDark` manually, widgets access colors via:
/// ```dart
/// final colors = Theme.of(context).appColors;
/// ```
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  /// Primary text color.
  final Color textPrimary;

  /// Secondary / muted text color.
  final Color textMuted;

  /// Card title color (slightly different from textPrimary on light theme).
  final Color cardTitle;

  /// Default surface color.
  final Color surface;

  /// Surface container (elevated surface).
  final Color surfaceContainer;

  /// Border / outline color.
  final Color outline;

  /// Card surface color (with alpha baked in).
  final Color cardSurface;

  /// Card border color (with alpha baked in).
  final Color cardBorder;

  /// Shadow alpha for primary card shadow.
  final double cardShadowAlpha;

  /// Shadow alpha for secondary card shadow.
  final double secondaryCardShadowAlpha;

  /// Project card surface color.
  final Color projectCardSurface;

  /// Project card border color.
  final Color projectCardBorder;

  /// Project card primary shadow alpha.
  final double projectCardShadowAlpha;

  /// Project card secondary shadow alpha.
  final double projectCardSecondaryShadowAlpha;

  /// Page background gradient colors (top → bottom).
  final List<Color> pageGradientColors;

  /// Alpha for the primary accent blur circle on pages.
  final double accentCircleAlpha;

  /// Color for the secondary accent blur circle on pages.
  final Color accentCircleColor;

  /// Popup actions background color.
  final Color popupBackground;

  /// Popup backdrop alpha.
  final double popupBackdropAlpha;

  /// Popup text color.
  final Color popupTextColor;

  /// Popup blur sigma.
  final double popupBlurSigma;

  /// App bar glass background.
  final Color appBarBackground;

  /// App bar glass border.
  final Color appBarBorder;

  /// App bar title color.
  final Color appBarTitle;

  /// App bar shadow alpha.
  final double appBarShadowAlpha;

  /// App bar inner glow alpha.
  final double appBarInnerGlowAlpha;

  /// Glass icon button background.
  final Color glassButtonBackground;

  /// Glass icon button border.
  final Color glassButtonBorder;

  /// Glass icon color.
  final Color glassButtonIcon;

  /// Glass icon shadow alpha.
  final double glassButtonShadowAlpha;

  const AppColorsExtension({
    required this.textPrimary,
    required this.textMuted,
    required this.cardTitle,
    required this.surface,
    required this.surfaceContainer,
    required this.outline,
    required this.cardSurface,
    required this.cardBorder,
    required this.cardShadowAlpha,
    required this.secondaryCardShadowAlpha,
    required this.projectCardSurface,
    required this.projectCardBorder,
    required this.projectCardShadowAlpha,
    required this.projectCardSecondaryShadowAlpha,
    required this.pageGradientColors,
    required this.accentCircleAlpha,
    required this.accentCircleColor,
    required this.popupBackground,
    required this.popupBackdropAlpha,
    required this.popupTextColor,
    required this.popupBlurSigma,
    required this.appBarBackground,
    required this.appBarBorder,
    required this.appBarTitle,
    required this.appBarShadowAlpha,
    required this.appBarInnerGlowAlpha,
    required this.glassButtonBackground,
    required this.glassButtonBorder,
    required this.glassButtonIcon,
    required this.glassButtonShadowAlpha,
  });

  /// Light theme colors.
  factory AppColorsExtension.light() => AppColorsExtension(
    textPrimary: AppColors.text,
    textMuted: AppColors.textMuted,
    cardTitle: const Color(0xFF1D214A),
    surface: AppColors.surface,
    surfaceContainer: AppColors.surfaceContainer,
    outline: AppColors.outline,
    cardSurface: AppColors.surface.withValues(alpha: 0.92),
    cardBorder: Colors.white.withValues(alpha: 0.78),
    cardShadowAlpha: 0.08,
    secondaryCardShadowAlpha: 0.04,
    projectCardSurface: AppColors.lavender.withValues(alpha: 0.58),
    projectCardBorder: Colors.white.withValues(alpha: 0.5),
    projectCardShadowAlpha: 0.22,
    projectCardSecondaryShadowAlpha: 0.7,
    pageGradientColors: const [
      Color(0xFFF4F6FF),
      AppColors.background,
      Color(0xFFFFFFFF),
    ],
    accentCircleAlpha: 0.14,
    accentCircleColor: AppColors.lavenderDeep.withValues(alpha: 0.7),
    popupBackground: Colors.white.withValues(alpha: 0.97),
    popupBackdropAlpha: 0.18,
    popupTextColor: AppColors.text,
    popupBlurSigma: 22,
    appBarBackground: Colors.white.withValues(alpha: 0.58),
    appBarBorder: Colors.white.withValues(alpha: 0.72),
    appBarTitle: const Color(0xFF16324F),
    appBarShadowAlpha: 0.12,
    appBarInnerGlowAlpha: 0.65,
    glassButtonBackground: Colors.white.withValues(alpha: 0.64),
    glassButtonBorder: Colors.white.withValues(alpha: 0.76),
    glassButtonIcon: const Color(0xFF16324F),
    glassButtonShadowAlpha: 0.12,
  );

  /// Dark theme colors.
  factory AppColorsExtension.dark() => AppColorsExtension(
    textPrimary: AppColors.darkText,
    textMuted: AppColors.darkTextMuted,
    cardTitle: AppColors.darkText,
    surface: AppColors.darkSurface,
    surfaceContainer: AppColors.darkSurfaceContainer,
    outline: AppColors.darkOutline,
    cardSurface: AppColors.darkSurface.withValues(alpha: 0.86),
    cardBorder: AppColors.darkOutline.withValues(alpha: 0.9),
    cardShadowAlpha: 0.18,
    secondaryCardShadowAlpha: 0.24,
    projectCardSurface: AppColors.darkSurfaceContainer.withValues(alpha: 0.72),
    projectCardBorder: AppColors.darkOutline.withValues(alpha: 0.88),
    projectCardShadowAlpha: 0.34,
    projectCardSecondaryShadowAlpha: 0.18,
    pageGradientColors: const [
      Color(0xFF151832),
      AppColors.darkBackground,
      Color(0xFF0B0D1C),
    ],
    accentCircleAlpha: 0.24,
    accentCircleColor: AppColors.secondary.withValues(alpha: 0.14),
    popupBackground: AppColors.darkSurface.withValues(alpha: 0.96),
    popupBackdropAlpha: 0.42,
    popupTextColor: AppColors.darkText,
    popupBlurSigma: 22,
    appBarBackground: AppColors.darkSurface.withValues(alpha: 0.76),
    appBarBorder: AppColors.darkOutline.withValues(alpha: 0.92),
    appBarTitle: AppColors.darkText,
    appBarShadowAlpha: 0.26,
    appBarInnerGlowAlpha: 0.08,
    glassButtonBackground: AppColors.darkSurfaceContainer.withValues(
      alpha: 0.86,
    ),
    glassButtonBorder: AppColors.darkOutline.withValues(alpha: 0.94),
    glassButtonIcon: AppColors.darkText,
    glassButtonShadowAlpha: 0.24,
  );

  @override
  AppColorsExtension copyWith({
    Color? textPrimary,
    Color? textMuted,
    Color? cardTitle,
    Color? surface,
    Color? surfaceContainer,
    Color? outline,
    Color? cardSurface,
    Color? cardBorder,
    double? cardShadowAlpha,
    double? secondaryCardShadowAlpha,
    Color? projectCardSurface,
    Color? projectCardBorder,
    double? projectCardShadowAlpha,
    double? projectCardSecondaryShadowAlpha,
    List<Color>? pageGradientColors,
    double? accentCircleAlpha,
    Color? accentCircleColor,
    Color? popupBackground,
    double? popupBackdropAlpha,
    Color? popupTextColor,
    double? popupBlurSigma,
    Color? appBarBackground,
    Color? appBarBorder,
    Color? appBarTitle,
    double? appBarShadowAlpha,
    double? appBarInnerGlowAlpha,
    Color? glassButtonBackground,
    Color? glassButtonBorder,
    Color? glassButtonIcon,
    double? glassButtonShadowAlpha,
  }) {
    return AppColorsExtension(
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      cardTitle: cardTitle ?? this.cardTitle,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      outline: outline ?? this.outline,
      cardSurface: cardSurface ?? this.cardSurface,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadowAlpha: cardShadowAlpha ?? this.cardShadowAlpha,
      secondaryCardShadowAlpha:
          secondaryCardShadowAlpha ?? this.secondaryCardShadowAlpha,
      projectCardSurface: projectCardSurface ?? this.projectCardSurface,
      projectCardBorder: projectCardBorder ?? this.projectCardBorder,
      projectCardShadowAlpha:
          projectCardShadowAlpha ?? this.projectCardShadowAlpha,
      projectCardSecondaryShadowAlpha:
          projectCardSecondaryShadowAlpha ??
          this.projectCardSecondaryShadowAlpha,
      pageGradientColors: pageGradientColors ?? this.pageGradientColors,
      accentCircleAlpha: accentCircleAlpha ?? this.accentCircleAlpha,
      accentCircleColor: accentCircleColor ?? this.accentCircleColor,
      popupBackground: popupBackground ?? this.popupBackground,
      popupBackdropAlpha: popupBackdropAlpha ?? this.popupBackdropAlpha,
      popupTextColor: popupTextColor ?? this.popupTextColor,
      popupBlurSigma: popupBlurSigma ?? this.popupBlurSigma,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarBorder: appBarBorder ?? this.appBarBorder,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      appBarShadowAlpha: appBarShadowAlpha ?? this.appBarShadowAlpha,
      appBarInnerGlowAlpha: appBarInnerGlowAlpha ?? this.appBarInnerGlowAlpha,
      glassButtonBackground:
          glassButtonBackground ?? this.glassButtonBackground,
      glassButtonBorder: glassButtonBorder ?? this.glassButtonBorder,
      glassButtonIcon: glassButtonIcon ?? this.glassButtonIcon,
      glassButtonShadowAlpha:
          glassButtonShadowAlpha ?? this.glassButtonShadowAlpha,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      cardTitle: Color.lerp(cardTitle, other.cardTitle, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      outline: Color.lerp(outline, other.outline, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadowAlpha:
          lerpDouble(cardShadowAlpha, other.cardShadowAlpha, t) ??
          cardShadowAlpha,
      secondaryCardShadowAlpha:
          lerpDouble(
            secondaryCardShadowAlpha,
            other.secondaryCardShadowAlpha,
            t,
          ) ??
          secondaryCardShadowAlpha,
      projectCardSurface: Color.lerp(
        projectCardSurface,
        other.projectCardSurface,
        t,
      )!,
      projectCardBorder: Color.lerp(
        projectCardBorder,
        other.projectCardBorder,
        t,
      )!,
      projectCardShadowAlpha:
          lerpDouble(projectCardShadowAlpha, other.projectCardShadowAlpha, t) ??
          projectCardShadowAlpha,
      projectCardSecondaryShadowAlpha:
          lerpDouble(
            projectCardSecondaryShadowAlpha,
            other.projectCardSecondaryShadowAlpha,
            t,
          ) ??
          projectCardSecondaryShadowAlpha,
      pageGradientColors: [
        for (int i = 0; i < pageGradientColors.length; i++)
          Color.lerp(pageGradientColors[i], other.pageGradientColors[i], t)!,
      ],
      accentCircleAlpha:
          lerpDouble(accentCircleAlpha, other.accentCircleAlpha, t) ??
          accentCircleAlpha,
      accentCircleColor: Color.lerp(
        accentCircleColor,
        other.accentCircleColor,
        t,
      )!,
      popupBackground: Color.lerp(popupBackground, other.popupBackground, t)!,
      popupBackdropAlpha:
          lerpDouble(popupBackdropAlpha, other.popupBackdropAlpha, t) ??
          popupBackdropAlpha,
      popupTextColor: Color.lerp(popupTextColor, other.popupTextColor, t)!,
      popupBlurSigma:
          lerpDouble(popupBlurSigma, other.popupBlurSigma, t) ?? popupBlurSigma,
      appBarBackground: Color.lerp(
        appBarBackground,
        other.appBarBackground,
        t,
      )!,
      appBarBorder: Color.lerp(appBarBorder, other.appBarBorder, t)!,
      appBarTitle: Color.lerp(appBarTitle, other.appBarTitle, t)!,
      appBarShadowAlpha:
          lerpDouble(appBarShadowAlpha, other.appBarShadowAlpha, t) ??
          appBarShadowAlpha,
      appBarInnerGlowAlpha:
          lerpDouble(appBarInnerGlowAlpha, other.appBarInnerGlowAlpha, t) ??
          appBarInnerGlowAlpha,
      glassButtonBackground: Color.lerp(
        glassButtonBackground,
        other.glassButtonBackground,
        t,
      )!,
      glassButtonBorder: Color.lerp(
        glassButtonBorder,
        other.glassButtonBorder,
        t,
      )!,
      glassButtonIcon: Color.lerp(glassButtonIcon, other.glassButtonIcon, t)!,
      glassButtonShadowAlpha:
          lerpDouble(glassButtonShadowAlpha, other.glassButtonShadowAlpha, t) ??
          glassButtonShadowAlpha,
    );
  }
}

/// Convenience accessor for [AppColorsExtension] from [ThemeData].
extension AppColorsThemeDataExtension on ThemeData {
  AppColorsExtension get appColors => extension<AppColorsExtension>()!;
}

/// Convenience accessor for [AppColorsExtension] from [BuildContext].
extension AppColorsBuildContextExtension on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

double? lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
