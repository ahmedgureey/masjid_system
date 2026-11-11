import 'package:flutter/foundation.dart';

/// A Hijri date from the **tabular (arithmetic) Islamic calendar**.
///
/// IMPORTANT — ESTIMATE ONLY: the tabular calendar follows a fixed 30-year
/// cycle and does not use moon sighting. It usually matches the official
/// local date or differs by 1–2 days. The UI must always label values from
/// this class as approximate; officially confirmed dates (e.g. the start of
/// Ramadan) must come from an administrator / backend instead.
///
/// No package is used: the conversion is the standard civil-epoch algorithm
/// (epoch = Julian Day 1948440, Friday 16 July 622 Julian).
@immutable
class HijriDate {
  const HijriDate(this.year, this.month, this.day)
    : assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 30);

  /// Estimated Hijri date for the calendar day of [date].
  factory HijriDate.fromGregorian(DateTime date) {
    final jdn = _julianDay(date);
    var l = jdn - _epoch + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j =
        ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l =
        l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;
    return HijriDate(year, month, day);
  }

  final int year;
  final int month;
  final int day;

  static const int _epoch = 1948440;

  /// Julian Day Number of the calendar day of [date] (time ignored).
  static int _julianDay(DateTime date) =>
      DateTime.utc(
        date.year,
        date.month,
        date.day,
      ).difference(DateTime.utc(1970)).inDays +
      2440588;

  /// Estimated Gregorian (local midnight) date of this Hijri date.
  DateTime toGregorian() {
    final jdn =
        (11 * year + 3) ~/ 30 +
        354 * year +
        30 * month -
        (month - 1) ~/ 2 +
        day +
        _epoch -
        385;
    final utc = DateTime.utc(1970).add(Duration(days: jdn - 2440588));
    return DateTime(utc.year, utc.month, utc.day);
  }

  /// Number of days in this Hijri month in the tabular calendar.
  int get monthLength {
    if (month.isOdd) return 30;
    if (month < 12) return 29;
    return isLeapYear ? 30 : 29;
  }

  /// Leap years of the 30-year cycle (Dhu al-Hijjah has 30 days).
  bool get isLeapYear => (14 + 11 * year) % 30 < 11;

  @override
  bool operator ==(Object other) =>
      other is HijriDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'HijriDate($year-$month-$day)';
}
