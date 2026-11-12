import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/utils/hijri_date.dart';
import 'package:masjid_management/features/events/application/event_permissions.dart';
import 'package:masjid_management/features/events/application/event_reminders.dart';
import 'package:masjid_management/features/events/application/event_validation.dart';
import 'package:masjid_management/features/events/data/events_repository.dart';
import 'package:masjid_management/features/events/data/islamic_dates_repository.dart';
import 'package:masjid_management/features/events/models/islamic_occasion.dart';
import 'package:masjid_management/features/events/models/mosque_event.dart';
import 'package:masjid_management/features/events/screens/calendar_screen.dart';
import 'package:masjid_management/features/events/screens/edit_event_screen.dart';
import 'package:masjid_management/features/events/screens/event_details_screen.dart';
import 'package:masjid_management/features/events/widgets/event_card.dart';
import 'package:masjid_management/features/events/widgets/month_calendar.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

// testNow = Wednesday 11 November 2026, 14:32:05. Sample events (relative):
// quran 11 Nov 16:00 · lecture 13 Nov · lesson 16 Nov · community 8 Nov
// (past) · youth 20 Nov · children 23 Nov (cancelled) · ramadan 1 Dec ·
// past lecture 1 Nov.
const _quran = 'TUSAALE: Casharka Qur\'aanka';
const _lecture = 'TUSAALE: Muxaadaro';
const _lesson = 'TUSAALE: Dars diineed';
const _community = 'TUSAALE: Kulanka jamaacada';
const _ramadan = 'TUSAALE: Kulan diyaarineed Ramadaan';
const _pastLecture = 'TUSAALE: Muxaadaradii hore';

Future<void> _openCalendar(
  WidgetTester tester, {
  String locale = 'so',
  Size? size,
  double scale = 1.0,
  bool canManage = false,
  List<MosqueEvent>? events,
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale},
    surfaceSize: size ?? const Size(400, 2400),
    textScale: scale,
    overrides: [
      eventsRepositoryProvider.overrideWithValue(
        LocalEventsRepository(
          seedDate: testNow,
          latency: Duration.zero,
          initial: events == null ? null : [...events],
        ),
      ),
      canManageEventsProvider.overrideWithValue(canManage),
    ],
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.calendar);
  expect(find.byType(CalendarScreen), findsOneWidget);
}

String _monthTitle(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('calendarMonthTitle'))).data!;

String _listTitle(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('eventsListTitle'))).data!;

Future<void> _tapKey(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

Finder _input(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

MosqueEvent _event(
  String id, {
  required DateTime start,
  DateTime? end,
  EventCategory category = EventCategory.other,
  EventStatus status = EventStatus.scheduled,
}) => MosqueEvent(
  id: id,
  title: 'Test $id',
  description: 'Test description',
  category: category,
  start: start,
  end: end,
  location: 'Test location',
  status: status,
);

void main() {
  final now = DateTime(2026, 11, 11, 14, 32, 5);

  group('Event model and filters (pure)', () {
    final events = LocalEventsRepository.sampleEvents(now);

    test('sample events are all marked as samples', () {
      expect(events, isNotEmpty);
      expect(events.every((e) => e.isSample), isTrue);
      expect(events.every((e) => e.title.startsWith('TUSAALE')), isTrue);
    });

    test('timing: upcoming, ongoing, ended', () {
      final e = _event(
        'a',
        start: DateTime(2026, 11, 11, 14),
        end: DateTime(2026, 11, 11, 15),
      );
      expect(e.timingAt(DateTime(2026, 11, 11, 13)), EventTiming.upcoming);
      expect(e.timingAt(DateTime(2026, 11, 11, 14, 30)), EventTiming.ongoing);
      expect(e.timingAt(DateTime(2026, 11, 11, 15)), EventTiming.ended);
    });

    test('multi-day event occurs on each day, across a month boundary', () {
      final e = _event(
        'b',
        start: DateTime(2026, 11, 30, 18),
        end: DateTime(2026, 12, 2, 12),
      );
      expect(e.occursOn(DateTime(2026, 11, 29)), isFalse);
      expect(e.occursOn(DateTime(2026, 11, 30)), isTrue);
      expect(e.occursOn(DateTime(2026, 12, 1)), isTrue);
      expect(e.occursOn(DateTime(2026, 12, 2, 23)), isTrue);
      expect(e.occursOn(DateTime(2026, 12, 3)), isFalse);
    });

    test('upcoming sorted ascending, past descending', () {
      final upcoming = filterEvents(
        events,
        filter: EventFilter.upcoming,
        now: now,
      );
      expect(upcoming.first.id, 'sample-quran');
      expect(upcoming.length, 6);
      final past = filterEvents(events, filter: EventFilter.past, now: now);
      expect(past.map((e) => e.id), [
        'sample-community',
        'sample-past-lecture',
      ]);
    });

    test('category filters', () {
      List<String> ids(EventFilter f) =>
          filterEvents(events, filter: f, now: now).map((e) => e.id).toList();
      expect(ids(EventFilter.quranClasses), ['sample-quran']);
      expect(ids(EventFilter.lectures), [
        'sample-past-lecture',
        'sample-lecture',
        'sample-lesson',
      ]);
      expect(ids(EventFilter.communityMeetings), ['sample-community']);
      expect(ids(EventFilter.islamicOccasions), ['sample-ramadan']);
      expect(ids(EventFilter.all).length, events.length);
    });

    test('filter by day', () {
      final onDay = filterEvents(
        events,
        filter: EventFilter.all,
        now: now,
        day: DateTime(2026, 11, 13),
      );
      expect(onDay.map((e) => e.id), ['sample-lecture']);
    });
  });

  group('Event validation (pure)', () {
    final today = DateTime(2026, 11, 11);

    test('date: required, no past date for new events', () {
      expect(
        EventValidation.date(null, today: today, isNew: true),
        EventDateTimeError.required,
      );
      expect(
        EventValidation.date(DateTime(2026, 11, 10), today: today, isNew: true),
        EventDateTimeError.pastDate,
      );
      expect(
        EventValidation.date(
          DateTime(2026, 11, 10),
          today: today,
          isNew: false,
        ),
        isNull,
      );
      expect(
        EventValidation.date(DateTime(2026, 11, 11), today: today, isNew: true),
        isNull,
      );
    });

    test('start time required; end must be after start', () {
      expect(EventValidation.startTime(null), EventDateTimeError.required);
      expect(EventValidation.startTime(600), isNull);
      expect(EventValidation.endTime(600, null), isNull);
      expect(EventValidation.endTime(600, 660), isNull);
      expect(
        EventValidation.endTime(600, 600),
        EventDateTimeError.endNotAfterStart,
      );
      expect(
        EventValidation.endTime(600, 540),
        EventDateTimeError.endNotAfterStart,
      );
    });
  });

  group('Islamic dates (estimates)', () {
    test('occasions in a range are all marked estimated', () async {
      const repo = EstimatedIslamicDatesRepository();
      final list = await repo.occasionsBetween(
        DateTime(2027, 1, 1),
        DateTime(2027, 12, 31),
      );
      expect(list, isNotEmpty);
      expect(
        list.every((o) => o.status == OccasionDateStatus.estimated),
        isTrue,
      );
      final ramadan = list.firstWhere(
        (o) => o.type == IslamicOccasionType.ramadanStart,
      );
      expect(ramadan.hijri, const HijriDate(1448, 9, 1));
      expect(ramadan.date, const HijriDate(1448, 9, 1).toGregorian());
      // Sorted by date.
      for (var i = 1; i < list.length; i++) {
        expect(list[i].date.isBefore(list[i - 1].date), isFalse);
      }
    });

    test('reminders are reported as unavailable', () {
      const service = UnavailableEventReminderService();
      expect(service.isAvailable, isFalse);
    });
  });

  group('CalendarScreen', () {
    testWidgets('renders header, month, estimate label and events', (
      tester,
    ) async {
      await _openCalendar(tester);
      expect(find.text('Kalandarka Masaajidka'), findsOneWidget);
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget);
      expect(find.text('Arbaco, 11 Nofembar 2026'), findsOneWidget);
      expect(_monthTitle(tester), 'Nofembar 2026');
      expect(
        tester.widget<Text>(find.byKey(const Key('calendarTodayHijri'))).data,
        contains('(qiyaas)'),
      );
      expect(find.byKey(const Key('eventsMockNotice')), findsOneWidget);
      expect(_listTitle(tester), 'Dhacdooyinka Soo Socda');
      expect(find.text(_quran), findsOneWidget);
      expect(find.text(_community), findsNothing); // past
      expect(find.byType(FloatingActionButton), findsNothing); // not admin
    });

    testWidgets('weekday alignment: 1 Nov 2026 is under Sunday', (
      tester,
    ) async {
      await _openCalendar(tester);
      double x(DateTime d) =>
          tester.getCenter(find.byKey(calendarDayKey(d))).dx;
      // Somali grid starts on Saturday ("Sab").
      expect(
        x(DateTime(2026, 11, 7)),
        closeTo(tester.getCenter(find.text('Sab')).dx, 1),
      );
      expect(
        x(DateTime(2026, 11, 1)),
        closeTo(tester.getCenter(find.text('Axa')).dx, 1),
      );
      expect(x(DateTime(2026, 11, 1)), closeTo(x(DateTime(2026, 11, 8)), 0.5));
      expect(x(DateTime(2026, 11, 7)), lessThan(x(DateTime(2026, 11, 1))));
      // 30 days, no 31st.
      expect(
        find.byKey(calendarDayKey(DateTime(2026, 11, 30))),
        findsOneWidget,
      );
      expect(find.byKey(calendarDayKey(DateTime(2026, 12, 1))), findsNothing);
    });

    testWidgets('month navigation across the year boundary and back', (
      tester,
    ) async {
      await _openCalendar(tester);
      await _tapKey(tester, const Key('calendarNextMonth'));
      expect(_monthTitle(tester), 'Desembar 2026');
      expect(
        find.byKey(calendarDayKey(DateTime(2026, 12, 31))),
        findsOneWidget,
      );
      await _tapKey(tester, const Key('calendarNextMonth'));
      expect(_monthTitle(tester), 'Janaayo 2027');
      await _tapKey(tester, const Key('calendarPrevMonth'));
      await _tapKey(tester, const Key('calendarPrevMonth'));
      await _tapKey(tester, const Key('calendarPrevMonth'));
      expect(_monthTitle(tester), 'Oktoobar 2026');
      await _tapKey(tester, const Key('calendarTodayButton'));
      expect(_monthTitle(tester), 'Nofembar 2026');
      expect(_listTitle(tester), 'Dhacdooyinka Arbaco, 11 Nofembar 2026');
    });

    testWidgets('selecting a date shows that day\'s events; tap again clears', (
      tester,
    ) async {
      await _openCalendar(tester);
      await _tapKey(tester, calendarDayKey(DateTime(2026, 11, 13)));
      expect(_listTitle(tester), 'Dhacdooyinka Jimce, 13 Nofembar 2026');
      expect(find.text(_lecture), findsOneWidget);
      expect(find.text(_quran), findsNothing);

      await _tapKey(tester, calendarDayKey(DateTime(2026, 11, 14)));
      expect(find.text('Dhacdooyin ma jiraan'), findsOneWidget);

      await _tapKey(tester, calendarDayKey(DateTime(2026, 11, 14)));
      expect(_listTitle(tester), 'Dhacdooyinka Soo Socda');
    });

    testWidgets('filters update the list', (tester) async {
      await _openCalendar(tester);
      await _tapKey(tester, const ValueKey('filter-past'));
      expect(_listTitle(tester), 'Dhacdooyinkii hore');
      expect(find.text(_community), findsOneWidget);
      expect(find.text(_pastLecture), findsOneWidget);
      expect(find.text(_quran), findsNothing);

      await _tapKey(tester, const ValueKey('filter-quranClasses'));
      expect(find.text(_quran), findsOneWidget);
      expect(find.text(_lecture), findsNothing);

      await _tapKey(tester, const ValueKey('filter-lectures'));
      expect(find.text(_lecture), findsOneWidget);
      expect(find.text(_lesson), findsOneWidget);

      await _tapKey(tester, const ValueKey('filter-islamicOccasions'));
      expect(find.text(_ramadan), findsOneWidget);
      expect(find.text(_lecture), findsNothing);
    });

    testWidgets('estimated Islamic occasions appear in their month', (
      tester,
    ) async {
      await _openCalendar(tester);
      final ramadan = const HijriDate(1448, 9, 1).toGregorian();
      final months = (ramadan.year - 2026) * 12 + ramadan.month - 11;
      for (var i = 0; i < months; i++) {
        await _tapKey(tester, const Key('calendarNextMonth'));
      }
      expect(find.text('Bilowga Ramadaan'), findsOneWidget);
      expect(find.text('Qiyaas'), findsWidgets);
      expect(find.text('La xaqiijiyey'), findsNothing);
    });

    testWidgets('empty event list shows empty state, no mock notice', (
      tester,
    ) async {
      await _openCalendar(tester, events: const []);
      expect(find.text('Dhacdooyin ma jiraan'), findsOneWidget);
      expect(find.byKey(const Key('eventsMockNotice')), findsNothing);
    });

    testWidgets('event card opens details; reminder is disabled', (
      tester,
    ) async {
      await _openCalendar(tester);
      await _tapKey(tester, const ValueKey('event-sample-quran'));
      expect(find.byType(EventDetailsScreen), findsOneWidget);
      expect(find.text('Faahfaahinta Dhacdada'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('eventDetailsTitle'))).data,
        _quran,
      );
      expect(find.text('Tusaale: hoolka masaajidka'), findsOneWidget);
      expect(find.byTooltip('Wax ka beddel'), findsNothing); // not admin
      expect(
        find.text(
          'Xasuusiyeyaashu weli lama dhisin; waxaa lagu dari doonaa waji dambe.',
        ),
        findsOneWidget,
      );
      final reminder = find.descendant(
        of: find.byKey(const Key('eventReminderButton')),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      );
      expect(tester.widget<ButtonStyleButton>(reminder).onPressed, isNull);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(CalendarScreen), findsOneWidget);
    });

    testWidgets('unknown event id shows not-found state', (tester) async {
      await _openCalendar(tester);
      await goTo(tester, AppRoutes.eventDetails('missing'));
      expect(find.text('Dhacdadan lama helin.'), findsOneWidget);
    });

    testWidgets('non-admins are redirected away from the form', (tester) async {
      await _openCalendar(tester);
      await goTo(tester, AppRoutes.newEvent);
      expect(find.byType(EditEventScreen), findsNothing);
      expect(find.byType(CalendarScreen), findsOneWidget);
    });
  });

  group('Event form (admin, frontend-only permission)', () {
    testWidgets('new event: required fields show Somali errors', (
      tester,
    ) async {
      await _openCalendar(tester, canManage: true);
      await tester.tap(find.text('Ku dar Dhacdo'));
      await tester.pumpAndSettle();
      expect(find.byType(EditEventScreen), findsOneWidget);
      expect(find.text('Dhacdo cusub'), findsOneWidget);

      await tester.tap(find.byKey(const Key('eventSaveButton')));
      await tester.pumpAndSettle();
      expect(find.text('Meeshan waa in la buuxiyaa'), findsWidgets);
      expect(find.text('Fadlan dooro mid'), findsOneWidget);
      expect(find.byType(EditEventScreen), findsOneWidget); // not saved
    });

    testWidgets('edit an existing event and save (local only)', (tester) async {
      await _openCalendar(tester, canManage: true);
      await _tapKey(tester, const ValueKey('event-sample-quran'));
      await tester.tap(find.byTooltip('Wax ka beddel'));
      await tester.pumpAndSettle();
      expect(find.text('Wax ka beddel dhacdada'), findsOneWidget);

      await tester.enterText(_input('eventFieldTitle'), 'Casharka cusub');
      await tester.pump();
      await tester.tap(find.byKey(const Key('eventSaveButton')));
      await tester.pumpAndSettle();

      expect(find.byType(EventDetailsScreen), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('eventDetailsTitle'))).data,
        'Casharka cusub',
      );
      // The notice still has to say the save is local; the wording changed
      // when saves started surviving a restart.
      expect(find.textContaining('kaydiyey qalabkan'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Casharka cusub'), findsOneWidget);
    });

    testWidgets('cancel with changes asks before discarding', (tester) async {
      await _openCalendar(tester, canManage: true);
      await goTo(tester, AppRoutes.editEvent('sample-lecture'));
      await tester.enterText(_input('eventFieldTitle'), 'Changed');
      await tester.pump();

      await tester.tap(find.byKey(const Key('eventCancelButton')));
      await tester.pumpAndSettle();
      expect(find.text('Ma tuuraysaa isbeddellada?'), findsOneWidget);
      await tester.tap(find.text('Sii wad wax ka beddelka'));
      await tester.pumpAndSettle();
      expect(find.byType(EditEventScreen), findsOneWidget);

      await tester.tap(find.byKey(const Key('eventCancelButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tuur'));
      await tester.pumpAndSettle();
      expect(find.byType(EditEventScreen), findsNothing);
      expect(find.text('Changed'), findsNothing);
      expect(find.text(_lecture), findsOneWidget); // unchanged in list
    });

    testWidgets('cancel without changes leaves immediately', (tester) async {
      await _openCalendar(tester, canManage: true);
      await goTo(tester, AppRoutes.editEvent('sample-lecture'));
      await tester.tap(find.byKey(const Key('eventCancelButton')));
      await tester.pumpAndSettle();
      expect(find.text('Ma tuuraysaa isbeddellada?'), findsNothing);
      expect(find.byType(EditEventScreen), findsNothing);
    });

    testWidgets('end time before start time is rejected', (tester) async {
      await _openCalendar(
        tester,
        canManage: true,
        events: [
          _event(
            'bad',
            start: DateTime(2026, 11, 12, 18),
            end: DateTime(2026, 11, 12, 17),
          ),
        ],
      );
      await goTo(tester, AppRoutes.editEvent('bad'));
      await tester.tap(find.byKey(const Key('eventSaveButton')));
      await tester.pumpAndSettle();
      expect(
        find.text('Waqtiga dhammaadku waa inuu ka dambeeyaa waqtiga bilowga.'),
        findsOneWidget,
      );
      expect(find.byType(EditEventScreen), findsOneWidget);
    });

    testWidgets('registration details are required when switched on', (
      tester,
    ) async {
      await _openCalendar(tester, canManage: true);
      await goTo(tester, AppRoutes.editEvent('sample-lecture'));
      await _tapKey(tester, const Key('eventFieldRegistrationSwitch'));
      await tester.tap(find.byKey(const Key('eventSaveButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('eventFieldRegistration')), findsOneWidget);
      expect(find.text('Meeshan waa in la buuxiyaa'), findsOneWidget);
    });
  });

  group('Layout', () {
    const cases = <String, (Size, double, String)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so'),
      'iPhone SE 375x667 English': (Size(375, 667), 1.0, 'en'),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar'),
      'large 440x956': (Size(440, 956), 1.0, 'so'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('calendar has no overflow on $name', (tester) async {
        await _openCalendar(
          tester,
          locale: locale,
          size: size,
          scale: scale,
          canManage: true,
        );
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byType(EventCard).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('details and form have no overflow on $name', (tester) async {
        await _openCalendar(
          tester,
          locale: locale,
          size: size,
          scale: scale,
          canManage: true,
        );
        await goTo(tester, AppRoutes.eventDetails('sample-youth'));
        expect(tester.takeException(), isNull);
        await goTo(tester, AppRoutes.editEvent('sample-youth'));
        expect(tester.takeException(), isNull);
      });
    }
  });
}
