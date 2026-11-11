/// Pure validation rules of the event form (UI-independent, unit tested).
library;

/// Errors for the event date/time fields.
enum EventDateTimeError { required, pastDate, endNotAfterStart }

/// Times are minutes since midnight on the event date.
///
/// - [date] and [startMinutes] are required.
/// - New events cannot be placed on a day before [today]; existing events
///   (editing) may keep a past date.
/// - When an end time is given it must be after the start time (same day).
abstract final class EventValidation {
  static EventDateTimeError? date(
    DateTime? date, {
    required DateTime today,
    required bool isNew,
  }) {
    if (date == null) return EventDateTimeError.required;
    final d = DateTime(date.year, date.month, date.day);
    final t = DateTime(today.year, today.month, today.day);
    if (isNew && d.isBefore(t)) return EventDateTimeError.pastDate;
    return null;
  }

  static EventDateTimeError? startTime(int? startMinutes) =>
      startMinutes == null ? EventDateTimeError.required : null;

  static EventDateTimeError? endTime(int? startMinutes, int? endMinutes) {
    if (endMinutes == null || startMinutes == null) return null;
    return endMinutes > startMinutes
        ? null
        : EventDateTimeError.endNotAfterStart;
  }
}
