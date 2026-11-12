import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/calendar_utils.dart';
import '../../../services/local_collection_store.dart';
import '../models/mosque_event.dart';
import 'event_json.dart';

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

  /// Removes the event with [id]. Removing one that is already gone is not an
  /// error: two taps on a delete button should not surface a failure.
  Future<void> deleteEvent(String id);
}

/// Events held on the device.
///
/// With a [store], the sample events are written once on the very first run
/// and are ordinary rows from then on: the user can edit them, delete them,
/// and add their own, and all of it survives closing the app. Deleting every
/// sample does not bring them back — [LocalCollectionStore.readOrSeed] seeds
/// on "never written", not on "empty".
///
/// Without a [store] it is purely in-memory, which is what the widget tests
/// want: they pass [initial] and assert on what they passed.
///
/// Sample dates are relative to [seedDate] (today in the app, a fixed date in
/// tests) so the calendar has something to show on first run. They are fixed
/// at that moment, so samples left in place age — which is the point: they
/// are there to be replaced.
class LocalEventsRepository implements EventsRepository {
  LocalEventsRepository({
    required this.seedDate,
    this.store,
    this.latency = const Duration(milliseconds: 600),
    List<MosqueEvent>? initial,
  }) : // Copied: the caller's list must not be mutated by saves and deletes.
       _events = initial == null ? null : List<MosqueEvent>.of(initial);

  final Duration latency;

  /// What the sample dates are built around.
  final DateTime seedDate;

  /// Null in tests that work purely in memory.
  final LocalCollectionStore? store;

  static const String collection = 'events';

  /// Null until first loaded, so a store-backed repository does not read the
  /// device in its constructor.
  List<MosqueEvent>? _events;

  /// The working list, loaded from the store on first use.
  Future<List<MosqueEvent>> _loaded() async {
    final cached = _events;
    if (cached != null) return cached;

    final store = this.store;
    final loaded = store == null
        ? sampleEvents(seedDate)
        : EventJson.listFrom(
            await store.readOrSeed(
              collection,
              () => EventJson.listTo(sampleEvents(seedDate)),
            ),
          );
    return _events = loaded;
  }

  /// Writes the working list back. A no-op without a store.
  Future<void> _flush() async {
    final store = this.store;
    if (store == null) return;
    await store.write(collection, EventJson.listTo(_events ?? const []));
  }

  @override
  Future<List<MosqueEvent>> getEvents() async =>
      List.unmodifiable(await _loaded());

  @override
  Future<MosqueEvent> saveEvent(MosqueEvent event) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final events = await _loaded();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      events[index] = event;
    } else {
      events.add(event);
    }
    await _flush();
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final events = await _loaded();
    events.removeWhere((e) => e.id == id);
    await _flush();
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
  (ref) => LocalEventsRepository(
    seedDate: DateTime.now(),
    store: ref.watch(localCollectionStoreProvider),
  ),
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

  /// Deletes through the repository; throws on failure (state unchanged).
  Future<void> delete(String id) async {
    await ref.read(eventsRepositoryProvider).deleteEvent(id);
    state = AsyncData([...?state.value]..removeWhere((e) => e.id == id));
  }
}

