import 'package:flutter/foundation.dart';

import '../../../core/utils/calendar_utils.dart';

/// Event categories (mirrors a future `events.category` column).
enum EventCategory {
  quranClasses,
  lectures,
  religiousLessons,
  communityMeetings,
  childrenPrograms,
  youthPrograms,
  ramadanPrograms,
  eidCelebrations,
  other,
}

/// Status set by an administrator. Timing (upcoming / ongoing / ended) is
/// derived from the clock, see [MosqueEvent.timingAt].
enum EventStatus { scheduled, postponed, cancelled }

/// Time-based state of a scheduled event.
enum EventTiming { upcoming, ongoing, ended }

/// Optional registration information.
@immutable
class EventRegistration {
  const EventRegistration({required this.details});

  /// How to register (free text entered by an administrator).
  final String details;

  @override
  bool operator ==(Object other) =>
      other is EventRegistration && other.details == details;

  @override
  int get hashCode => details.hashCode;
}

/// A mosque event. Mirrors a future `events` table; [isSample] marks mock
/// data so the UI can label it.
@immutable
class MosqueEvent {
  const MosqueEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.start,
    this.end,
    required this.location,
    this.organizer,
    this.imageUrl,
    this.status = EventStatus.scheduled,
    this.registration,
    this.isSample = false,
  });

  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final DateTime start;

  /// Optional end; when null the event is treated as a point in time.
  final DateTime? end;
  final String location;
  final String? organizer;
  final String? imageUrl;
  final EventStatus status;
  final EventRegistration? registration;

  /// True for clearly identified mock data.
  final bool isSample;

  DateTime get effectiveEnd => end ?? start;

  /// Whether the event takes place (at least partly) on [day].
  bool occursOn(DateTime day) {
    final d = CalendarUtils.dateOnly(day);
    return !d.isBefore(CalendarUtils.dateOnly(start)) &&
        !d.isAfter(CalendarUtils.dateOnly(effectiveEnd));
  }

  EventTiming timingAt(DateTime now) {
    if (now.isBefore(start)) return EventTiming.upcoming;
    if (now.isBefore(effectiveEnd)) return EventTiming.ongoing;
    return EventTiming.ended;
  }

  /// Upcoming or still running at [now].
  bool isUpcomingAt(DateTime now) => timingAt(now) != EventTiming.ended;

  MosqueEvent copyWith({
    String? id,
    String? title,
    String? description,
    EventCategory? category,
    DateTime? start,
    DateTime? Function()? end,
    String? location,
    String? Function()? organizer,
    String? Function()? imageUrl,
    EventStatus? status,
    EventRegistration? Function()? registration,
    bool? isSample,
  }) {
    return MosqueEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      start: start ?? this.start,
      end: end != null ? end() : this.end,
      location: location ?? this.location,
      organizer: organizer != null ? organizer() : this.organizer,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      status: status ?? this.status,
      registration: registration != null ? registration() : this.registration,
      isSample: isSample ?? this.isSample,
    );
  }
}

/// List filters on the calendar screen.
enum EventFilter {
  all,
  upcoming,
  past,
  quranClasses,
  lectures,
  communityMeetings,
  islamicOccasions;

  bool matches(MosqueEvent e, DateTime now) => switch (this) {
    EventFilter.all => true,
    EventFilter.upcoming => e.isUpcomingAt(now),
    EventFilter.past => !e.isUpcomingAt(now),
    EventFilter.quranClasses => e.category == EventCategory.quranClasses,
    EventFilter.lectures =>
      e.category == EventCategory.lectures ||
          e.category == EventCategory.religiousLessons,
    EventFilter.communityMeetings =>
      e.category == EventCategory.communityMeetings,
    EventFilter.islamicOccasions =>
      e.category == EventCategory.ramadanPrograms ||
          e.category == EventCategory.eidCelebrations,
  };
}

/// Pure list logic: events matching [filter] (and [day] when given),
/// sorted by start — newest first for [EventFilter.past], else oldest first.
List<MosqueEvent> filterEvents(
  Iterable<MosqueEvent> events, {
  required EventFilter filter,
  required DateTime now,
  DateTime? day,
}) {
  final result = events
      .where((e) => filter.matches(e, now) && (day == null || e.occursOn(day)))
      .toList();
  result.sort(
    (a, b) => filter == EventFilter.past
        ? b.start.compareTo(a.start)
        : a.start.compareTo(b.start),
  );
  return result;
}
