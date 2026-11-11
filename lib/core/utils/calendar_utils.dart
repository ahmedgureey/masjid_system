/// Pure Gregorian calendar helpers (no UI). All dates are local and built
/// with the `DateTime(y, m, d)` constructor, which normalises overflowing
/// months/days and is not affected by daylight-saving hour shifts.
abstract final class CalendarUtils {
  /// Midnight of the calendar day of [date].
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// First day of the month of [date].
  static DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

  /// First day of the month [delta] months from the month of [date]
  /// (handles year boundaries: Dec + 1 → Jan of next year).
  static DateTime addMonths(DateTime date, int delta) =>
      DateTime(date.year, date.month + delta);

  /// 28–31, leap years included (day 0 of next month = last day).
  static int daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  /// First weekday of a calendar row for a language: Saturday for Somali and
  /// Arabic (week starts on Saturday in the Horn of Africa / Arab world),
  /// Sunday otherwise. Values follow [DateTime.monday]..[DateTime.sunday].
  static int firstWeekdayFor(String languageCode) => switch (languageCode) {
    'so' || 'ar' => DateTime.saturday,
    _ => DateTime.sunday,
  };

  /// Weekdays of one row, starting at [firstWeekday].
  static List<int> weekdayOrder(int firstWeekday) => [
    for (var i = 0; i < 7; i++) (firstWeekday - 1 + i) % 7 + 1,
  ];

  /// Cells of a month grid, row by row: `null` for padding before the first
  /// and after the last day, so the length is always a multiple of 7.
  static List<DateTime?> monthGrid(
    int year,
    int month, {
    required int firstWeekday,
  }) {
    final first = DateTime(year, month);
    final leading = (first.weekday - firstWeekday + 7) % 7;
    final days = daysInMonth(year, month);
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= days; d++) DateTime(year, month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }
}
