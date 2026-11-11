import 'package:flutter/foundation.dart';

import '../../../core/utils/hijri_date.dart';

/// Important Islamic dates shown on the calendar.
enum IslamicOccasionType {
  islamicNewYear(1, 1),
  ashura(1, 10),
  ramadanStart(9, 1),
  eidAlFitr(10, 1),
  dayOfArafah(12, 9),
  eidAlAdha(12, 10);

  const IslamicOccasionType(this.hijriMonth, this.hijriDay);

  final int hijriMonth;
  final int hijriDay;
}

/// Whether a date is a calculation or confirmed for the local community.
enum OccasionDateStatus {
  /// Calculated (tabular calendar). May differ by 1–2 days from moon
  /// sighting. The only status produced in this frontend phase.
  estimated,

  /// Announced by the mosque / local religious authority (future: set by an
  /// administrator in the backend).
  confirmed,
}

@immutable
class IslamicOccasion {
  const IslamicOccasion({
    required this.type,
    required this.hijri,
    required this.date,
    required this.status,
  });

  final IslamicOccasionType type;
  final HijriDate hijri;

  /// Gregorian day (local midnight).
  final DateTime date;
  final OccasionDateStatus status;

  bool get isEstimated => status == OccasionDateStatus.estimated;
}
