import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/hijri_date.dart';

/// Key of the grid cell for [day] (used by tests).
Key calendarDayKey(DateTime day) =>
    ValueKey('day-${day.year}-${day.month}-${day.day}');

/// Monthly grid: seven weekday columns, today ringed in gold, the selected
/// day filled green, dots for events (green) and Islamic occasions (gold),
/// and the estimated Hijri day in small type.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.today,
    required this.selected,
    required this.languageCode,
    required this.eventDays,
    required this.occasionDays,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime today;
  final DateTime? selected;
  final String languageCode;

  /// Days (midnight) with at least one event.
  final Set<DateTime> eventDays;

  /// Days (midnight) with an Islamic occasion.
  final Set<DateTime> occasionDays;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final firstWeekday = CalendarUtils.firstWeekdayFor(languageCode);
    final order = CalendarUtils.weekdayOrder(firstWeekday);
    final cells = CalendarUtils.monthGrid(
      month.year,
      month.month,
      firstWeekday: firstWeekday,
    );
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            for (final weekday in order)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppDateFormatter.weekdayShort(
                        weekday,
                        locale: languageCode,
                      ),
                      style: textTheme.labelMedium?.copyWith(
                        color: weekday == DateTime.friday
                            ? AppColors.primary
                            : AppColors.neutral500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(child: _cell(context, cells[row * 7 + col])),
            ],
          ),
      ],
    );
  }

  Widget _cell(BuildContext context, DateTime? day) {
    if (day == null) return const SizedBox(height: 52);
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final isToday = CalendarUtils.isSameDay(day, today);
    final isSelected =
        selected != null && CalendarUtils.isSameDay(day, selected!);
    final hasEvent = eventDays.contains(day);
    final hasOccasion = occasionDays.contains(day);
    final hijri = HijriDate.fromGregorian(day);
    final foreground = isSelected ? AppColors.white : AppColors.darkText;

    return Semantics(
      button: true,
      selected: isSelected,
      label: AppDateFormatter.fullDate(day, locale: languageCode),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: isToday && !isSelected
                ? BorderSide(color: semantic.gold, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            key: calendarDayKey(day),
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: () => onSelect(day),
            child: SizedBox(
              height: 48,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${day.day}',
                        style: textTheme.bodyLarge?.copyWith(
                          color: foreground,
                          fontWeight: isToday || isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${hijri.day}',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: isSelected
                              ? AppColors.green100
                              : AppColors.neutral400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Dot(
                            visible: hasEvent,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primary,
                          ),
                          if (hasEvent && hasOccasion) const SizedBox(width: 2),
                          _Dot(visible: hasOccasion, color: semantic.gold),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.visible, required this.color});

  final bool visible;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox(width: 0, height: 5);
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
