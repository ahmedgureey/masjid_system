import 'package:intl/intl.dart';

/// Date and time formatting helpers used across features.
///
/// `intl` has no Somali date symbols, so Somali month and weekday names are
/// provided here. Arabic and English use `intl` (date symbols are loaded by
/// the Material localizations delegate). Hijri month names are provided
/// here for every language (see `HijriDate` for the estimate caveat).
abstract final class AppDateFormatter {
  /// Called once at start-up (after `initializeDateFormatting`).
  /// Design decision DD-03: Western digits (0–9) by default in every
  /// language, including Arabic, for times and dates.
  static void configure() {
    DateFormat.useNativeDigitsByDefaultFor('ar', false);
  }

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

  /// e.g. "November 2026" · "Nofembar 2026".
  static String monthYear(DateTime date, {String? locale}) {
    if (_isSomali(locale)) {
      return '${_somaliMonths[date.month - 1]} ${date.year}';
    }
    return DateFormat.yMMMM(_intlLocale(locale)).format(date);
  }

  static const List<String> _arabicWeekdaysShort = [
    'إثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
    'سبت',
    'أحد',
  ];

  /// Short weekday name for calendar column headers ([weekday] uses
  /// `DateTime.monday`..`DateTime.sunday`).
  static String weekdayShort(int weekday, {String? locale}) {
    if (_isSomali(locale)) return _somaliWeekdays[weekday - 1].substring(0, 3);
    if (locale != null && locale.startsWith('ar')) {
      return _arabicWeekdaysShort[weekday - 1];
    }
    // 2 Jan 2023 was a Monday.
    return DateFormat.E(_intlLocale(locale))
        .format(DateTime(2023, 1, weekday + 1));
  }

  static const Map<String, List<String>> _hijriMonths = {
    'so': [
      'Muxarram',
      'Safar',
      'Rabiicul Awwal',
      'Rabiicul Aakhir',
      'Jumaadal Uulaa',
      'Jumaadal Aakhira',
      'Rajab',
      'Shacbaan',
      'Ramadaan',
      'Shawwaal',
      'Dulqacda',
      'Dulxijja',
    ],
    'en': [
      'Muharram',
      'Safar',
      'Rabi al-Awwal',
      'Rabi al-Thani',
      'Jumada al-Ula',
      'Jumada al-Akhirah',
      'Rajab',
      'Shaban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qadah',
      'Dhu al-Hijjah',
    ],
    'ar': [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ],
  };

  static List<String> _hijriMonthNames(String? locale) =>
      _hijriMonths[locale?.split(RegExp('[-_]')).first] ?? _hijriMonths['en']!;

  /// Hijri month name (1–12).
  static String hijriMonth(int month, {String? locale}) =>
      _hijriMonthNames(locale)[month - 1];

  /// e.g. "1 Ramadaan 1448". Callers must label the value as an estimate
  /// unless it comes from a confirmed source.
  static String hijriDate(int year, int month, int day, {String? locale}) =>
      '$day ${hijriMonth(month, locale: locale)} $year';

  /// Time following the device 12/24-hour preference.
  static String time(DateTime time, {bool use24h = false, String? locale}) {
    final intlLocale = _isSomali(locale) ? 'en' : _intlLocale(locale);
    return (use24h ? DateFormat.Hm(intlLocale) : DateFormat.jm(intlLocale))
        .format(time);
  }
}
