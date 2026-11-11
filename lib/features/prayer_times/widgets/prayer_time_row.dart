import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// One row of the daily list: icon, name (+ Arabic), Adhan and Iqamah.
/// Also used for sunrise ([iqamahText] null and [note] set).
class PrayerTimeRow extends StatelessWidget {
  const PrayerTimeRow({
    super.key,
    required this.icon,
    required this.name,
    required this.adhanText,
    this.arabicName,
    this.iqamahText,
    this.showIqamah = true,
    this.note,
    this.isNext = false,
  });

  final IconData icon;
  final String name;
  final String? arabicName;
  final String adhanText;

  /// Null → "Lama dejin" (when [showIqamah]).
  final String? iqamahText;
  final bool showIqamah;

  /// Small secondary line (sunrise explanation).
  final String? note;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final iqamahMissing = iqamahText == null;

    return Container(
      decoration: BoxDecoration(
        color: isNext ? AppColors.green50 : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isNext ? semantic.gold : AppColors.neutral100,
          width: isNext ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space3,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isNext ? AppColors.primary : AppColors.green50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: isNext ? AppColors.white : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isNext)
                      StatusChip(
                        label: l10n.prayerNextBadge,
                        type: StatusType.gold,
                        icon: Icons.notifications_active_outlined,
                      ),
                  ],
                ),
                if (arabicName != null)
                  Text(
                    arabicName!,
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                if (note != null)
                  Text(
                    note!,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  adhanText,
                  textAlign: TextAlign.end,
                  style: textTheme.titleMedium?.copyWith(
                    color: isNext ? AppColors.primary : AppColors.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showIqamah)
                  Text(
                    '${l10n.prayerIqamah}: '
                    '${iqamahText ?? l10n.prayerIqamahNotSet}',
                    textAlign: TextAlign.end,
                    style: textTheme.bodySmall?.copyWith(
                      color: iqamahMissing
                          ? AppColors.neutral500
                          : AppColors.neutral700,
                      fontStyle: iqamahMissing ? FontStyle.italic : null,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
