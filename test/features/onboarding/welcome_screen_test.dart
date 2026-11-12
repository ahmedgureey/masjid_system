import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/constants/app_constants.dart';
import 'package:masjid_management/core/theme/app_typography.dart';
import 'package:masjid_management/features/authentication/screens/login_screen.dart';
import 'package:masjid_management/features/authentication/screens/register_screen.dart';
import 'package:masjid_management/features/onboarding/screens/welcome_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<void> _openWelcome(
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
  await goTo(tester, AppRoutes.welcome);
  expect(find.byType(WelcomeScreen), findsOneWidget);
}

void main() {
  group('Content', () {
    testWidgets('header shows greeting and title in Somali', (tester) async {
      await _openWelcome(tester);
      expect(find.text('Assalaamu calaykum'), findsOneWidget);
      expect(find.text('Nidaamka Masaajidka'), findsOneWidget);
      expect(find.text('Ku soo dhowow Nidaamka Masaajidka'), findsOneWidget);
      expect(
        find.text(
          'Waqtiyada salaadda, deeqaha, casharrada iyo wararka bulshada ee '
          'masaajidkaaga.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Qur\'an verse is selectable RTL text in Amiri Quran', (
      tester,
    ) async {
      await _openWelcome(tester);

      final verseFinder = find.byType(SelectableText);
      expect(verseFinder, findsOneWidget);
      final verse = tester.widget<SelectableText>(verseFinder);
      expect(verse.data, AppConstants.welcomeVerse);
      expect(verse.style?.fontFamily, AppTypography.quranVerseFontFamily);

      // Right-to-left even though the app language (Somali) is LTR.
      expect(Directionality.of(tester.element(verseFinder)), TextDirection.rtl);
      expect(find.text(AppConstants.welcomeVerseReference), findsOneWidget);
    });

    testWidgets('buttons and language selector are shown', (tester) async {
      await _openWelcome(tester);
      expect(find.widgetWithText(FilledButton, 'Gal'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      expect(
        find.widgetWithText(OutlinedButton, 'Samee akoon'),
        findsOneWidget,
      );
      expect(find.text('Luqadda: Soomaali'), findsOneWidget);
      expect(find.byIcon(Icons.language_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    });
  });

  group('Actions', () {
    testWidgets('"Gal" opens the login screen', (tester) async {
      await _openWelcome(tester);
      await tester.tap(find.text('Gal'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('"Samee akoon" opens the registration screen', (tester) async {
      await _openWelcome(tester);
      await tester.tap(find.text('Samee akoon'));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets('language selector switches the language', (tester) async {
      final prefs = await pumpFullApp(tester, prefs: {localeCodeKey: 'so'});
      await passSplash(tester);
      await goTo(tester, AppRoutes.welcome);

      await tester.ensureVisible(find.text('Luqadda: Soomaali'));
      await tester.tap(find.text('Luqadda: Soomaali'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      expect(find.text('Language: English'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(prefs.getString(localeCodeKey), 'en');
      // The verse stays in Arabic.
      expect(
        tester.widget<SelectableText>(find.byType(SelectableText)).data,
        AppConstants.welcomeVerse,
      );
    });
  });

  group('Layout', () {
    testWidgets('fits a standard phone without scrolling', (tester) async {
      const screen = Size(393, 852); // iPhone 15/16-class
      await _openWelcome(tester, size: screen);

      expect(
        tester.getRect(find.text('Samee akoon')).bottom,
        lessThan(screen.height),
      );
      expect(
        tester.getRect(find.text('Luqadda: Soomaali')).bottom,
        lessThan(screen.height),
      );
    });

    const cases = <String, (Size, double, String)>{
      'small Android 320x568': (Size(320, 568), 1.0, 'so'),
      'Android 360x640': (Size(360, 640), 1.0, 'so'),
      'iPhone SE 375x667': (Size(375, 667), 1.0, 'en'),
      'Android 360x780 @200%': (Size(360, 780), 2.0, 'so'),
      'iPhone Pro Max 440x956 Arabic': (Size(440, 956), 1.3, 'ar'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('no overflow and buttons reachable on $name', (tester) async {
        await _openWelcome(tester, locale: locale, size: size, scale: scale);
        expect(tester.takeException(), isNull);

        // The primary button can always be reached (scrolls if needed).
        final login = find.byType(FilledButton);
        await tester.ensureVisible(login);
        await tester.pumpAndSettle();
        await tester.tap(login);
        await tester.pumpAndSettle();
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    }
  });
}
