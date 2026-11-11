import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/auth_service.dart';
import '../widgets/auth_header.dart';

/// Password reset request (S-AUTH-09). No email is sent until the backend
/// exists; the user is told so honestly.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final result = await ref
        .read(authServiceProvider)
        .sendPasswordReset(email: _emailController.text.trim());
    if (!mounted) return;
    setState(() => _submitting = false);

    if (result == AuthResult.backendUnavailable) {
      final l10n = context.l10n;
      await showInfoDialog(
        context,
        title: l10n.mockTitle,
        message: l10n.mockResetMessage,
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
                title: l10n.forgotTitle,
                subtitle: l10n.forgotSubtitle,
              ),
              const SizedBox(height: AppSpacing.space8),
              Form(
                key: _formKey,
                child: AppTextField(
                  label: l10n.fieldEmail,
                  hint: l10n.fieldEmailHint,
                  controller: _emailController,
                  isRequired: true,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  textDirection: TextDirection.ltr,
                  validator: AppValidators.email(l10n),
                  onFieldSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(height: AppSpacing.space6),
              AppButton.primary(
                label: l10n.forgotSend,
                size: AppButtonSize.large,
                expand: true,
                isLoading: _submitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.space3),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.forgotBackToLogin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
