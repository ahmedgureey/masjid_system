import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/donations/screens/donations_screen.dart';
import 'package:masjid_management/features/events/screens/calendar_screen.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/home/widgets/home_menu_card.dart';
import 'package:masjid_management/features/mosque/screens/mosque_profile_screen.dart';
import 'package:masjid_management/features/news/screens/news_screen.dart';
import 'package:masjid_management/features/prayer_times/screens/prayer_times_screen.dart';
import 'package:masjid_management/features/projects/screens/projects_screen.dart';
import 'package:masjid_management/models/localized_text.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:masjid_management/routing/placeholder_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<void> _openHome(
  WidgetTester tester, {
  String locale = 'so',
  Size? size,
  double scale = 1.0,
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale},
    surfaceSize: size,
    textScale: scale,
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.home);
  expect(find.byType(HomeScreen), findsOneWidget);
}

void main() {
  group('Header', () {
    testWidgets('shows mosque name, date and time (Somali)', (tester) async {
      await _openHome(tester);
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget);
      // testNow = Wednesday 11 November 2026, 14:32.
      expect(find.text('Arbaco, 11 Nofembar 2026'), findsOneWidget);
      // intl puts a narrow no-break space before AM/PM.
      expect(find.textContaining('2:32'), findsOneWidget);
    });

    testWidgets('missing cover photo is labelled, not faked', (tester) async {
      await _openHome(tester);
      expect(find.text('Sawirka masjidka weli lama gelin'), findsOneWidget);
    });

    testWidgets('Arabic: name in Arabic and right-to-left layout', (
      tester,
    ) async {
      await _openHome(tester, locale: 'ar');
      expect(find.text('مسجد الإخلاص'), findsOneWidget);
      // Western digits in Arabic (design decision DD-03).
      expect(find.textContaining('2:32'), findsOneWidget);
      expect(find.textContaining('٢'), findsNothing);
      expect(
        Directionality.of(tester.element(find.byType(HomeScreen))),
        TextDirection.rtl,
      );
    });

    testWidgets('language button removed from the header (by request)', (
      tester,
    ) async {
      await _openHome(tester);
      expect(find.byTooltip('Luqadda'), findsNothing);
      expect(find.byIcon(Icons.language_rounded), findsNothing);
    });
  });

  group('Menu', () {
    const titles = [
      'Macluumaadka Masaajidka',
      'Waqtiyada Salaadda',
      'Kalandarka Masaajidka',
      'Wararka & Maqaallada',
      'Barnaamijka Deeqaha',
      'Mashaariicda', // replaced "Nala Soo Xiriir"
    ];

    testWidgets('six cards in two columns', (tester) async {
      await _openHome(tester, size: const Size(393, 852));
      expect(find.byType(HomeMenuCard), findsNWidgets(6));
      for (final title in titles) {
        expect(find.text(title), findsOneWidget);
      }
      // First two cards share a row; third starts a new row.
      final first = tester.getRect(find.byType(HomeMenuCard).at(0));
      final second = tester.getRect(find.byType(HomeMenuCard).at(1));
      final third = tester.getRect(find.byType(HomeMenuCard).at(2));
      expect(first.top, second.top);
      expect(first.height, second.height);
      expect(third.top, greaterThan(first.bottom));
    });

    for (final title in titles) {
      testWidgets('"$title" opens its screen and back returns home', (
        tester,
      ) async {
        await _openHome(tester);
        await tester.ensureVisible(find.text(title));
        await tester.tap(find.text(title));
        await tester.pumpAndSettle();
        // Built screens (profile) or placeholders for upcoming phases.
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is PlaceholderScreen ||
                w is MosqueProfileScreen ||
                w is PrayerTimesScreen ||
                w is CalendarScreen ||
                w is NewsScreen ||
                w is DonationsScreen ||
                w is ProjectsScreen,
          ),
          findsOneWidget,
        );
        // App bar title (the donations page is titled "Deeqaha").
        expect(
          find.text(switch (title) {
            'Barnaamijka Deeqaha' => 'Deeqaha',
            'Mashaariicda' => 'Mashaariicda Masaajidka',
            _ => title,
          }),
          findsOneWidget,
        );

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    }
  });

  group('Layout', () {
    const cases = <String, (Size, double, String)>{
      'small Android 320x568': (Size(320, 568), 1.0, 'so'),
      'Android 360x780 @200%': (Size(360, 780), 2.0, 'so'),
      'iPhone SE 375x667': (Size(375, 667), 1.0, 'en'),
      'iPhone Pro Max 440x956 Arabic': (Size(440, 956), 1.3, 'ar'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('no overflow on $name', (tester) async {
        await _openHome(tester, locale: locale, size: size, scale: scale);
        expect(tester.takeException(), isNull);
        // Last card is reachable.
        await tester.ensureVisible(find.byType(HomeMenuCard).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('LocalizedText', () {
    test('resolves requested language with fallback', () {
      const text = LocalizedText({'so': 'Salaan', 'ar': 'سلام'});
      expect(text.resolve('ar'), 'سلام');
      expect(text.resolve('en'), 'Salaan'); // falls back to Somali
      expect(const LocalizedText({}).resolve('so'), '');
      expect(const LocalizedText({'en': ' '}).isEmpty, isTrue);
    });

    test('json round trip', () {
      final text = LocalizedText.fromJson({'so': 'A', 'en': 'B', 'x': 1});
      expect(text.values, {'so': 'A', 'en': 'B'});
      expect(LocalizedText.fromJson(text.toJson()), text);
    });
  });

  testWidgets('home works without a demo session (no banner)', (tester) async {
    await _openHome(tester);
    expect(find.text('Habka tijaabada'), findsNothing);
    expect(
      ProviderScope.containerOf(tester.element(find.byType(HomeScreen))),
      isNotNull,
    );
  });
}
