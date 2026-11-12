import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/features/about/screens/about_screen.dart';
import 'package:masjid_management/features/authentication/application/demo_session_provider.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/home/widgets/home_menu_card.dart';
import 'package:masjid_management/features/profile/screens/profile_screen.dart';
import 'package:masjid_management/features/settings/screens/settings_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<ProviderContainer> _openHome(
  WidgetTester tester, {
  String locale = 'so',
  Size size = const Size(400, 900),
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
  return ProviderScope.containerOf(tester.element(find.byType(MasjidApp)));
}

Future<void> _tab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

int _selected(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

void main() {
  test('demo session keeps typed email and phone (trimmed)', () async {
    final container = await testContainer();
    addTearDown(container.dispose);
    container
        .read(demoSessionProvider.notifier)
        .signIn(displayName: 'Axmed', email: ' a@b.so ', phone: '  ');
    final s = container.read(demoSessionProvider)!;
    expect(s.email, 'a@b.so');
    expect(s.phone, isNull);
  });

  group('Bottom navigation', () {
    testWidgets('four tabs, HOME is the default and shows the dashboard', (
      tester,
    ) async {
      await _openHome(tester);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
      for (final label in ['HOME', 'SETTINGS', 'PROFILE', 'ABOUT']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(_selected(tester), 0);
      expect(find.byType(HomeScreen), findsOneWidget);
      // Dashboard content unchanged.
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget);
      expect(find.byType(HomeMenuCard), findsWidgets);
    });

    testWidgets('each tab opens its screen and HOME returns', (tester) async {
      await _openHome(tester);
      await _tab(tester, 'SETTINGS');
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(_selected(tester), 1);
      await _tab(tester, 'PROFILE');
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(_selected(tester), 2);
      await _tab(tester, 'ABOUT');
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(_selected(tester), 3);
      await _tab(tester, 'HOME');
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(_selected(tester), 0);
    });

    testWidgets('dashboard cards still open full screen; back keeps the bar', (
      tester,
    ) async {
      await _openHome(tester, size: const Size(400, 1400));
      await tester.tap(find.text('Waqtiyada Salaadda'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });

  group('Settings', () {
    testWidgets('unbuilt sections are disabled and marked coming soon', (
      tester,
    ) async {
      await _openHome(tester);
      await _tab(tester, 'SETTINGS');
      for (final key in [
        'settingsNotifications',
        'settingsPrivacy',
        'settingsHelp',
      ]) {
        final tile = tester.widget<ListTile>(
          find.descendant(
            of: find.byKey(Key(key)),
            matching: find.byType(ListTile),
          ),
        );
        expect(tile.enabled, isFalse, reason: key);
      }
      expect(find.text('Dhowaan'), findsNWidgets(3));
    });

    testWidgets('language works; About App opens the ABOUT tab', (
      tester,
    ) async {
      await _openHome(tester);
      await _tab(tester, 'SETTINGS');
      await tester.tap(find.byKey(const Key('settingsLanguage')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('settingsAbout')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('settingsAbout')));
      await tester.pumpAndSettle();
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(_selected(tester), 3);
    });
  });

  group('Profile', () {
    testWidgets('signed out: sign-in prompt', (tester) async {
      await _openHome(tester);
      await _tab(tester, 'PROFILE');
      expect(find.text('Ma aadan gelin'), findsOneWidget);
      expect(find.byKey(const Key('profileSignOut')), findsNothing);
    });

    testWidgets('signed in: details, disabled edit/password, sign out', (
      tester,
    ) async {
      final c = await _openHome(tester, size: const Size(400, 1400));
      c
          .read(demoSessionProvider.notifier)
          .signIn(
            displayName: 'Axmed Cali',
            email: 'axmed@example.com',
            phone: '0610000000',
          );
      await _tab(tester, 'PROFILE');
      expect(
        tester.widget<Text>(find.byKey(const Key('profileName'))).data,
        'Axmed Cali',
      );
      expect(find.text('AC'), findsOneWidget);
      expect(find.text('axmed@example.com'), findsNWidgets(2));
      expect(find.text('0610000000'), findsOneWidget);
      expect(
        find.text('Akoon tijaabo ah (ma aha akoon dhab ah)'),
        findsOneWidget,
      );
      for (final key in ['profileEdit', 'profileChangePassword']) {
        expect(
          tester
              .widget<ListTile>(
                find.descendant(
                  of: find.byKey(Key(key)),
                  matching: find.byType(ListTile),
                ),
              )
              .enabled,
          isFalse,
        );
      }
      await tester.tap(find.byKey(const Key('profileSignOut')));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(c.read(demoSessionProvider), isNull);
      await _tab(tester, 'PROFILE');
      expect(find.text('Ma aadan gelin'), findsOneWidget);
    });
  });

  group('About', () {
    testWidgets('app information, features and developer details', (
      tester,
    ) async {
      await _openHome(tester, size: const Size(400, 3000));
      await _tab(tester, 'ABOUT');
      expect(
        tester.widget<Text>(find.byKey(const Key('aboutAppName'))).data,
        // This heading uses AppConstants.appName, which is not localized —
        // unlike the description below it. Pre-existing; noted so the two
        // expectations here do not look like a mistake.
        'Masjid System',
      );
      expect(find.text('Nooca 1.0.0'), findsOneWidget);
      expect(
        find.textContaining('Nidaamka Masaajidka waa mobile'),
        findsOneWidget,
      );
      expect(find.text('Duruusta Qur\'aanka'), findsOneWidget);
      expect(find.text('About the Developer'), findsOneWidget);
      expect(find.text('Ahmed Gureey'), findsOneWidget);
      expect(find.text('Mobile App Developer'), findsOneWidget);
      expect(find.text('ahmedgureey2018@gmail.com'), findsOneWidget);
      expect(find.text('0612341376'), findsOneWidget);
      expect(find.text('Muqdisho, Soomaaliya'), findsOneWidget);
    });

    testWidgets('tapping the email copies it to the clipboard', (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await _openHome(tester, size: const Size(400, 3000));
      await _tab(tester, 'ABOUT');
      await tester.tap(find.byKey(const Key('developerEmail')));
      await tester.pump();
      expect(copied, 'ahmedgureey2018@gmail.com');
      expect(find.text('Iimaylka waa la koobiyeeyay.'), findsOneWidget);
    });
  });

  group('Layout', () {
    const cases = <String, (Size, double, String)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so'),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar'),
      'large 440x956 English': (Size(440, 956), 1.0, 'en'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('all tabs have no overflow on $name', (tester) async {
        final c = await _openHome(
          tester,
          locale: locale,
          size: size,
          scale: scale,
        );
        c
            .read(demoSessionProvider.notifier)
            .signIn(displayName: 'Axmed Cali', email: 'axmed@example.com');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        for (final label in ['SETTINGS', 'PROFILE', 'ABOUT', 'HOME']) {
          await _tab(tester, label);
          expect(tester.takeException(), isNull, reason: label);
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, -2000),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$label scrolled');
        }
      });
    }
  });
}
