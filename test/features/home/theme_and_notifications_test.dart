import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/theme/app_colors.dart';
import 'package:masjid_management/core/theme/app_semantic_colors.dart';
import 'package:masjid_management/core/theme/app_theme.dart';
import 'package:masjid_management/core/theme/theme_mode_provider.dart';
import 'package:masjid_management/features/about/screens/about_screen.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/notifications/screens/notifications_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<ProviderContainer> _openHome(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  String locale = 'so',
  Size size = const Size(400, 900),
  double scale = 1.0,
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale, ...prefs},
    surfaceSize: size,
    textScale: scale,
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.home);
  return ProviderScope.containerOf(tester.element(find.byType(MasjidApp)));
}

Brightness _brightness(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(HomeScreen))).brightness;

void main() {
  group('Light theme is unchanged', () {
    test('light tokens equal the original design values', () {
      const s = AppSemanticColors.light;
      expect(s.cardBackground, AppColors.white);
      expect(s.cardBorder, AppColors.neutral200);
      expect(s.tintedBackground, AppColors.green50);
      expect(s.goldBackground, AppColors.gold50);
      expect(s.brandText, AppColors.green800);
      expect(s.mutedText, AppColors.neutral500);
      expect(s.pageBackground, AppColors.white);
      expect(AppTheme.light.scaffoldBackgroundColor, AppColors.lightBackground);
      expect(AppTheme.light.colorScheme.primary, AppColors.primary);
      expect(AppTheme.light.brightness, Brightness.light);
    });

    test('dark theme uses the documented dark palette', () {
      expect(AppTheme.dark.brightness, Brightness.dark);
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.darkBg);
      expect(AppTheme.dark.colorScheme.primary, AppColors.darkPrimary);
      expect(AppTheme.darkArabic.brightness, Brightness.dark);
    });
  });

  group('Header buttons', () {
    testWidgets('bell is visible and opens the notifications screen', (
      tester,
    ) async {
      await _openHome(tester);
      final bell = find.byKey(const Key('homeNotifications'));
      expect(bell, findsOneWidget);
      expect(
        find.descendant(
          of: bell,
          matching: find.byIcon(Icons.notifications_rounded),
        ),
        findsOneWidget,
      );
      await tester.tap(bell);
      await tester.pumpAndSettle();
      expect(find.byType(NotificationsScreen), findsOneWidget);
      // Honest empty state, no fake notifications or unread count.
      expect(find.text('Weli ogeysiis ma jiro'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('dark / light toggle switches theme and is remembered', (
      tester,
    ) async {
      final prefs = await pumpFullApp(tester, prefs: {localeCodeKey: 'so'});
      await passSplash(tester);
      await goTo(tester, AppRoutes.home);
      expect(_brightness(tester), Brightness.light);
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);

      await tester.tap(find.byKey(const Key('homeThemeToggle')));
      await tester.pumpAndSettle();
      expect(_brightness(tester), Brightness.dark);
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
      expect(prefs.getString('theme_mode'), 'dark');

      // Applies to the other tabs too.
      await tester.tap(find.text('ABOUT'));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(AboutScreen))).brightness,
        Brightness.dark,
      );

      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('homeThemeToggle')));
      await tester.pumpAndSettle();
      expect(_brightness(tester), Brightness.light);
      expect(prefs.getString('theme_mode'), 'light');
    });

    testWidgets('saved dark mode is restored on start', (tester) async {
      final c = await _openHome(tester, prefs: {'theme_mode': 'dark'});
      expect(c.read(themeModeProvider), ThemeMode.dark);
      expect(_brightness(tester), Brightness.dark);
    });

    testWidgets('Settings appearance switch uses the same setting', (
      tester,
    ) async {
      final c = await _openHome(tester);
      await tester.tap(find.text('SETTINGS'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('settingsAppearance')));
      await tester.pumpAndSettle();
      expect(c.read(themeModeProvider), ThemeMode.dark);
      // Language setting is still available in Settings.
      expect(find.byKey(const Key('settingsLanguage')), findsOneWidget);
    });
  });

  group('Dark mode layout', () {
    const cases = <String, (Size, double, String)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so'),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('all tabs render without errors on $name', (tester) async {
        await _openHome(
          tester,
          prefs: {'theme_mode': 'dark'},
          locale: locale,
          size: size,
          scale: scale,
        );
        expect(tester.takeException(), isNull);
        for (final label in ['SETTINGS', 'PROFILE', 'ABOUT', 'HOME']) {
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: label);
        }
      });
    }
  });
}
