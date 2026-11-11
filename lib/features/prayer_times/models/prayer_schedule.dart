import 'package:flutter/foundation.dart';

/// The five obligatory daily prayers, in chronological order.
/// Sunrise is deliberately NOT part of this enum.
enum Prayer {
  fajr('الفجر'),
  dhuhr('الظهر'),
  asr('العصر'),
  maghrib('المغرب'),
  isha('العشاء');

  const Prayer(this.arabicName);

  /// Arabic name, always shown right-to-left.
  final String arabicName;
}

/// Where a schedule came from. The UI warns the user unless the source is a
/// real one.
enum PrayerScheduleSource {
  /// Sample values for UI development. NOT real prayer times.
  mock,

  /// Calculated from the mosque's coordinates, timezone and method.
  calculated,

  /// Entered by a mosque administrator.
  mosqueConfigured,
}

/// Returns [date] at midnight (local), dropping the time of day.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Prayer times for one calendar day.
///
/// [adhan] and [iqamah] hold full local [DateTime]s on [date]. Iqamah times
/// are independent values — they are never derived from Adhan with a fixed
/// offset; a missing entry means "not set".
@immutable
class DailyPrayerSchedule {
  DailyPrayerSchedule({
    required DateTime date,
    required this.adhan,
    this.iqamah = const {},
    this.sunrise,
    this.hijriDate,
    required this.source,
  }) : date = dateOnly(date);

  final DateTime date;
  final Map<Prayer, DateTime> adhan;
  final Map<Prayer, DateTime> iqamah;
  final DateTime? sunrise;

  /// Formatted Hijri date, only when supplied by a reliable source.
  final String? hijriDate;
  final PrayerScheduleSource source;

  bool get isMock => source == PrayerScheduleSource.mock;

  /// True when all five Adhan times are known.
  bool get isComplete => Prayer.values.every(adhan.containsKey);
}
