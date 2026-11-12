import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/mosque/data/mosque_repository.dart';
import 'package:masjid_management/features/mosque/models/mosque.dart';
import 'package:masjid_management/features/prayer_times/application/next_prayer.dart';
import 'package:masjid_management/features/prayer_times/data/prayer_times_repository.dart';
import 'package:masjid_management/features/prayer_times/models/prayer_schedule.dart';
import 'package:masjid_management/features/prayer_times/screens/prayer_times_screen.dart';
import 'package:masjid_management/models/localized_text.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

/// Test-only schedule (fixed values, unrelated to any real location).
DailyPrayerSchedule _schedule(
  DateTime day, {
  Map<Prayer, DateTime>? iqamah,
  String? hijri,
  PrayerScheduleSource source = PrayerScheduleSource.mock,
}) {
  DateTime at(int h, int m) => DateTime(day.year, day.month, day.day, h, m);
  return DailyPrayerSchedule(
    date: day,
    adhan: {
      Prayer.fajr: at(4, 50),
      Prayer.dhuhr: at(12, 10),
      Prayer.asr: at(15, 30),
      Prayer.maghrib: at(18, 15),
      Prayer.isha: at(19, 30),
    },
    iqamah: iqamah ?? const {},
    sunrise: at(6, 5),
    hijriDate: hijri,
    source: source,
  );
}

class _FakePrayerRepo implements PrayerTimesRepository {
  _FakePrayerRepo(this.builder);

  final DailyPrayerSchedule? Function(DateTime day) builder;
  int calls = 0;

  @override
  Future<DailyPrayerSchedule?> getSchedule(DateTime date) async {
    calls++;
    return builder(date);
  }
}

class _FakeMosqueRepo implements MosqueRepository {
  _FakeMosqueRepo(this.mosque);

  final Mosque mosque;

  @override
  Future<Mosque> getMosque() async => mosque;

  @override
  Future<Mosque> updateMosque(Mosque mosque) async => mosque;
}

Future<void> _openPrayer(
  WidgetTester tester, {
  String locale = 'so',
  Size? size,
  double scale = 1.0,
  PrayerTimesRepository? repo,
  MosqueRepository? mosqueRepo,
  Stream<DateTime> Function()? clock,
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale},
    surfaceSize: size,
    textScale: scale,
    clock: clock,
    overrides: [
      // These tests are about how the screen renders a schedule, so they
      // run against the fixed mock values. The app itself now calculates
      // real times; those are covered by
      // test/features/prayer_times/calculated_prayer_times_test.dart.
      prayerTimesRepositoryProvider.overrideWithValue(
        repo ?? const MockPrayerTimesRepository(),
      ),
      if (mosqueRepo != null)
        mosqueRepositoryProvider.overrideWithValue(mosqueRepo),
    ],
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.prayerSchedule);
  expect(find.byType(PrayerTimesScreen), findsOneWidget);
}

String _countdown(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('prayerCountdown'))).data!;

void main() {
  final day = DateTime(2026, 11, 11);
  final nextDay = DateTime(2026, 11, 12);

  group('findNextPrayer', () {
    test('picks the first prayer after now (afternoon → Asr)', () {
      final next = findNextPrayer(
        now: DateTime(2026, 11, 11, 14, 32, 5),
        today: _schedule(day),
        tomorrow: _schedule(nextDay),
      )!;
      expect(next.prayer, Prayer.asr);
      expect(next.isTomorrow, isFalse);
      expect(
        formatCountdown(next.remaining(DateTime(2026, 11, 11, 14, 32, 5))),
        '00:57:55',
      );
    });

    test('just after midnight → today\'s Fajr', () {
      final next = findNextPrayer(
        now: DateTime(2026, 11, 11, 0, 30),
        today: _schedule(day),
      )!;
      expect(next.prayer, Prayer.fajr);
      expect(next.isTomorrow, isFalse);
      expect(next.time, DateTime(2026, 11, 11, 4, 50));
    });

    test('exactly at Adhan moves on to the following prayer', () {
      final next = findNextPrayer(
        now: DateTime(2026, 11, 11, 12, 10),
        today: _schedule(day),
      )!;
      expect(next.prayer, Prayer.asr);
    });

    test('after Isha → tomorrow\'s Fajr', () {
      final now = DateTime(2026, 11, 11, 21);
      final next = findNextPrayer(
        now: now,
        today: _schedule(day),
        tomorrow: _schedule(nextDay),
      )!;
      expect(next.prayer, Prayer.fajr);
      expect(next.isTomorrow, isTrue);
      expect(next.time, DateTime(2026, 11, 12, 4, 50));
      expect(formatCountdown(next.remaining(now)), '07:50:00');
    });

    test('after Isha without tomorrow\'s schedule → null', () {
      expect(
        findNextPrayer(now: DateTime(2026, 11, 11, 21), today: _schedule(day)),
        isNull,
      );
    });

    test('no schedule at all → null', () {
      expect(findNextPrayer(now: DateTime(2026), today: null), isNull);
    });

    test('year boundary: 31 Dec after Isha → 1 Jan Fajr', () {
      final now = DateTime(2026, 12, 31, 23, 59, 59);
      final next = findNextPrayer(
        now: now,
        today: _schedule(DateTime(2026, 12, 31)),
        tomorrow: _schedule(DateTime(2027)),
      )!;
      expect(next.time, DateTime(2027, 1, 1, 4, 50));
      expect(formatCountdown(next.remaining(now)), '04:50:01');
    });

    test('remaining rounds up to whole seconds and never goes negative', () {
      final next = NextPrayer(
        prayer: Prayer.asr,
        time: DateTime(2026, 11, 11, 15, 30),
        isTomorrow: false,
      );
      expect(
        next.remaining(DateTime(2026, 11, 11, 15, 29, 59, 500)),
        const Duration(seconds: 1),
      );
      expect(next.remaining(next.time), Duration.zero);
      expect(
        next.remaining(next.time.add(const Duration(minutes: 1))),
        Duration.zero,
      );
    });
  });

  group('formatCountdown', () {
    test('HH:MM:SS with padding', () {
      expect(
        formatCountdown(const Duration(hours: 7, minutes: 5, seconds: 3)),
        '07:05:03',
      );
      expect(formatCountdown(Duration.zero), '00:00:00');
      expect(formatCountdown(const Duration(seconds: -5)), '00:00:00');
      expect(formatCountdown(const Duration(hours: 25)), '25:00:00');
    });
  });

  group('Schedule model and mock repository', () {
    test('mock repository is tagged mock and has five prayers', () async {
      final s = (await const MockPrayerTimesRepository().getSchedule(
        DateTime(2026, 11, 11, 14, 32),
      ))!;
      expect(s.isMock, isTrue);
      expect(s.isComplete, isTrue);
      expect(s.date, day);
      expect(s.adhan.keys, Prayer.values);
      expect(s.sunrise, isNotNull);
      // Iqamah is independent of Adhan: missing values stay missing.
      expect(s.iqamah[Prayer.asr], isNull);
      expect(s.iqamah[Prayer.isha], isNull);
      expect(s.hijriDate, isNull);
    });

    test('five prayers in order; sunrise is not one of them', () {
      expect(Prayer.values.map((p) => p.name), [
        'fajr',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
      ]);
      expect(Prayer.values.map((p) => p.arabicName), [
        'الفجر',
        'الظهر',
        'العصر',
        'المغرب',
        'العشاء',
      ]);
    });

    test('incomplete schedule is detected', () {
      final s = DailyPrayerSchedule(
        date: day,
        adhan: {Prayer.fajr: DateTime(2026, 11, 11, 4, 50)},
        source: PrayerScheduleSource.calculated,
      );
      expect(s.isComplete, isFalse);
    });
  });

  group('PrayerTimesScreen', () {
    testWidgets('renders header, mock notice, next prayer and countdown', (
      tester,
    ) async {
      await _openPrayer(tester);
      expect(find.text('Waqtiyada Salaadda'), findsOneWidget); // app bar
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget);
      expect(find.text('Arbaco, 11 Nofembar 2026'), findsOneWidget);
      expect(find.byKey(const Key('prayerMockNotice')), findsOneWidget);
      expect(find.text('Salaadda Xigta'), findsOneWidget);
      // testNow = 14:32:05 → Asr (15:30) in 57 min 55 s.
      expect(
        tester.widget<Text>(find.byKey(const Key('nextPrayerName'))).data,
        'Casar',
      );
      expect(_countdown(tester), '00:57:55');
      expect(find.byTooltip('Cusboonaysii'), findsOneWidget);
    });

    testWidgets('five prayers in order, sunrise shown separately after', (
      tester,
    ) async {
      await _openPrayer(tester, size: const Size(400, 1600));
      final ys = [
        for (final p in Prayer.values)
          tester.getTopLeft(find.byKey(ValueKey('prayerRow_${p.name}'))).dy,
      ];
      for (var i = 1; i < ys.length; i++) {
        expect(ys[i], greaterThan(ys[i - 1]));
      }
      final sunriseY = tester
          .getTopLeft(find.byKey(const ValueKey('sunriseRow')))
          .dy;
      expect(sunriseY, greaterThan(ys.last));
      for (final name in ['Subax', 'Duhur', 'Maqrib', 'Cishe']) {
        expect(find.text(name), findsOneWidget);
      }
      // "Casar" appears in the list and on the next-prayer card.
      expect(find.text('Casar'), findsNWidgets(2));
      expect(find.text('الفجر'), findsOneWidget);
      expect(find.text('Qorrax-soo-bax'), findsOneWidget);
    });

    testWidgets('missing Iqamah shows "Lama dejin"', (tester) async {
      await _openPrayer(tester, size: const Size(400, 1600));
      // Mock: Asr and Isha have no Iqamah.
      expect(find.text('Iqaamo: Lama dejin'), findsNWidgets(2));
      expect(find.textContaining('Iqaamo: 5:10'), findsOneWidget);
    });

    testWidgets('countdown ticks every second and crosses midnight', (
      tester,
    ) async {
      final clock = StreamController<DateTime>.broadcast();
      addTearDown(clock.close);
      await _openPrayer(
        tester,
        size: const Size(400, 1600),
        clock: () => clock.stream,
      );

      clock.add(DateTime(2026, 11, 11, 14, 32, 5));
      await tester.pumpAndSettle();
      expect(_countdown(tester), '00:57:55');
      clock.add(DateTime(2026, 11, 11, 14, 32, 6));
      await tester.pumpAndSettle();
      expect(_countdown(tester), '00:57:54');

      // Late evening: next is tomorrow's Fajr.
      clock.add(DateTime(2026, 11, 11, 23, 59, 59));
      await tester.pumpAndSettle();
      expect(_countdown(tester), '04:50:01');
      expect(find.text('Berri'), findsOneWidget);

      // After midnight: new day's schedule, Fajr is today.
      clock.add(DateTime(2026, 11, 12, 0, 0, 1));
      await tester.pumpAndSettle();
      expect(_countdown(tester), '04:49:59');
      expect(find.text('Berri'), findsNothing);
      expect(find.text('Khamiis, 12 Nofembar 2026'), findsOneWidget);
    });

    testWidgets('missing location shows a placeholder', (tester) async {
      await _openPrayer(tester);
      expect(find.text('Goobta masaajidka weli lama gelin'), findsOneWidget);
    });

    testWidgets('configured location is shown', (tester) async {
      await _openPrayer(
        tester,
        mosqueRepo: _FakeMosqueRepo(
          const Mosque(
            id: 'test',
            name: LocalizedText({'so': 'Test Mosque'}),
            city: 'Test City',
            country: 'Test Country',
          ),
        ),
      );
      expect(find.text('Test City, Test Country'), findsOneWidget);
      expect(find.text('Goobta masaajidka weli lama gelin'), findsNothing);
    });

    testWidgets('empty schedule shows empty state, no countdown', (
      tester,
    ) async {
      await _openPrayer(tester, repo: _FakePrayerRepo((_) => null));
      expect(find.text('Jadwal salaadeed lama hayo'), findsOneWidget);
      expect(find.byKey(const Key('prayerCountdown')), findsNothing);
      expect(find.byKey(const Key('prayerMockNotice')), findsNothing);
    });

    testWidgets('Hijri date only when supplied; no mock notice for real data', (
      tester,
    ) async {
      await _openPrayer(
        tester,
        repo: _FakePrayerRepo(
          (d) => _schedule(
            d,
            hijri: 'TEST-HIJRI',
            source: PrayerScheduleSource.calculated,
          ),
        ),
      );
      expect(find.text('TEST-HIJRI'), findsOneWidget);
      expect(find.byKey(const Key('prayerMockNotice')), findsNothing);
    });

    testWidgets('refresh reloads the schedule', (tester) async {
      final repo = _FakePrayerRepo(_schedule);
      await _openPrayer(tester, repo: repo);
      final before = repo.calls;
      await tester.tap(find.byTooltip('Cusboonaysii'));
      await tester.pumpAndSettle();
      expect(repo.calls, greaterThan(before));
      expect(_countdown(tester), '00:57:55');
    });

    testWidgets('Arabic: RTL, Arabic names not duplicated', (tester) async {
      await _openPrayer(tester, locale: 'ar', size: const Size(400, 1600));
      expect(find.text('مواقيت الصلاة'), findsOneWidget);
      expect(find.text('الفجر'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(PrayerTimesScreen))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    });

    const layouts = <String, (Size, double, String)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so'),
      'iPhone SE 375x667 English': (Size(375, 667), 1.0, 'en'),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in layouts.entries) {
      testWidgets('no overflow on $name', (tester) async {
        await _openPrayer(tester, locale: locale, size: size, scale: scale);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byKey(const ValueKey('sunriseRow')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('home menu opens the Prayer Times screen', (tester) async {
    await pumpFullApp(tester, prefs: {localeCodeKey: 'so'});
    await passSplash(tester);
    await goTo(tester, AppRoutes.home);
    expect(find.byType(HomeScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Waqtiyada Salaadda'));
    await tester.tap(find.text('Waqtiyada Salaadda'));
    await tester.pumpAndSettle();
    expect(find.byType(PrayerTimesScreen), findsOneWidget);
  });
}
