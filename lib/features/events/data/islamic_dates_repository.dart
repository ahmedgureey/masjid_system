import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/hijri_date.dart';
import '../models/islamic_occasion.dart';

/// Source of important Islamic dates.
///
/// Today: [EstimatedIslamicDatesRepository] — every date is calculated and
/// marked [OccasionDateStatus.estimated].
/// Backend phase: an implementation that returns administrator-confirmed
/// dates (moon sighting / local announcement) where available and falls
/// back to estimates otherwise.
abstract interface class IslamicDatesRepository {
  /// Occasions whose Gregorian date lies in [from]..[to] (inclusive days).
  Future<List<IslamicOccasion>> occasionsBetween(DateTime from, DateTime to);
}

class EstimatedIslamicDatesRepository implements IslamicDatesRepository {
  const EstimatedIslamicDatesRepository();

  @override
  Future<List<IslamicOccasion>> occasionsBetween(
    DateTime from,
    DateTime to,
  ) async {
    final start = CalendarUtils.dateOnly(from);
    final end = CalendarUtils.dateOnly(to);
    final firstYear = HijriDate.fromGregorian(start).year;
    final lastYear = HijriDate.fromGregorian(end).year;
    final result = <IslamicOccasion>[];
    for (var year = firstYear; year <= lastYear; year++) {
      for (final type in IslamicOccasionType.values) {
        final hijri = HijriDate(year, type.hijriMonth, type.hijriDay);
        final date = hijri.toGregorian();
        if (date.isBefore(start) || date.isAfter(end)) continue;
        result.add(
          IslamicOccasion(
            type: type,
            hijri: hijri,
            date: date,
            status: OccasionDateStatus.estimated,
          ),
        );
      }
    }
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }
}

final islamicDatesRepositoryProvider = Provider<IslamicDatesRepository>(
  (ref) => const EstimatedIslamicDatesRepository(),
);

/// Occasions in the month starting at the given first-of-month key.
final monthOccasionsProvider =
    FutureProvider.family<List<IslamicOccasion>, DateTime>((ref, month) {
      final start = CalendarUtils.monthStart(month);
      final end = DateTime(start.year, start.month + 1, 0);
      return ref
          .watch(islamicDatesRepositoryProvider)
          .occasionsBetween(start, end);
    });
