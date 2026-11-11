import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../application/next_prayer.dart';
import '../models/prayer_labels.dart';

/// Green hero card: "Salaadda Xigta", prayer name, Adhan time and a live
/// HH:MM:SS countdown. [next] null → "not available" message.
class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({
    super.key,
    required this.next,
    required this.now,
    required this.timeText,
    required this.showArabic,
  });

  final NextPrayer? next;
  final DateTime now;

  /// Formatted Adhan time of [next].
  final String? timeText;

  /// Show the Arabic name as a second line (hidden when the UI is Arabic).
  final bool showArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final gold = context.semanticColors.goldOnDark;
    final next = this.next;

    return HeroCard(
      child: next == null
          ? Text(
              l10n.prayerNoNext,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.white),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      size: 18,
                      color: gold,
                    ),
                    const SizedBox(width: AppSpacing.space2),
                    Flexible(
                      child: Text(
                        l10n.prayerNextLabel,
                        style: textTheme.titleSmall?.copyWith(color: gold),
                      ),
                    ),
                    if (next.isTomorrow) ...[
                      const SizedBox(width: AppSpacing.space2),
                      StatusChip(
                        label: l10n.prayerTomorrow,
                        type: StatusType.gold,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.space3),
                Icon(next.prayer.icon, color: AppColors.white, size: 32),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  next.prayer.label(l10n),
                  key: const Key('nextPrayerName'),
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showArabic)
                  Text(
                    next.prayer.arabicName,
                    textDirection: TextDirection.rtl,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.green100,
                    ),
                  ),
                if (timeText != null) ...[
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    timeText!,
                    key: const Key('nextPrayerTime'),
                    style: textTheme.titleLarge?.copyWith(color: gold),
                  ),
                ],
                const SizedBox(height: AppSpacing.space4),
                Text(
                  l10n.prayerCountdownLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.green100,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatCountdown(next.remaining(now)),
                    key: const Key('prayerCountdown'),
                    textDirection: TextDirection.ltr,
                    style: textTheme.displaySmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
