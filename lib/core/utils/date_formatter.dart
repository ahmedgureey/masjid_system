import 'package:intl/intl.dart';

/// Date and time formatting helpers used across features.
///
/// Locales other than the default (`en_US`) require
/// `initializeDateFormatting()` from `package:intl/date_symbol_data_local.dart`
/// — this is added together with localization (English, Somali, Arabic).
/// Hijri dates are added with the prayer-times feature.
abstract final class AppDateFormatter {
  /// e.g. "Wednesday, November 11, 2026".
  static String fullDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }

  /// e.g. "Wed 11 Nov".
  static String shortDate(DateTime date, {String? locale}) {
    return DateFormat('EEE d MMM', locale).format(date);
  }

  /// Time following the device 12/24-hour preference.
  static String time(DateTime time, {bool use24h = false, String? locale}) {
    return (use24h ? DateFormat.Hm(locale) : DateFormat.jm(locale))
        .format(time);
  }
}
