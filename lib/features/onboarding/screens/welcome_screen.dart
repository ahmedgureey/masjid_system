import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../widgets/brand_header.dart';
import '../widgets/language_options_list.dart';

/// Entry point for signed-out users (S-AUTH-04): log in or create account.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  String _languageName(AppLocalizations l10n, Locale locale) =>
      switch (locale.languageCode) {
        'ar' => l10n.languageArabic,
        'so' => l10n.languageSomali,
        _ => l10n.languageEnglish,
      };

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            0,
            AppSpacing.space6,
            AppSpacing.space4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                sheetContext.l10n.language,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.space4),
              LanguageOptionsList(
                onSelected: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BrandHeader(
                child: Column(
                  children: [
                    const BrandMark(size: 88),
                    const SizedBox(height: AppSpacing.space5),
                    Text(
                      l10n.welcomeGreeting,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: context.semanticColors.goldOnDark,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space1),
                    Text(
                      l10n.appName,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        l10n.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: AppSpacing.space6),
                      AppButton.primary(
                        label: l10n.authLogin,
                        size: AppButtonSize.large,
                        expand: true,
                        onPressed: () => context.push(AppRoutes.login),
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      AppButton.secondary(
                        label: l10n.authCreateAccount,
                        size: AppButtonSize.large,
                        expand: true,
                        onPressed: () => context.push(AppRoutes.register),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => _showLanguageSheet(context),
                          icon: const Icon(Icons.language_rounded, size: 20),
                          label: Text(
                            '${l10n.language}: '
                            '${_languageName(l10n, locale)}',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        l10n.welcomeTerms,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
