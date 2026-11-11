import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/islamic_pattern.dart';

/// Home header: cover photo, overlapping circular logo, mosque name,
/// optional subtitle, and live date and time.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.dateText,
    required this.timeText,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onNotificationsTap,
    this.subtitle,
    this.coverUrl,
    this.logoUrl,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onNotificationsTap;
  final String name;
  final String? subtitle;
  final String dateText;
  final String timeText;
  final String? coverUrl;
  final String? logoUrl;

  static const double coverHeight = 190;
  static const double logoSize = 96;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Column(
      children: [
        SizedBox(
          height: coverHeight + topInset + logoSize / 2,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: coverHeight + topInset,
                child: _Cover(coverUrl: coverUrl),
              ),
              // Same corner and size as the former language button:
              // notifications bell + light/dark toggle.
              PositionedDirectional(
                top: topInset + AppSpacing.space2,
                end: AppSpacing.space2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('homeNotifications'),
                      tooltip: context.l10n.notificationsTitle,
                      color: AppColors.white,
                      icon: const Icon(Icons.notifications_rounded),
                      onPressed: onNotificationsTap,
                    ),
                    IconButton(
                      key: const Key('homeThemeToggle'),
                      tooltip: isDarkMode
                          ? context.l10n.themeSwitchToLight
                          : context.l10n.themeSwitchToDark,
                      color: AppColors.white,
                      icon: Icon(
                        isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                      onPressed: onToggleTheme,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _Logo(size: logoSize, logoUrl: logoUrl),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space5),
          child: Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: context.semanticColors.brandText,
                ),
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space1),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: context.semanticColors.mutedText,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.space3),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.space2,
                runSpacing: AppSpacing.space2,
                children: [
                  _InfoPill(icon: Icons.calendar_today_rounded, text: dateText),
                  _InfoPill(
                    icon: Icons.access_time_rounded,
                    text: timeText,
                    tabular: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(bottom: Radius.circular(28));
    if (coverUrl != null) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.network(coverUrl!, fit: BoxFit.cover),
      );
    }
    // No photo uploaded yet: branded placeholder, clearly labelled.
    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: context.semanticColors.splashGradient,
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: IslamicPattern()),
            Center(
              child: Icon(
                Icons.mosque_rounded,
                size: 96,
                color: AppColors.white.withValues(alpha: 0.12),
              ),
            ),
            // Top corner (opposite the notification / theme buttons) so the
            // logo never covers it.
            PositionedDirectional(
              start: AppSpacing.space4,
              end: 112,
              top: MediaQuery.paddingOf(context).top + AppSpacing.space4,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space2,
                    vertical: AppSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green900.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.photo_outlined,
                        size: 14,
                        color: AppColors.green100,
                      ),
                      const SizedBox(width: AppSpacing.space1),
                      Flexible(
                        child: Text(
                          context.l10n.coverPhotoPending,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.green100),
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

class _Logo extends StatelessWidget {
  const _Logo({required this.size, required this.logoUrl});

  final double size;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.semanticColors.cardBackground,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x29176B45),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: logoUrl != null
            ? Image.network(logoUrl!, fit: BoxFit.cover)
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: context.semanticColors.splashGradient,
                ),
                child: Center(child: BrandMark(size: size * 0.74)),
              ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    this.tabular = false,
  });

  final IconData icon;
  final String text;
  final bool tabular;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: context.semanticColors.brandText);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space3,
        vertical: AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: context.semanticColors.tintedBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.space2),
          Flexible(
            child: Text(
              text,
              style: tabular
                  ? style?.copyWith(fontFeatures: AppTypography.tabularFigures)
                  : style,
            ),
          ),
        ],
      ),
    );
  }
}
