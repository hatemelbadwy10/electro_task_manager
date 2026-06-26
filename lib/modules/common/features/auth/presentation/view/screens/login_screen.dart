import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controller/auth_cubit.dart';
import '../../controller/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          AppRoutes.projects.go();
        }
        if (state.status == AuthStatus.failure && state.message != null) {
          Toaster.error(state.message!);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        void submit() {
          final isValid = _formKey.currentState?.validate() ?? false;
          if (!isValid || isLoading) return;
          context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          TextInput.finishAutofillContext();
        }

        return Scaffold(
          body: CustomPage(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/electro_task_manager_logo.png',
                        width: 72,
                        height: 72,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    LocaleKeys.auth_welcome_back.tr(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    LocaleKeys.auth_sign_in_subtitle.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  CustomSurface(
                    padding: const EdgeInsets.all(24),
                    child: AutofillGroup(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              label: LocaleKeys.auth_email.tr(),
                              hint: LocaleKeys.auth_email_hint.tr(),
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.username,
                                AutofillHints.email,
                              ],
                              validator: Validator.email,
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              controller: _passwordController,
                              label: LocaleKeys.auth_password.tr(),
                              hint: LocaleKeys.auth_password_hint.tr(),
                              icon: Icons.lock_outline_rounded,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              validator: Validator.password,
                              onFieldSubmitted: (_) => submit(),
                            ),
                            const SizedBox(height: 22),
                            CustomButton(
                              label: LocaleKeys.auth_login.tr(),
                              icon: Icons.arrow_forward_rounded,
                              isLoading: isLoading,
                              onPressed: submit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: AppRoutes.register.go,
                    child: Text(LocaleKeys.auth_create_new_account.tr()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
