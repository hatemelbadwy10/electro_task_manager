import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_error_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../auth/presentation/controller/auth_cubit.dart';
import '../../controller/profile_cubit.dart';
import '../../controller/profile_state.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: CustomPage(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading ||
                state.status == ProfileStatus.initial) {
              return const CustomLoading(message: 'Loading profile...');
            }

            if (state.status == ProfileStatus.failure) {
              return CustomErrorView(
                message: state.message ?? 'Could not load profile',
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
                              user?.name ?? 'User',
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
                  child: ListTile(
                    leading: const Icon(Icons.api_rounded),
                    title: const Text('API mode'),
                    subtitle: const Text('Configured with API_BASE_URL'),
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
                  label: const Text('Logout'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
