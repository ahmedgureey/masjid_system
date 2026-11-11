import 'package:intl/intl.dart';

/// Date and time formatting helpers used across features.
///
/// `intl` has no Somali date symbols, so Somali month and weekday names are
/// provided here. Arabic and English use `intl` (date symbols are loaded by
/// the Material localizations delegate). Hijri dates are added with the
/// prayer-times feature.
abstract final class AppDateFormatter {
  static const List<String> _somaliMonths = [
    'Janaayo',
    'Febraayo',
    'Maarso',
    'Abriil',
    'Maajo',
    'Juun',
    'Luulyo',
    'Ogosto',
    'Sebtembar',
    'Oktoobar',
    'Nofembar',
    'Desembar',
  ];

  /// Index 0 = Monday (DateTime.monday == 1).
  static const List<String> _somaliWeekdays = [
    'Isniin',
    'Talaado',
    'Arbaco',
    'Khamiis',
    'Jimce',
    'Sabti',
    'Axad',
  ];

  static bool _isSomali(String? locale) =>
      locale != null && locale.startsWith('so');

  /// Returns [locale] if `intl` has date symbols for it, otherwise English.
  /// (`localeExists` throws when date data is not initialized yet.)
  static String? _intlLocale(String? locale) {
    if (locale == null) return null;
    try {
      return DateFormat.localeExists(locale) ? locale : 'en';
    } on Exception {
      return 'en';
    }
  }

  /// e.g. "Wednesday, November 11, 2026" · "Arbaco, 11 Nofembar 2026".
  static String fullDate(DateTime date, {String? locale}) {
    if (_isSomali(locale)) {
      return '${_somaliWeekdays[date.weekday - 1]}, '
          '${date.day} ${_somaliMonths[date.month - 1]} ${date.year}';
    }
    return DateFormat.yMMMMEEEEd(_intlLocale(locale)).format(date);
  }

  /// e.g. "Wed 11 Nov" · "Arb 11 Nof".
  static String shortDate(DateTime date, {String? locale}) {
    if (_isSomali(locale)) {
      return '${_somaliWeekdays[date.weekday - 1].substring(0, 3)} '
          '${date.day} ${_somaliMonths[date.month - 1].substring(0, 3)}';
    }
    return DateFormat('EEE d MMM', _intlLocale(locale)).format(date);
  }

  /// Time following the device 12/24-hour preference.
  static String time(DateTime time, {bool use24h = false, String? locale}) {
    final intlLocale = _isSomali(locale) ? 'en' : _intlLocale(locale);
    return (use24h ? DateFormat.Hm(intlLocale) : DateFormat.jm(intlLocale))
        .format(time);
  }
}
