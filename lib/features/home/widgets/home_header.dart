import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/islamic_pattern.dart';
import '../models/mosque_service_slide.dart';
import 'mosque_services_carousel.dart';

/// Home header: green hero band with the rotating services carousel, the
/// overlapping circular logo, the mosque name and the live date and time.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.dateText,
    required this.timeText,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onNotificationsTap,
    required this.onServiceTap,
    this.subtitle,
    this.coverUrl,
    this.logoUrl,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onNotificationsTap;

  /// Opens the route behind a tapped carousel slide.
  final ValueChanged<String> onServiceTap;

  final String name;
  final String? subtitle;
  final String dateText;
  final String timeText;
  final String? coverUrl;
  final String? logoUrl;

  static const double logoSize = 96;

  /// Share of the screen height the hero band takes, within sane bounds so it
  /// neither swallows a small phone nor floats on a tall one.
  static double coverHeightFor(BuildContext context) =>
      (MediaQuery.sizeOf(context).height * 0.30).clamp(220.0, 290.0);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;
    final coverHeight = coverHeightFor(context);

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
              // Leaves room for the logo, which overlaps the bottom edge.
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                bottom: logoSize + AppSpacing.space2,
                child: MosqueServicesCarousel(
                  slides: mosqueServiceSlides,
                  onSlideTap: (slide) => onServiceTap(slide.route),
                ),
              ),
              if (coverUrl == null)
                PositionedDirectional(
                  start: AppSpacing.space4,
                  end: 112,
                  top: topInset + AppSpacing.space4,
                  child: const _CoverPendingChip(),
                ),
              // Same corner and size as the former language button:
              // notifications bell + light/dark toggle. Above the carousel so
              // they stay tappable and visible on every slide.
              PositionedDirectional(
                top: topInset + AppSpacing.space2,
                end: AppSpacing.space2,
                child: const _HeaderActionsScrim(),
              ),
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
        const SizedBox(height: AppSpacing.space2),
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
              const SizedBox(height: AppSpacing.space2),
              // Compact enough that the date and the time sit on one line on
              // a phone; the Wrap still stacks them at large text sizes.
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.space2,
                runSpacing: AppSpacing.space1,
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

/// Hero background: the mosque's cover photo when it has one, otherwise the
/// branded green gradient with the Islamic star pattern.
class _Cover extends StatelessWidget {
  const _Cover({required this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(bottom: Radius.circular(28));
    // Shown when there is no cover photo, while one loads, and if loading
    // fails — the carousel text must stay readable in every one of those
    // cases, so the fallback is never blank.
    final branded = DecoratedBox(
      decoration: BoxDecoration(
        gradient: context.semanticColors.splashGradient,
      ),
      child: const IslamicPattern(),
    );
    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverUrl != null)
            Image.network(
              coverUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => branded,
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : branded,
            )
          else
            branded,
          // Soft overhead light, and — over a photo — the scrim that keeps
          // the carousel text readable on any image.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.75),
                radius: 1.1,
                colors: [
                  AppColors.white.withValues(alpha: 0.10),
                  AppColors.green900.withValues(
                    alpha: coverUrl == null ? 0.18 : 0.62,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Honest label while no cover photo has been uploaded. Kept in the top
/// corner opposite the action buttons so it never covers them or the logo.
class _CoverPendingChip extends StatelessWidget {
  const _CoverPendingChip();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

/// Soft dark wash behind the bell and theme toggle: keeps white icons legible
/// when a bright cover photo or slide sits underneath.
class _HeaderActionsScrim extends StatelessWidget {
  const _HeaderActionsScrim();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 96,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.green900.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(AppRadius.full),
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
      child: ClipOval(child: _logo(context)),
    );
  }

  /// The mosque logo must never disappear: an unreachable [logoUrl] falls
  /// back to the brand mark instead of a broken-image icon.
  Widget _logo(BuildContext context) {
    final mark = DecoratedBox(
      decoration: BoxDecoration(
        gradient: context.semanticColors.splashGradient,
      ),
      child: Center(child: BrandMark(size: size * 0.74)),
    );
    final url = logoUrl;
    if (url == null) return mark;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => mark,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : mark,
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
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: context.semanticColors.brandText,
      fontWeight: FontWeight.w500,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space3,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: context.semanticColors.tintedBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.space1),
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
