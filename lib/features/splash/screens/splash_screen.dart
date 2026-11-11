import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/brand_mark.dart';
import '../application/app_startup_provider.dart';

/// Brand screen shown while [appStartupProvider] runs.
/// Design: `docs/design/screen-designs.md` §1.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigation decision lives in the provider; the screen only reacts.
    ref.listen<AsyncValue<String>>(appStartupProvider, (previous, next) {
      if (next case AsyncData(:final value)) {
        context.go(value);
      }
    });

    final textTheme = Theme.of(context).textTheme;
    final colors = context.semanticColors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: colors.splashGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BrandMark(),
                    const SizedBox(height: AppSpacing.space8),
                    Text(
                      AppConstants.bismillah,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: AppTypography.quranic.copyWith(
                        color: colors.goldOnDark,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space6),
                    Text(
                      context.l10n.appName,
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      context.l10n.splashTagline,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.green100,
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
