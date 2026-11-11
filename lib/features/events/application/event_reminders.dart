import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mosque_event.dart';

/// Future event reminders (kept separate from the calendar UI).
///
/// Planned: "remind me before an event" (local notification), and push
/// notifications for new / rescheduled / cancelled events (backend). None
/// of this exists yet, so the only implementation reports itself as
/// unavailable and the UI shows a disabled button — never a success state.
abstract interface class EventReminderService {
  /// False until a real reminder mechanism is implemented and tested.
  bool get isAvailable;

  Future<void> scheduleReminder(MosqueEvent event, Duration before);
}

class UnavailableEventReminderService implements EventReminderService {
  const UnavailableEventReminderService();

  @override
  bool get isAvailable => false;

  @override
  Future<void> scheduleReminder(MosqueEvent event, Duration before) =>
      throw UnsupportedError('Event reminders are not implemented yet.');
}

final eventReminderServiceProvider = Provider<EventReminderService>(
  (ref) => const UnavailableEventReminderService(),
);
