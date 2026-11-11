import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';

/// DEV ONLY — showcase of the design-system widgets in all three languages,
/// used to review Module 1. Remove (or hide behind a debug flag) before
/// release.
class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colors = context.semanticColors;

    return Scaffold(
      appBar: AppTopBar(title: l10n.galleryTitle),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: LanguageSwitcher(),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Buttons -------------------------------------------------------
            SectionHeader(title: l10n.galleryButtons),
            AppButton.primary(
              label: l10n.galleryPrimary,
              icon: Icons.add_rounded,
              expand: true,
              size: AppButtonSize.large,
              isLoading: _loading,
              onPressed: () => setState(() => _loading = !_loading),
            ),
            const SizedBox(height: AppSpacing.space3),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                AppButton.secondary(
                  label: l10n.gallerySecondary,
                  onPressed: () {},
                ),
                AppButton.accent(
                  label: l10n.galleryAccent,
                  icon: Icons.volunteer_activism_rounded,
                  onPressed: () {},
                ),
                AppButton.text(label: l10n.galleryTextButton, onPressed: () {}),
                AppButton.destructive(
                  label: l10n.galleryDestructive,
                  onPressed: () {},
                ),
                AppButton.primary(
                  label: l10n.commonSave,
                  size: AppButtonSize.small,
                  onPressed: () {},
                ),
                AppButton.primary(label: l10n.commonContinue, onPressed: null),
              ],
            ),
            const SizedBox(height: AppSpacing.space6),

            // Inputs --------------------------------------------------------
            SectionHeader(title: l10n.galleryInputs),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: l10n.galleryFullName,
                    hint: l10n.galleryFullNameHint,
                    isRequired: true,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: AppValidators.required(l10n),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  AppTextField(
                    label: l10n.galleryPassword,
                    isPassword: true,
                    isRequired: true,
                    validator: AppValidators.minLength(l10n, 8),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  AppTextField(
                    label: l10n.galleryAmount,
                    prefixText: r'$',
                    hint: '0.00',
                    textDirection: TextDirection.ltr,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  AppButton.secondary(
                    label: l10n.commonContinue,
                    expand: true,
                    onPressed: () => _formKey.currentState?.validate(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Cards ---------------------------------------------------------
            SectionHeader(title: l10n.galleryCards, onSeeAll: () {}),
            HeroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.galleryNextPrayer,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.green100,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    'Asr · العصر',
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    '01:42:18',
                    textDirection: TextDirection.ltr,
                    style: AppTypography.countdown.copyWith(
                      color: colors.goldOnDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            AppCard(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.event_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.galleryCardTitle,
                          style: textTheme.titleSmall,
                        ),
                        Text(
                          l10n.galleryCardBody,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.neutral400,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            AppCard(
              variant: AppCardVariant.tinted,
              child: Text(l10n.galleryTintedBody, style: textTheme.bodyMedium),
            ),
            const SizedBox(height: AppSpacing.space3),
            AppCard(
              variant: AppCardVariant.gold,
              child: Text(
                l10n.galleryTintedBody,
                style: textTheme.bodyMedium?.copyWith(color: colors.goldText),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // Status chips --------------------------------------------------
            SectionHeader(title: l10n.galleryChips),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                StatusChip(
                  label: l10n.statusApproved,
                  type: StatusType.success,
                  icon: Icons.check_rounded,
                ),
                StatusChip(
                  label: l10n.statusPending,
                  type: StatusType.warning,
                  icon: Icons.schedule_rounded,
                ),
                StatusChip(
                  label: l10n.statusRejected,
                  type: StatusType.error,
                  icon: Icons.close_rounded,
                ),
                StatusChip(
                  label: l10n.statusExcused,
                  type: StatusType.info,
                  icon: Icons.info_outline_rounded,
                ),
                StatusChip(
                  label: l10n.galleryNextPrayer,
                  type: StatusType.gold,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space6),

            // States --------------------------------------------------------
            SectionHeader(title: l10n.galleryStates),
            const AppCard(child: AppSkeletonList()),
            const SizedBox(height: AppSpacing.space3),
            const AppCard(child: AppLoadingIndicator()),
            const SizedBox(height: AppSpacing.space3),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: const OfflineBanner(),
            ),
            const SizedBox(height: AppSpacing.space3),
            AppCard(
              child: EmptyState(
                icon: Icons.event_busy_rounded,
                actionLabel: l10n.commonRetry,
                onAction: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            AppCard(child: ErrorState(onRetry: () {})),
          ],
        ),
      ),
    );
  }
}
