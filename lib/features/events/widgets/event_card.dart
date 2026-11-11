import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../models/event_labels.dart';
import '../models/mosque_event.dart';

/// Formats "4:00 PM – 5:30 PM" (or just the start).
String eventTimeRange(
  MosqueEvent event, {
  required String languageCode,
  required bool use24h,
}) {
  String t(DateTime d) =>
      AppDateFormatter.time(d, use24h: use24h, locale: languageCode);
  final end = event.end;
  if (end == null) return t(event.start);
  final sameDay =
      end.year == event.start.year &&
      end.month == event.start.month &&
      end.day == event.start.day;
  return sameDay
      ? '${t(event.start)} – ${t(end)}'
      : '${t(event.start)} – '
            '${AppDateFormatter.shortDate(end, locale: languageCode)} ${t(end)}';
}

/// Rounded card of one event in the list.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.now,
    required this.languageCode,
    required this.onTap,
  });

  final MosqueEvent event;
  final DateTime now;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);
    final cancelled = event.status == EventStatus.cancelled;

    return AppCard(
      onTap: onTap,
      semanticLabel: event.title,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateBadge(date: event.start, languageCode: languageCode),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  children: [
                    StatusChip(
                      label: event.category.label(l10n),
                      icon: event.category.icon,
                    ),
                    eventStatusChip(event, now, l10n),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  event.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration: cancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                _line(
                  context,
                  Icons.schedule_rounded,
                  eventTimeRange(
                    event,
                    languageCode: languageCode,
                    use24h: use24h,
                  ),
                ),
                _line(context, Icons.place_outlined, event.location),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.neutral400),
        ],
      ),
    );
  }

  Widget _line(BuildContext context, IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.neutral500),
        const SizedBox(width: AppSpacing.space1),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.neutral600),
          ),
        ),
      ],
    ),
  );
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date, required this.languageCode});

  final DateTime date;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final month = AppDateFormatter.monthYear(
      date,
      locale: languageCode,
    ).split(' ').first;
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      decoration: BoxDecoration(
        color: AppColors.green50,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            '${date.day}',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              month,
              style: textTheme.labelSmall?.copyWith(color: AppColors.green800),
            ),
          ),
        ],
      ),
    );
  }
}
