import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/hijri_date.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/event_permissions.dart';
import '../data/events_repository.dart';
import '../data/islamic_dates_repository.dart';
import '../models/event_labels.dart';
import '../models/islamic_occasion.dart';
import '../models/mosque_event.dart';
import '../widgets/event_card.dart';
import '../widgets/month_calendar.dart';

/// Estimated Hijri date text, always marked as an estimate.
String approxHijri(DateTime day, String lang, AppLocalizations l10n) {
  final h = HijriDate.fromGregorian(day);
  return l10n.calendarHijriApprox(
    AppDateFormatter.hijriDate(h.year, h.month, h.day, locale: lang),
  );
}

/// "Kalandarka Masaajidka" — month grid, estimated Islamic occasions and the
/// event list with filters and per-day selection.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _month = CalendarUtils.monthStart(_now);
  DateTime? _selected;
  EventFilter _filter = EventFilter.upcoming;

  DateTime get _now => ref.read(clockProvider).value ?? DateTime.now();

  void _changeMonth(int delta) => setState(() {
    _month = CalendarUtils.addMonths(_month, delta);
    _selected = null;
  });

  void _goToToday(DateTime today) => setState(() {
    _month = CalendarUtils.monthStart(today);
    _selected = CalendarUtils.dateOnly(today);
  });

  void _select(DateTime day) => setState(() {
    _selected = _selected != null && CalendarUtils.isSameDay(_selected!, day)
        ? null
        : day;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canManage = ref.watch(canManageEventsProvider);
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppTopBar(title: l10n.calendarTitle),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.pushIfCurrent(AppRoutes.newEvent),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.eventAdd),
            )
          : null,
      body: SafeArea(
        top: false,
        child: eventsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(eventsProvider)),
          data: (events) => _body(context, events, canManage),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, List<MosqueEvent> events, bool canManage) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final lang = ref.watch(localeProvider).languageCode;
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final today = CalendarUtils.dateOnly(now);
    final mosque = ref.watch(mosqueProvider).value;
    final occasions =
        ref.watch(monthOccasionsProvider(_month)).value ?? const [];

    final eventDays = <DateTime>{
      for (final e in events)
        for (
          var d = CalendarUtils.dateOnly(e.start);
          !d.isAfter(CalendarUtils.dateOnly(e.effectiveEnd));
          d = DateTime(d.year, d.month, d.day + 1)
        )
          d,
    };
    final visible = filterEvents(
      events,
      filter: _filter,
      now: now,
      day: _selected,
    );
    final isCurrentView =
        CalendarUtils.isSameDay(_month, CalendarUtils.monthStart(today)) &&
        _selected != null &&
        CalendarUtils.isSameDay(_selected!, today);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space4,
        96, // room for the floating button
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mosque != null)
                  Text(
                    mosque.name.resolve(lang),
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                _infoLine(
                  Icons.calendar_today_outlined,
                  AppDateFormatter.fullDate(now, locale: lang),
                ),
                _infoLine(
                  Icons.nightlight_outlined,
                  approxHijri(now, lang, l10n),
                  key: const Key('calendarTodayHijri'),
                ),
              ],
            ),
          ),
          if (canManage) ...[
            const SizedBox(height: AppSpacing.space3),
            _notice(
              Icons.info_outline_rounded,
              AppColors.info,
              l10n.eventsAuthNotice,
              AppCardVariant.tinted,
            ),
          ],
          const SizedBox(height: AppSpacing.space3),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.space3),
            child: Column(
              children: [
                _MonthHeader(
                  month: _month,
                  lang: lang,
                  onPrevious: () => _changeMonth(-1),
                  onNext: () => _changeMonth(1),
                ),
                TextButton.icon(
                  key: const Key('calendarTodayButton'),
                  onPressed: isCurrentView ? null : () => _goToToday(today),
                  icon: const Icon(Icons.today_rounded, size: 18),
                  label: Text(l10n.calendarToday),
                ),
                const SizedBox(height: AppSpacing.space2),
                MonthCalendar(
                  month: _month,
                  today: today,
                  selected: _selected,
                  languageCode: lang,
                  eventDays: eventDays,
                  occasionDays: {for (final o in occasions) o.date},
                  onSelect: _select,
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  l10n.calendarHijriNote,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          if (occasions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space4),
            SectionHeader(title: l10n.calendarOccasionsTitle),
            for (final o in occasions) _OccasionTile(occasion: o, lang: lang),
          ],
          if (events.any((e) => e.isSample)) ...[
            const SizedBox(height: AppSpacing.space4),
            _notice(
              Icons.science_outlined,
              AppColors.gold800,
              '${l10n.eventsMockTitle}\n${l10n.eventsMockMessage}',
              AppCardVariant.gold,
              key: const Key('eventsMockNotice'),
            ),
          ],
          const SizedBox(height: AppSpacing.space4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in EventFilter.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.space2,
                    ),
                    child: ChoiceChip(
                      key: ValueKey('filter-${f.name}'),
                      label: Text(f.label(l10n)),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selected == null
                      ? _filter.listTitle(l10n)
                      : l10n.eventsOnDate(
                          AppDateFormatter.fullDate(_selected!, locale: lang),
                        ),
                  key: const Key('eventsListTitle'),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_selected != null)
                TextButton(
                  onPressed: () => setState(() => _selected = null),
                  child: Text(l10n.eventsClearDate),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          if (visible.isEmpty)
            EmptyState(
              icon: Icons.event_busy_rounded,
              title: l10n.eventsEmptyTitle,
              message: l10n.eventsEmptyMessage,
            )
          else
            for (final e in visible)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: EventCard(
                  key: ValueKey('event-${e.id}'),
                  event: e,
                  now: now,
                  languageCode: lang,
                  onTap: () =>
                      context.pushIfCurrent(AppRoutes.eventDetails(e.id)),
                ),
              ),
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String text, {Key? key}) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.space1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.neutral500),
        const SizedBox(width: AppSpacing.space2),
        Expanded(
          child: Text(
            text,
            key: key,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.neutral600),
          ),
        ),
      ],
    ),
  );

  Widget _notice(
    IconData icon,
    Color color,
    String text,
    AppCardVariant variant, {
    Key? key,
  }) => AppCard(
    key: key,
    variant: variant,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: AppSpacing.space3),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: color),
          ),
        ),
      ],
    ),
  );
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.lang,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final String lang;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final first = HijriDate.fromGregorian(month);
    final last = HijriDate.fromGregorian(
      DateTime(month.year, month.month + 1, 0),
    );
    String name(HijriDate h) =>
        AppDateFormatter.hijriMonth(h.month, locale: lang);
    final hijriSpan = first.year == last.year
        ? (first.month == last.month
              ? '${name(first)} ${first.year}'
              : '${name(first)} – ${name(last)} ${first.year}')
        : '${name(first)} ${first.year} – ${name(last)} ${last.year}';

    return Row(
      children: [
        IconButton(
          key: const Key('calendarPrevMonth'),
          tooltip: l10n.calendarPrevMonth,
          onPressed: onPrevious,
          icon: const Icon(
            // Material chevrons mirror automatically in right-to-left.
            Icons.chevron_left_rounded,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                AppDateFormatter.monthYear(month, locale: lang),
                key: const Key('calendarMonthTitle'),
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.green800,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                l10n.calendarHijriApprox(hijriSpan),
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          key: const Key('calendarNextMonth'),
          tooltip: l10n.calendarNextMonth,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _OccasionTile extends StatelessWidget {
  const _OccasionTile({required this.occasion, required this.lang});

  final IslamicOccasion occasion;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final h = occasion.hijri;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.space3),
        child: Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.gold600),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    occasion.type.label(l10n),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${AppDateFormatter.fullDate(occasion.date, locale: lang)}'
                    ' · '
                    '${AppDateFormatter.hijriDate(h.year, h.month, h.day, locale: lang)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            occasion.isEstimated
                ? StatusChip(
                    label: l10n.occasionEstimated,
                    type: StatusType.warning,
                  )
                : StatusChip(
                    label: l10n.occasionConfirmed,
                    type: StatusType.success,
                    icon: Icons.verified_outlined,
                  ),
          ],
        ),
      ),
    );
  }
}
