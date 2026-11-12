import '../models/mosque_event.dart';

/// Maps [MosqueEvent] to and from the JSON stored on the device.
///
/// Kept out of the model for the same reason as [MosqueJson]: the model
/// should not know how it is stored. The key names match the column names a
/// future `events` table would use, so moving this collection to Supabase is
/// a change of destination rather than a change of shape.
///
/// Reading is deliberately forgiving. A row written by a newer build, or one
/// damaged by a half-finished write, must cost the user that single entry at
/// worst — never the ability to open the calendar. [fromJson] returns null
/// for anything it cannot make sense of, and callers drop it.
abstract final class EventJson {
  static Map<String, dynamic> toJson(MosqueEvent e) => {
    'id': e.id,
    'title': e.title,
    'description': e.description,
    'category': e.category.name,
    'start': e.start.toIso8601String(),
    'end': e.end?.toIso8601String(),
    'location': e.location,
    'organizer': e.organizer,
    'image_url': e.imageUrl,
    'status': e.status.name,
    'registration_details': e.registration?.details,
    'is_sample': e.isSample,
  };

  static MosqueEvent? fromJson(Map<String, dynamic> row) {
    final id = row['id'];
    final start = _date(row['start']);
    // Without an id there is nothing to update or delete later, and without a
    // start the event cannot be placed on the calendar. Everything else has a
    // usable default.
    if (id is! String || id.isEmpty || start == null) return null;

    final details = row['registration_details'];
    return MosqueEvent(
      id: id,
      title: _string(row['title']) ?? '',
      description: _string(row['description']) ?? '',
      category: _enum(EventCategory.values, row['category']) ??
          EventCategory.other,
      start: start,
      end: _date(row['end']),
      location: _string(row['location']) ?? '',
      organizer: _string(row['organizer']),
      imageUrl: _string(row['image_url']),
      status:
          _enum(EventStatus.values, row['status']) ?? EventStatus.scheduled,
      registration: details is String && details.trim().isNotEmpty
          ? EventRegistration(details: details)
          : null,
      isSample: row['is_sample'] == true,
    );
  }

  /// The rows that parse, in order. Unreadable rows are skipped silently —
  /// see the note on [fromJson].
  static List<MosqueEvent> listFrom(Iterable<Map<String, dynamic>> rows) =>
      rows.map(fromJson).whereType<MosqueEvent>().toList();

  static List<Map<String, dynamic>> listTo(Iterable<MosqueEvent> events) =>
      events.map(toJson).toList();

  static String? _string(Object? v) => v is String ? v : null;

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v) : null;

  /// Unknown enum values become null so the caller can fall back, rather than
  /// throwing on a value a newer build wrote.
  static T? _enum<T extends Enum>(List<T> values, Object? v) {
    if (v is! String) return null;
    for (final value in values) {
      if (value.name == v) return value;
    }
    return null;
  }
}
