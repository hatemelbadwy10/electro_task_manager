import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/theme_controller.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_error_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../auth/presentation/controller/auth_cubit.dart';
import '../../controller/profile_cubit.dart';
import '../../controller/profile_state.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on locale change
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.profile_title.tr()),
      body: CustomPage(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading ||
                state.status == ProfileStatus.initial) {
              return CustomLoading(message: LocaleKeys.profile_loading.tr());
            }

            if (state.status == ProfileStatus.failure) {
              return CustomErrorView(
                message: state.message ?? LocaleKeys.profile_could_not_load.tr(),
                onRetry: context.read<ProfileCubit>().loadProfile,
              );
            }

            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CustomSurface(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                        foregroundColor: AppColors.primary,
                        child: const Icon(Icons.person_rounded, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? LocaleKeys.profile_default_user.tr(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? '',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomSurface(
                  padding: EdgeInsets.zero,
                  child: ValueListenableBuilder<ThemeMode>(
                    valueListenable: sl<ThemeController>(),
                    builder: (context, themeMode, _) {
                      final isDark = themeMode == ThemeMode.dark;
                      return SwitchListTile.adaptive(
                        value: isDark,
                        onChanged: sl<ThemeController>().setDarkMode,
                        secondary: Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                        ),
                        title: Text(LocaleKeys.profile_dark_mode.tr()),
                        subtitle: Text(isDark ? LocaleKeys.profile_dark_theme.tr() : LocaleKeys.profile_light_theme.tr()),
                        activeThumbColor: AppColors.primary,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomSurface(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: Text(LocaleKeys.profile_language.tr()),
                    subtitle: Text(context.locale.languageCode == 'ar' ? LocaleKeys.profile_arabic.tr() : LocaleKeys.profile_english.tr()),
                    trailing: const Icon(Icons.swap_horiz_rounded),
                    iconColor: AppColors.primary,
                    onTap: () {
                      final newLocale = context.locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
                      context.setLocale(newLocale);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomSurface(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: const Icon(Icons.api_rounded),
                    title: Text(LocaleKeys.profile_api_mode.tr()),
                    subtitle: Text(LocaleKeys.profile_api_mode_desc.tr()),
                    trailing: const Icon(Icons.check_circle_rounded),
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AuthCubit>().logout();
                    AppRoutes.login.go();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(LocaleKeys.profile_logout.tr()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
