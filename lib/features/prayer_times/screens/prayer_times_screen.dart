import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../mosque/data/mosque_repository.dart';
import '../../mosque/models/mosque.dart';
import '../application/next_prayer.dart';
import '../data/prayer_times_repository.dart';
import '../models/prayer_labels.dart';
import '../models/prayer_schedule.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_time_row.dart';

/// "Waqtiyada Salaadda" — today's five prayers, sunrise, the next prayer
/// and a live countdown.
///
/// The countdown is driven by [clockProvider] (one tick per second, disposed
/// by Riverpod with the screen). The day key passed to
/// [prayerScheduleProvider] is derived from the clock, so after midnight the
/// next day's schedule is requested automatically.
class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final today = dateOnly(now);
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final todayAsync = ref.watch(prayerScheduleProvider(today));
    final tomorrowSchedule = ref.watch(prayerScheduleProvider(tomorrow)).value;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.prayerTitle,
        actions: [
          IconButton(
            tooltip: l10n.prayerRefresh,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(prayerScheduleProvider),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: todayAsync.when(
          // Keep showing the previous values while a refresh is running.
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          loading: () => const AppLoadingIndicator(),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(prayerScheduleProvider)),
          data: (schedule) => _PrayerBody(
            now: now,
            schedule: schedule,
            tomorrow: tomorrowSchedule,
          ),
        ),
      ),
    );
  }
}

class _PrayerBody extends ConsumerWidget {
  const _PrayerBody({
    required this.now,
    required this.schedule,
    required this.tomorrow,
  });

  final DateTime now;
  final DailyPrayerSchedule? schedule;
  final DailyPrayerSchedule? tomorrow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final mosque = ref.watch(mosqueProvider).value;
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);
    String fmt(DateTime t) =>
        AppDateFormatter.time(t, use24h: use24h, locale: lang);

    final schedule = this.schedule;
    final hasSchedule = schedule != null && schedule.isComplete;
    final next = hasSchedule
        ? findNextPrayer(now: now, today: schedule, tomorrow: tomorrow)
        : null;
    final showArabic = lang != 'ar';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            mosque: mosque,
            lang: lang,
            dateText: AppDateFormatter.fullDate(now, locale: lang),
            hijriDate: hasSchedule ? schedule.hijriDate : null,
          ),
          if (!hasSchedule) ...[
            const SizedBox(height: AppSpacing.space6),
            EmptyState(
              icon: Icons.event_busy_rounded,
              title: l10n.prayerEmptyTitle,
              message: l10n.prayerEmptyMessage,
            ),
          ] else ...[
            if (schedule.isMock) ...[
              const SizedBox(height: AppSpacing.space3),
              const _MockNotice(),
            ],
            const SizedBox(height: AppSpacing.space4),
            NextPrayerCard(
              next: next,
              now: now,
              timeText: next == null ? null : fmt(next.time),
              showArabic: showArabic,
            ),
            const SizedBox(height: AppSpacing.space5),
            SectionHeader(title: l10n.prayerDailyTitle),
            for (final prayer in Prayer.values) ...[
              PrayerTimeRow(
                key: ValueKey('prayerRow_${prayer.name}'),
                icon: prayer.icon,
                name: prayer.label(l10n),
                arabicName: showArabic ? prayer.arabicName : null,
                adhanText: fmt(schedule.adhan[prayer]!),
                iqamahText: schedule.iqamah[prayer] == null
                    ? null
                    : fmt(schedule.iqamah[prayer]!),
                isNext:
                    next != null && !next.isTomorrow && next.prayer == prayer,
              ),
              const SizedBox(height: AppSpacing.space2),
            ],
            if (schedule.sunrise != null) ...[
              const SizedBox(height: AppSpacing.space3),
              PrayerTimeRow(
                key: const ValueKey('sunriseRow'),
                icon: Icons.wb_sunny_rounded,
                name: l10n.prayerSunrise,
                arabicName: showArabic ? 'الشروق' : null,
                adhanText: fmt(schedule.sunrise!),
                showIqamah: false,
                note: l10n.prayerSunriseNote,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Mosque name, location (or placeholder), Gregorian date and — only when
/// supplied by a reliable source — the Hijri date.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.mosque,
    required this.lang,
    required this.dateText,
    required this.hijriDate,
  });

  final Mosque? mosque;
  final String lang;
  final String dateText;
  final String? hijriDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final mosque = this.mosque;
    final location = mosque == null
        ? null
        : [mosque.district, mosque.city, mosque.country]
              .map((e) => e?.trim())
              .where((e) => e != null && e.isNotEmpty)
              .join(', ');
    final hasLocation = location != null && location.isNotEmpty;

    Widget line(IconData icon, String text, {Color? color, Key? key}) =>
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.space1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: color ?? AppColors.neutral500),
              const SizedBox(width: AppSpacing.space2),
              Expanded(
                child: Text(
                  text,
                  key: key,
                  style: textTheme.bodyMedium?.copyWith(
                    color: color ?? AppColors.neutral600,
                  ),
                ),
              ),
            ],
          ),
        );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mosque != null)
            Text(
              mosque.name.resolve(lang),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          line(
            Icons.place_outlined,
            hasLocation ? location : l10n.prayerLocationMissing,
            color: hasLocation ? null : AppColors.warning,
            key: const Key('prayerLocation'),
          ),
          line(Icons.calendar_today_outlined, dateText),
          if (hijriDate != null) line(Icons.nightlight_outlined, hijriDate!),
        ],
      ),
    );
  }
}

class _MockNotice extends StatelessWidget {
  const _MockNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      key: const Key('prayerMockNotice'),
      variant: AppCardVariant.gold,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.science_outlined, color: AppColors.gold800),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.prayerMockTitle,
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.gold800,
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  l10n.prayerMockMessage,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.gold800,
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
