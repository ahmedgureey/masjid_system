import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/prayer_schedule.dart';

/// Source of daily prayer times.
///
/// Today: [MockPrayerTimesRepository] (sample values, NOT real times).
/// Later: an implementation that calculates times from the mosque's
/// coordinates (`Mosque.latitude/longitude`), local timezone and configured
/// calculation method, and/or reads administrator-entered Iqamah times from
/// the backend, replaces it in [prayerTimesRepositoryProvider].
abstract interface class PrayerTimesRepository {
  /// Schedule for the calendar day of [date], or null if none is available.
  Future<DailyPrayerSchedule?> getSchedule(DateTime date);
}

/// MOCK — clearly identified sample data for building the UI.
///
/// These are NOT the prayer times of Masjid Al-Ikhlas or of any location.
/// Every schedule is tagged [PrayerScheduleSource.mock] so the screen shows
/// a warning. Asr and Isha deliberately have no Iqamah to exercise the
/// "not set" state.
class MockPrayerTimesRepository implements PrayerTimesRepository {
  const MockPrayerTimesRepository();

  static const Map<Prayer, (int, int)> _adhan = {
    Prayer.fajr: (4, 50),
    Prayer.dhuhr: (12, 10),
    Prayer.asr: (15, 30),
    Prayer.maghrib: (18, 15),
    Prayer.isha: (19, 30),
  };

  static const Map<Prayer, (int, int)> _iqamah = {
    Prayer.fajr: (5, 10),
    Prayer.dhuhr: (12, 30),
    Prayer.maghrib: (18, 20),
  };

  static const (int, int) _sunrise = (6, 5);

  @override
  Future<DailyPrayerSchedule?> getSchedule(DateTime date) async {
    final day = dateOnly(date);
    DateTime at((int, int) hm) =>
        DateTime(day.year, day.month, day.day, hm.$1, hm.$2);
    return DailyPrayerSchedule(
      date: day,
      adhan: {for (final e in _adhan.entries) e.key: at(e.value)},
      iqamah: {for (final e in _iqamah.entries) e.key: at(e.value)},
      sunrise: at(_sunrise),
      source: PrayerScheduleSource.mock,
    );
  }
}

final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>(
  (ref) => const MockPrayerTimesRepository(),
);

/// Schedule for one day. The key is normalised to midnight by callers
/// ([dateOnly]) so the screen asks for a new day automatically after
/// midnight.
final prayerScheduleProvider =
    FutureProvider.family<DailyPrayerSchedule?, DateTime>(
      (ref, date) =>
          ref.watch(prayerTimesRepositoryProvider).getSchedule(dateOnly(date)),
    );
