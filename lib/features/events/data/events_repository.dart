import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/calendar_utils.dart';
import '../models/mosque_event.dart';

/// Source of mosque events.
///
/// Today: [LocalEventsRepository] (in-memory mock).
/// Supabase phase: an implementation backed by an `events` table (with Row
/// Level Security restricting writes to mosque administrators) replaces it
/// in [eventsRepositoryProvider].
abstract interface class EventsRepository {
  Future<List<MosqueEvent>> getEvents();

  /// Inserts or updates [event] (matched by id) and returns the stored copy.
  Future<MosqueEvent> saveEvent(MosqueEvent event);
}

/// MOCK — in-memory sample events, clearly marked "TUSAALE" (example) and
/// flagged [MosqueEvent.isSample]. They are NOT real events of the mosque.
///
/// Dates are relative to [seedDate] (today in the app, a fixed date in
/// tests) so the calendar always has something to show. Saved changes live
/// in memory and are lost when the app closes.
class LocalEventsRepository implements EventsRepository {
  LocalEventsRepository({
    required DateTime seedDate,
    this.latency = const Duration(milliseconds: 600),
    List<MosqueEvent>? initial,
  }) : _events = initial ?? sampleEvents(seedDate);

  final Duration latency;
  final List<MosqueEvent> _events;

  @override
  Future<List<MosqueEvent>> getEvents() async => List.unmodifiable(_events);

  @override
  Future<MosqueEvent> saveEvent(MosqueEvent event) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      _events[index] = event;
    } else {
      _events.add(event);
    }
    return event;
  }

  static const String _sampleNote =
      'Tani waa dhacdo tusaale ah (mock) oo loogu talagalay tijaabinta '
      'naqshadda app-ka. Ma aha dhacdo dhab ah oo masaajidka.';

  /// Clearly identified sample events around [seed].
  static List<MosqueEvent> sampleEvents(DateTime seed) {
    final d = CalendarUtils.dateOnly(seed);
    DateTime at(int dayOffset, int h, [int m = 0]) =>
        DateTime(d.year, d.month, d.day + dayOffset, h, m);
    MosqueEvent sample(
      String id,
      String title,
      EventCategory category,
      DateTime start,
      DateTime? end, {
      String? organizer,
      EventStatus status = EventStatus.scheduled,
      EventRegistration? registration,
    }) => MosqueEvent(
      id: id,
      title: 'TUSAALE: $title',
      description: _sampleNote,
      category: category,
      start: start,
      end: end,
      location: 'Tusaale: hoolka masaajidka',
      organizer: organizer,
      status: status,
      registration: registration,
      isSample: true,
    );

    return [
      sample(
        'sample-quran',
        "Casharka Qur'aanka",
        EventCategory.quranClasses,
        at(0, 16),
        at(0, 17, 30),
        organizer: 'Tusaale: macallinka Qur’aanka',
      ),
      sample(
        'sample-lecture',
        'Muxaadaro',
        EventCategory.lectures,
        at(2, 19, 45),
        at(2, 21),
      ),
      sample(
        'sample-lesson',
        'Dars diineed',
        EventCategory.religiousLessons,
        at(5, 10),
        at(5, 11),
      ),
      sample(
        'sample-community',
        'Kulanka jamaacada',
        EventCategory.communityMeetings,
        at(-3, 17),
        at(-3, 18, 30),
        organizer: 'Tusaale: guddiga masaajidka',
      ),
      sample(
        'sample-youth',
        'Barnaamijka dhalinyarada',
        EventCategory.youthPrograms,
        at(9, 15),
        at(9, 17),
        registration: const EventRegistration(
          details: 'Tusaale: is-diiwaangeli xafiiska masaajidka.',
        ),
      ),
      sample(
        'sample-children',
        'Barnaamijka carruurta',
        EventCategory.childrenPrograms,
        at(12, 10),
        at(12, 12),
        status: EventStatus.cancelled,
      ),
      sample(
        'sample-ramadan',
        'Kulan diyaarineed Ramadaan',
        EventCategory.ramadanPrograms,
        at(20, 18),
        null,
      ),
      sample(
        'sample-past-lecture',
        'Muxaadaradii hore',
        EventCategory.lectures,
        at(-10, 19),
        at(-10, 20),
      ),
    ];
  }
}

final eventsRepositoryProvider = Provider<EventsRepository>(
  (ref) => LocalEventsRepository(seedDate: DateTime.now()),
);

/// All events known to the app; [EventsController.save] updates the list
/// after a successful save.
final eventsProvider =
    AsyncNotifierProvider<EventsController, List<MosqueEvent>>(
      EventsController.new,
    );

class EventsController extends AsyncNotifier<List<MosqueEvent>> {
  @override
  Future<List<MosqueEvent>> build() =>
      ref.read(eventsRepositoryProvider).getEvents();

  /// Saves through the repository; throws on failure (state unchanged).
  Future<MosqueEvent> save(MosqueEvent event) async {
    final saved = await ref.read(eventsRepositoryProvider).saveEvent(event);
    final current = [...?state.value];
    final index = current.indexWhere((e) => e.id == saved.id);
    if (index >= 0) {
      current[index] = saved;
    } else {
      current.add(saved);
    }
    state = AsyncData(current);
    return saved;
  }
}
