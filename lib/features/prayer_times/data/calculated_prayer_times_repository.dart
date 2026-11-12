import 'package:adhan/adhan.dart' as adhan;

import '../models/prayer_schedule.dart';
import 'prayer_times_repository.dart';

/// Real prayer times, calculated from the sun's position for a location.
///
/// Replaces the sample values the app shipped with. The calculation is done
/// on the device by the `adhan` package (the Dart port of Batoul Apps'
/// Adhan library), so the times are available offline and no prayer-time
/// service has to be trusted or paid for.
///
/// Settings, and why these ones:
///
/// * **Muslim World League** (Fajr 18°, Isha 17°). This is the method the
///   published Somali timetables use, and East African practice generally.
/// * **Shafi'i** for Asr (shadow length 1×, plus the object's noon shadow),
///   which is the madhab followed in Somalia. The Hanafi rule would put Asr
///   roughly 45 minutes later.
///
/// Times come back in the **device's** timezone. For a mosque and a
/// congregation in the same country — Somalia is a single zone, UTC+3 — that
/// is both correct and consistent with the countdown on the home screen,
/// which is measured against the device clock. A phone set to another
/// country's time would show that country's clock times for this mosque's
/// prayers; a timezone stored on the mosque profile would be the fix, and
/// there is no field for one yet.
///
/// Iqamah is deliberately absent. It is a decision each mosque makes — how
/// long after the adhan the congregation gathers — not something that can be
/// derived from the sun, so every prayer reads "not set" until an
/// administrator enters one.
class CalculatedPrayerTimesRepository implements PrayerTimesRepository {
  const CalculatedPrayerTimesRepository({
    this.latitude = mogadishuLatitude,
    this.longitude = mogadishuLongitude,
    this.utcOffset,
  });

  /// Mogadishu, used until the mosque profile has its own coordinates.
  ///
  /// A default is needed because prayer times are meaningless without a
  /// position, and refusing to show any until someone fills in the profile
  /// would be worse than showing the capital's. Somalia is small enough in
  /// longitude that the error elsewhere in the country is minutes: Hargeisa,
  /// at the far north-west, differs by roughly ten.
  static const double mogadishuLatitude = 2.0469;
  static const double mogadishuLongitude = 45.3182;

  final double latitude;
  final double longitude;

  /// Fixed offset to produce times in, instead of the device's own.
  ///
  /// Only used by tests, which must not depend on the machine's timezone.
  final Duration? utcOffset;

  @override
  Future<DailyPrayerSchedule?> getSchedule(DateTime date) async {
    final day = dateOnly(date);
    final times = adhan.PrayerTimes(
      adhan.Coordinates(latitude, longitude),
      adhan.DateComponents(day.year, day.month, day.day),
      _parameters,
      utcOffset: utcOffset,
    );

    return DailyPrayerSchedule(
      date: day,
      adhan: {
        Prayer.fajr: times.fajr,
        Prayer.dhuhr: times.dhuhr,
        Prayer.asr: times.asr,
        Prayer.maghrib: times.maghrib,
        Prayer.isha: times.isha,
      },
      sunrise: times.sunrise,
      source: PrayerScheduleSource.calculated,
    );
  }

  static adhan.CalculationParameters get _parameters =>
      adhan.CalculationMethod.muslim_world_league.getParameters()
        ..madhab = adhan.Madhab.shafi;
}
