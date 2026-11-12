import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/home/models/mosque_service_slide.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/home/widgets/mosque_services_carousel.dart';
import 'package:masjid_management/features/prayer_times/screens/prayer_times_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_app.dart';

/// Somali is the default test locale (see home_screen_test.dart).
const _salah = 'Salaadda & Waqtiyadeeda';
const _quran = 'Quraanka & Waxbarashada Islaamka';
const _community = 'Adeegyada Bulshada';

Future<void> _openHome(
  WidgetTester tester, {
  String locale = 'so',
  Size size = const Size(393, 852),
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

/// Waits out one rotation interval and the slide transition.
Future<void> _rotate(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

void main() {
  group('Rotation', () {
    testWidgets('starts on the first service', (tester) async {
      await _openHome(tester);
      expect(find.byType(MosqueServicesCarousel), findsOneWidget);
      expect(find.text(_salah), findsOneWidget);
      expect(find.text(_quran), findsNothing);
    });

    testWidgets('advances on its own', (tester) async {
      await _openHome(tester);
      await _rotate(tester);
      expect(find.text(_quran), findsOneWidget);
      expect(find.text(_salah), findsNothing);
    });

    testWidgets('wraps past the last slide without jumping back', (
      tester,
    ) async {
      await _openHome(tester);
      // Six slides: five rotations reach the last one, a sixth wraps.
      for (var i = 0; i < 5; i++) {
        await _rotate(tester);
      }
      expect(find.text(_community), findsOneWidget);
      await _rotate(tester);
      expect(find.text(_salah), findsOneWidget);
    });

    testWidgets('does not rotate when animations are disabled', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: SizedBox(
              height: 220,
              child: MosqueServicesCarousel(
                slides: mosqueServiceSlides,
                onSlideTap: (_) {},
              ),
            ),
          ),
        ),
      );
      // pumpApp defaults to English.
      expect(find.text('Salah & Prayer Times'), findsOneWidget);
      await tester.pump(const Duration(seconds: 15));
      await tester.pumpAndSettle();
      expect(find.text('Salah & Prayer Times'), findsOneWidget);
      expect(find.text('Quran & Islamic Education'), findsNothing);
    });
  });

  group('Interaction', () {
    testWidgets('swipe moves to the next slide', (tester) async {
      await _openHome(tester);
      await tester.drag(
        find.byKey(const Key('homeServicesCarousel')),
        const Offset(-400, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text(_quran), findsOneWidget);
    });

    testWidgets('tapping a slide opens its screen', (tester) async {
      await _openHome(tester);
      await tester.tap(find.text(_salah));
      await tester.pumpAndSettle();
      expect(find.byType(PrayerTimesScreen), findsOneWidget);
    });
  });

  group('Lifecycle', () {
    // The test framework fails the test if a Timer outlives the widget tree,
    // so simply leaving the screen exercises dispose().
    testWidgets('leaving the screen cancels the timer', (tester) async {
      await _openHome(tester);
      await _rotate(tester);
      await tester.tap(find.text('SETTINGS'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsNothing);
      await tester.pump(const Duration(seconds: 15));
    });
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
        await _rotate(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
