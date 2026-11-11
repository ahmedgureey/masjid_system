import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/language/language_options_list.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../widgets/brand_header.dart';

/// First-launch language choice (S-AUTH-02). Selecting a language switches
/// the UI immediately, including right-to-left for Arabic.
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            const BrandHeader(child: Center(child: BrandMark(size: 72))),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.space6),
                children: [
                  Text(l10n.languageTitle, style: textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.space1),
                  // Always shown in all three languages so anyone can find
                  // their language before choosing.
                  Text(
                    'Choose your language · Dooro luqadda · اختر اللغة',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  const LanguageOptionsList(),
                  Text(
                    l10n.languageSubtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(
                AppSpacing.space6,
                0,
                AppSpacing.space6,
                AppSpacing.space4,
              ),
              child: AppButton.primary(
                label: l10n.commonContinue,
                size: AppButtonSize.large,
                expand: true,
                onPressed: () => context.push(AppRoutes.onboarding),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
