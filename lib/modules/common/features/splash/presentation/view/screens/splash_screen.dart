import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../auth/presentation/controller/auth_cubit.dart';
import '../../../../auth/presentation/controller/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          AppRoutes.projects.go();
        }
        if (state.status == AuthStatus.unauthenticated) {
          AppRoutes.login.go();
        }
      },
      child: Scaffold(
        body: CustomPage(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  CustomSurface(
                    padding: const EdgeInsets.all(18),
                    child: Image.asset(
                      'assets/images/electro_task_manager_logo.png',
                      width: 78,
                      height: 78,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Electro Task Manager',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Projects, tasks, and focus in one clean workflow.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const CustomLoading(message: 'Checking session...'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
