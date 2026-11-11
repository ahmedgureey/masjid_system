import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/language/language_selector_button.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../widgets/brand_header.dart';
import '../widgets/quran_verse.dart';

/// First screen after the splash (S-AUTH-04): greeting, Qur'anic verse
/// (Al-Jinn 72:18), "Gal" (log in) and "Samee akoon" (create account).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // Scrollable column that fills the screen: buttons sit at the bottom
        // on normal phones; on small phones or with large text the page
        // scrolls so every control stays reachable.
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BrandHeader(
                      goldRim: true,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.space6,
                        AppSpacing.space5,
                        AppSpacing.space6,
                        AppSpacing.space8,
                      ),
                      child: Column(
                        children: [
                          const _GoldLogo(),
                          const SizedBox(height: AppSpacing.space4),
                          Text(
                            l10n.welcomeGreeting,
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
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
                    Expanded(
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.space6,
                            AppSpacing.space5,
                            AppSpacing.space6,
                            AppSpacing.space4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const QuranVerse(
                                verse: AppConstants.welcomeVerse,
                                reference: AppConstants.welcomeVerseReference,
                              ),
                              const SizedBox(height: AppSpacing.space5),
                              Text(
                                l10n.welcomeTitle,
                                textAlign: TextAlign.center,
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.space2),
                              Text(
                                l10n.welcomeSubtitle,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.neutral500,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: AppSpacing.space5),
                              AppButton.primary(
                                label: l10n.authLogin,
                                trailingIcon: Icons.arrow_forward_rounded,
                                size: AppButtonSize.large,
                                expand: true,
                                withShadow: true,
                                onPressed: () =>
                                    context.pushIfCurrent(AppRoutes.login),
                              ),
                              const SizedBox(height: AppSpacing.space3),
                              AppButton.secondary(
                                label: l10n.authCreateAccount,
                                size: AppButtonSize.large,
                                expand: true,
                                onPressed: () =>
                                    context.pushIfCurrent(AppRoutes.register),
                              ),
                              const SizedBox(height: AppSpacing.space2),
                              const Center(child: LanguageSelectorButton()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular gold mosque logo with a soft gold glow, for the dark header.
class _GoldLogo extends StatelessWidget {
  const _GoldLogo();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const BrandMark(size: 84),
    );
  }
}
