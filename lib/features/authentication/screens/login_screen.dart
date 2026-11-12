import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../application/auth_result_message.dart';
import '../application/auth_service.dart';
import '../application/demo_session_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_switch_link.dart';

/// Email + password login (S-AUTH-07).
///
/// No backend is connected: a valid form shows a loading state, then an
/// honest "not available yet" message. The user is never signed in and
/// nothing is stored.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  /// Ticked by default, matching registration, which has always kept the
  /// session.
  ///
  /// Off by default meant that closing the app signed the user out, and
  /// since every add, edit and delete control is hidden from visitors, the
  /// app came back looking read-only — as though the data they had entered
  /// was gone, when it was only the session. Unticking still works for a
  /// shared device.
  bool _rememberMe = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final result = await ref
        .read(authServiceProvider)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
    if (!mounted) return;
    setState(() => _submitting = false);

    final l10n = context.l10n;
    if (result == AuthResult.success) {
      final email = _emailController.text.trim();
      ref
          .read(demoSessionProvider.notifier)
          .signIn(
            displayName: email.split('@').first,
            email: email,
            remember: _rememberMe,
          );
      context.go(AppRoutes.home);
      return;
    }
    // Any other outcome is a failure: say which one, and stay on the form.
    final m = authMessageFor(
      result,
      l10n,
      unavailableMessage: l10n.mockLoginMessage,
    );
    await showInfoDialog(
      context,
      title: m.title,
      message: m.message,
      icon: m.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: const AppTopBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space2,
            AppSpacing.space6,
            AppSpacing.space6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(title: l10n.loginTitle, subtitle: l10n.loginSubtitle),
              const SizedBox(height: AppSpacing.space8),
              Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: l10n.fieldEmail,
                        hint: l10n.fieldEmailHint,
                        controller: _emailController,
                        isRequired: true,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        textDirection: TextDirection.ltr,
                        validator: AppValidators.email(l10n),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      AppTextField(
                        label: l10n.fieldPassword,
                        controller: _passwordController,
                        isRequired: true,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        validator: AppValidators.required(l10n),
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      AppCheckboxField(
                        label: Text(l10n.rememberMe),
                        initialValue: _rememberMe,
                        onChanged: (value) => _rememberMe = value,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () =>
                              context.pushIfCurrent(AppRoutes.forgotPassword),
                          child: Text(l10n.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      AppButton.primary(
                        label: l10n.authLogin,
                        size: AppButtonSize.large,
                        expand: true,
                        isLoading: _submitting,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
              AuthSwitchLink(
                prompt: l10n.loginNoAccount,
                actionLabel: l10n.authCreateAccount,
                onPressed: () => context.replaceIfCurrent(AppRoutes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
