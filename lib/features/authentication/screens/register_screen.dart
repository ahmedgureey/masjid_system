import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../application/auth_service.dart';
import '../application/demo_session_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_switch_link.dart';

/// Account registration (S-AUTH-08).
///
/// No backend is connected: a valid form shows a loading state, then an
/// honest "not available yet" message. No account is created and nothing
/// is stored.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const int minPasswordLength = 8;
  static const int minNameLength = 3;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final phone = _phoneController.text.trim();
    final result = await ref
        .read(authServiceProvider)
        .register(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone.isEmpty ? null : phone,
          password: _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _submitting = false);

    final l10n = context.l10n;
    switch (result) {
      case AuthResult.success:
        ref
            .read(demoSessionProvider.notifier)
            .signIn(
              displayName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
            );
        context.go(AppRoutes.home);
      case AuthResult.backendUnavailable:
        await showInfoDialog(
          context,
          title: l10n.mockTitle,
          message: l10n.mockRegisterMessage,
          icon: Icons.cloud_off_rounded,
        );
    }
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
              AuthHeader(
                title: l10n.registerTitle,
                subtitle: l10n.registerSubtitle,
              ),
              const SizedBox(height: AppSpacing.space8),
              Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: l10n.fieldFullName,
                        hint: l10n.fieldFullNameHint,
                        controller: _nameController,
                        isRequired: true,
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        validator: AppValidators.minChars(
                          l10n,
                          RegisterScreen.minNameLength,
                          l10n.validationNameShort,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
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
                        label: '${l10n.fieldPhone} ${l10n.fieldOptional}',
                        hint: l10n.fieldPhoneHint,
                        controller: _phoneController,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        textDirection: TextDirection.ltr,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9+\s-]'),
                          ),
                        ],
                        validator: AppValidators.optional(
                          AppValidators.phone(l10n),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      AppTextField(
                        label: l10n.fieldPassword,
                        helperText: l10n.passwordHelper,
                        controller: _passwordController,
                        isRequired: true,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: AppValidators.minLength(
                          l10n,
                          RegisterScreen.minPasswordLength,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      AppTextField(
                        label: l10n.fieldConfirmPassword,
                        controller: _confirmController,
                        isRequired: true,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: AppValidators.match(
                          l10n,
                          () => _passwordController.text,
                        ),
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      AppCheckboxField(
                        label: Text(l10n.termsAgree),
                        validator: (accepted) =>
                            accepted == true ? null : l10n.validationTerms,
                      ),
                      const SizedBox(height: AppSpacing.space5),
                      AppButton.primary(
                        label: l10n.authCreateAccount,
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
                prompt: l10n.registerHaveAccount,
                actionLabel: l10n.authLogin,
                onPressed: () => context.replaceIfCurrent(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
