import 'package:flutter/foundation.dart';

import '../models/prayer_schedule.dart';

/// The upcoming prayer relative to a given moment.
@immutable
class NextPrayer {
  const NextPrayer({
    required this.prayer,
    required this.time,
    required this.isTomorrow,
  });

  final Prayer prayer;

  /// Scheduled Adhan time.
  final DateTime time;

  /// True after Isha, when the next prayer is tomorrow's Fajr.
  final bool isTomorrow;

  /// Time left until [time], rounded UP to whole seconds so the display
  /// reaches 00:00:00 exactly at Adhan. Never negative.
  Duration remaining(DateTime now) {
    final ms = time.difference(now).inMilliseconds;
    if (ms <= 0) return Duration.zero;
    return Duration(seconds: (ms + 999) ~/ 1000);
  }

  @override
  bool operator ==(Object other) =>
      other is NextPrayer &&
      other.prayer == prayer &&
      other.time == time &&
      other.isTomorrow == isTomorrow;

  @override
  int get hashCode => Object.hash(prayer, time, isTomorrow);

  @override
  String toString() => 'NextPrayer($prayer, $time, tomorrow: $isTomorrow)';
}

/// Pure function: the first prayer whose Adhan is strictly after [now].
///
/// Looks in [today] first; after the last prayer of the day it moves to
/// [tomorrow]'s Fajr (midnight/next-day transition). Returns null when no
/// upcoming time is known (missing schedules).
NextPrayer? findNextPrayer({
  required DateTime now,
  required DailyPrayerSchedule? today,
  DailyPrayerSchedule? tomorrow,
}) {
  if (today != null) {
    for (final prayer in Prayer.values) {
      final time = today.adhan[prayer];
      if (time != null && time.isAfter(now)) {
        return NextPrayer(prayer: prayer, time: time, isTomorrow: false);
      }
    }
  }
  final fajr = tomorrow?.adhan[Prayer.fajr];
  if (fajr != null && fajr.isAfter(now)) {
    return NextPrayer(prayer: Prayer.fajr, time: fajr, isTomorrow: true);
  }
  return null;
}

/// Formats [duration] as HH:MM:SS (hours are not wrapped at 24).
String formatCountdown(Duration duration) {
  final d = duration.isNegative ? Duration.zero : duration;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
}
