import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/utils/calendar_utils.dart';
import 'package:masjid_management/core/utils/hijri_date.dart';

void main() {
  group('CalendarUtils', () {
    test('days in month incl. leap years', () {
      expect(CalendarUtils.daysInMonth(2026, 2), 28);
      expect(CalendarUtils.daysInMonth(2028, 2), 29);
      expect(CalendarUtils.daysInMonth(2100, 2), 28);
      expect(CalendarUtils.daysInMonth(2000, 2), 29);
      expect(CalendarUtils.daysInMonth(2026, 11), 30);
      expect(CalendarUtils.daysInMonth(2026, 12), 31);
    });

    test('addMonths crosses year boundaries', () {
      expect(
        CalendarUtils.addMonths(DateTime(2026, 12, 31), 1),
        DateTime(2027),
      );
      expect(
        CalendarUtils.addMonths(DateTime(2027, 1, 15), -1),
        DateTime(2026, 12),
      );
      expect(CalendarUtils.addMonths(DateTime(2026, 11), 14), DateTime(2028));
    });

    test('weekday order starts at the chosen weekday', () {
      expect(CalendarUtils.weekdayOrder(DateTime.saturday), [
        6,
        7,
        1,
        2,
        3,
        4,
        5,
      ]);
      expect(CalendarUtils.weekdayOrder(DateTime.sunday), [
        7,
        1,
        2,
        3,
        4,
        5,
        6,
      ]);
      expect(CalendarUtils.firstWeekdayFor('so'), DateTime.saturday);
      expect(CalendarUtils.firstWeekdayFor('en'), DateTime.sunday);
    });

    test('November 2026 grid: 1 Nov is a Sunday', () {
      // Saturday-first: Sunday is column 2 → one leading blank.
      final sat = CalendarUtils.monthGrid(
        2026,
        11,
        firstWeekday: DateTime.saturday,
      );
      expect(sat.length % 7, 0);
      expect(sat[0], isNull);
      expect(sat[1], DateTime(2026, 11, 1));
      expect(sat.nonNulls.length, 30);
      expect(sat.nonNulls.last, DateTime(2026, 11, 30));
      // Sunday-first: no leading blank.
      final sun = CalendarUtils.monthGrid(
        2026,
        11,
        firstWeekday: DateTime.sunday,
      );
      expect(sun[0], DateTime(2026, 11, 1));
      // Every cell sits under its weekday column.
      final order = CalendarUtils.weekdayOrder(DateTime.saturday);
      for (var i = 0; i < sat.length; i++) {
        final d = sat[i];
        if (d != null) expect(d.weekday, order[i % 7]);
      }
    });

    test('February 2026 Sunday-first fits exactly four rows', () {
      // 1 Feb 2026 is a Sunday and the month has 28 days.
      final grid = CalendarUtils.monthGrid(
        2026,
        2,
        firstWeekday: DateTime.sunday,
      );
      expect(grid.length, 28);
      expect(grid.every((d) => d != null), isTrue);
    });
  });

  group('HijriDate (tabular estimate)', () {
    test('round trip over several years', () {
      final day = DateTime(2024);
      for (var i = 0; i < 365 * 4; i += 7) {
        final d = DateTime(day.year, day.month, day.day + i);
        expect(HijriDate.fromGregorian(d).toGregorian(), d);
      }
    });

    test('consecutive days advance by one Hijri day', () {
      final a = HijriDate.fromGregorian(DateTime(2026, 11, 11));
      final b = HijriDate.fromGregorian(DateTime(2026, 11, 12));
      if (a.day < a.monthLength) {
        expect(b, HijriDate(a.year, a.month, a.day + 1));
      } else {
        expect(b.day, 1);
      }
    });

    // Published Umm al-Qura dates; the tabular estimate must stay within
    // ±2 days (it is never presented as official).
    final anchors = <String, (HijriDate, DateTime)>{
      '1 Muharram 1446': (const HijriDate(1446, 1, 1), DateTime(2024, 7, 7)),
      '1 Shawwal 1445': (const HijriDate(1445, 10, 1), DateTime(2024, 4, 10)),
      '10 Dhu al-Hijjah 1445': (
        const HijriDate(1445, 12, 10),
        DateTime(2024, 6, 16),
      ),
      '1 Ramadan 1447': (const HijriDate(1447, 9, 1), DateTime(2026, 2, 18)),
    };
    for (final MapEntry(key: name, value: (hijri, official))
        in anchors.entries) {
      test('$name is within 2 days of Umm al-Qura', () {
        final diff = hijri.toGregorian().difference(official).inHours / 24;
        expect(diff.abs(), lessThanOrEqualTo(2));
      });
    }

    test('month lengths are 29 or 30', () {
      for (var m = 1; m <= 12; m++) {
        expect([29, 30], contains(HijriDate(1448, m, 1).monthLength));
      }
    });
  });
}
