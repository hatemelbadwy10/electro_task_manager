import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../auth/presentation/controller/auth_cubit.dart';
import '../../../../auth/presentation/controller/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _canNavigate = false;
  AuthStatus? _pendingNavigation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    Future<void>.delayed(const Duration(milliseconds: 950), () {
      if (!mounted) return;
      _canNavigate = true;
      _navigateIfReady();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAuthState(AuthState state) {
    if (state.status == AuthStatus.authenticated ||
        state.status == AuthStatus.unauthenticated) {
      _pendingNavigation = state.status;
      _navigateIfReady();
    }
  }

  void _navigateIfReady() {
    if (!_canNavigate || _pendingNavigation == null) return;
    final status = _pendingNavigation;
    _pendingNavigation = null;
    if (status == AuthStatus.authenticated) {
      AppRoutes.projects.go();
    } else {
      AppRoutes.login.go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) => _handleAuthState(state),
      child: Scaffold(
        body: CustomPage(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _fade,
                      child: Image.asset(
                        'assets/images/electro_task_manager_logo.png',
                        width: 78,
                        height: 78,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SlideTransition(
                    position: _slide,
                    child: FadeTransition(
                      opacity: _fade,
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.app_name.tr(),
                            style: Theme.of(context).textTheme.labelLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            LocaleKeys.app_description.tr(),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textMuted),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomLoading(
                    message: LocaleKeys.common_checking_session.tr(),
                  ),
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
