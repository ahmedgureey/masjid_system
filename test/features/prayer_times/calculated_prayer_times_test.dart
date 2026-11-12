import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/prayer_times/data/calculated_prayer_times_repository.dart';
import 'package:masjid_management/features/prayer_times/models/prayer_schedule.dart';

/// Somalia is UTC+3 all year (no daylight saving), so the offset is pinned
/// rather than taken from the machine running the tests.
const _eat = Duration(hours: 3);

const _repo = CalculatedPrayerTimesRepository(utcOffset: _eat);

/// "HH:mm" of [time], which the repository has already placed in [_eat].
String _hhmm(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';

/// Minutes between two times on the same day.
int _minutesBetween(DateTime from, DateTime to) =>
    to.difference(from).inMinutes;

void main() {
  group('Mogadishu times match a published timetable', () {
    // Reference: Al Adhan API for 2.0469 N, 45.3182 E on 16 November 2026,
    // Muslim World League method, Shafi'i Asr, Africa/Mogadishu. Checked
    // while writing this: Fajr 04:30, Sunrise 05:43, Dhuhr 11:43,
    // Asr 15:07, Maghrib 17:44, Isha 18:53.
    //
    // One minute of tolerance: published tables round, and rounding at a
    // different point in the calculation moves a time by a minute without
    // either answer being wrong.
    late DailyPrayerSchedule schedule;

    setUp(() async {
      schedule = (await _repo.getSchedule(DateTime(2026, 11, 16)))!;
    });

    /// Compares the clock reading, not the instant.
    ///
    /// Given a utcOffset the package returns UTC-flagged times with the
    /// offset already applied, so subtracting a local DateTime from one
    /// would measure the test machine's own timezone instead of any drift.
    void expectWithin1Minute(DateTime actual, String expected, String label) {
      final parts = expected.split(':');
      final want = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      final got = actual.hour * 60 + actual.minute;
      expect(
        (got - want).abs() <= 1,
        isTrue,
        reason: '$label was ${_hhmm(actual)}, expected about $expected',
      );
    }

    test('Fajr', () =>
        expectWithin1Minute(schedule.adhan[Prayer.fajr]!, '04:30', 'Fajr'));
    test('sunrise', () =>
        expectWithin1Minute(schedule.sunrise!, '05:43', 'Sunrise'));
    test('Dhuhr', () =>
        expectWithin1Minute(schedule.adhan[Prayer.dhuhr]!, '11:43', 'Dhuhr'));
    test('Asr', () =>
        expectWithin1Minute(schedule.adhan[Prayer.asr]!, '15:07', 'Asr'));
    test('Maghrib', () => expectWithin1Minute(
      schedule.adhan[Prayer.maghrib]!,
      '17:44',
      'Maghrib',
    ));
    test('Isha', () =>
        expectWithin1Minute(schedule.adhan[Prayer.isha]!, '18:53', 'Isha'));
  });

  group('The result is internally consistent', () {
    late DailyPrayerSchedule schedule;

    setUp(() async {
      schedule = (await _repo.getSchedule(DateTime(2026, 11, 16)))!;
    });

    test('all five prayers are present and on the requested day', () {
      expect(schedule.isComplete, isTrue);
      expect(schedule.date, DateTime(2026, 11, 16));
      for (final entry in schedule.adhan.entries) {
        expect(
          DateTime(entry.value.year, entry.value.month, entry.value.day),
          DateTime(2026, 11, 16),
          reason: '${entry.key} fell on another day',
        );
      }
    });

    test('they run in order through the day', () {
      final times = [
        schedule.adhan[Prayer.fajr]!,
        schedule.sunrise!,
        schedule.adhan[Prayer.dhuhr]!,
        schedule.adhan[Prayer.asr]!,
        schedule.adhan[Prayer.maghrib]!,
        schedule.adhan[Prayer.isha]!,
      ];
      for (var i = 1; i < times.length; i++) {
        expect(
          times[i].isAfter(times[i - 1]),
          isTrue,
          reason: '${_hhmm(times[i])} did not follow ${_hhmm(times[i - 1])}',
        );
      }
    });

    test('Dhuhr sits midway between sunrise and sunset', () {
      // Solar noon by definition. A good check that the longitude and the
      // equation of time are both being applied.
      final sunrise = schedule.sunrise!;
      final maghrib = schedule.adhan[Prayer.maghrib]!;
      final midpoint = sunrise.add(
        Duration(minutes: _minutesBetween(sunrise, maghrib) ~/ 2),
      );
      expect(
        schedule.adhan[Prayer.dhuhr]!.difference(midpoint).inMinutes.abs() <= 2,
        isTrue,
        reason: 'Dhuhr ${_hhmm(schedule.adhan[Prayer.dhuhr]!)} is not solar '
            'noon (${_hhmm(midpoint)})',
      );
    });

    test('it is no longer flagged as sample data', () {
      expect(schedule.source, PrayerScheduleSource.calculated);
      expect(schedule.isMock, isFalse);
    });

    test('Iqamah is empty — a mosque sets it, the sun does not', () {
      expect(schedule.iqamah, isEmpty);
    });
  });

  group('It tracks the date and the place', () {
    test('a different day gives different times', () async {
      final november = (await _repo.getSchedule(DateTime(2026, 11, 16)))!;
      final june = (await _repo.getSchedule(DateTime(2026, 6, 16)))!;
      expect(
        june.adhan[Prayer.maghrib],
        isNot(november.adhan[Prayer.maghrib]),
      );
    });

    test('near the equator the day length barely moves', () async {
      // Mogadishu is 2 degrees north, so sunrise-to-sunset stays close to
      // twelve hours all year. A calculation that drifted far from this
      // would mean the latitude was being mishandled.
      for (final month in [1, 4, 7, 10]) {
        final s = (await _repo.getSchedule(DateTime(2026, month, 15)))!;
        final minutes = _minutesBetween(
          s.sunrise!,
          s.adhan[Prayer.maghrib]!,
        );
        expect(
          minutes,
          inInclusiveRange(11 * 60 + 30, 12 * 60 + 30),
          reason: 'day length in month $month was $minutes minutes',
        );
      }
    });

    test('a mosque further west gets later times', () async {
      // Hargeisa is about 1.2 degrees of longitude west of Mogadishu, which
      // is roughly five minutes of solar time.
      const hargeisa = CalculatedPrayerTimesRepository(
        latitude: 9.5600,
        longitude: 44.0650,
        utcOffset: _eat,
      );
      final here = (await _repo.getSchedule(DateTime(2026, 11, 16)))!;
      final there = (await hargeisa.getSchedule(DateTime(2026, 11, 16)))!;
      expect(
        there.adhan[Prayer.dhuhr]!.isAfter(here.adhan[Prayer.dhuhr]!),
        isTrue,
      );
    });
  });
}
