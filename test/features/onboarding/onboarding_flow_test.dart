import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/onboarding/screens/language_selection_screen.dart';
import 'package:masjid_management/features/onboarding/screens/onboarding_screen.dart';
import 'package:masjid_management/features/onboarding/screens/welcome_screen.dart';
import 'package:masjid_management/routing/placeholder_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('full first-launch flow in Somali', (tester) async {
    final prefs = await pumpFullApp(tester);
    await passSplash(tester);
    expect(find.byType(LanguageSelectionScreen), findsOneWidget);
    expect(find.text('Choose your language'), findsOneWidget);

    // Selecting Somali switches the UI immediately.
    await tester.tap(find.text('Soomaali'));
    await tester.pumpAndSettle();
    expect(find.text('Dooro luqaddaada'), findsOneWidget);
    expect(prefs.getString(localeCodeKey), 'so');

    await tester.tap(find.text('Sii wad'));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Salaad ha kaa dhaafin'), findsOneWidget);

    // Next → slide 2 → slide 3 ("Get started" replaces "Next"; no Skip).
    await tester.tap(find.text('Xiga'));
    await tester.pumpAndSettle();
    expect(find.text('Ku deeq kalsooni'), findsOneWidget);

    await tester.tap(find.text('Xiga'));
    await tester.pumpAndSettle();
    expect(find.text('Wax baro oo ku xirnow'), findsOneWidget);
    expect(find.text('Ka bood'), findsNothing);

    await tester.tap(find.text('Bilow'));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Assalaamu calaykum'), findsOneWidget);
    expect(prefs.getBool(onboardingCompletedKey), isTrue);
  });

  testWidgets('swiping changes onboarding pages', (tester) async {
    await pumpFullApp(tester);
    await passSplash(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Give with trust'), findsOneWidget);
  });

  testWidgets('Skip finishes onboarding and opens welcome', (tester) async {
    final prefs = await pumpFullApp(tester);
    await passSplash(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(prefs.getBool(onboardingCompletedKey), isTrue);
  });

  testWidgets('back from onboarding returns to language selection', (
    tester,
  ) async {
    await pumpFullApp(tester);
    await passSplash(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(LanguageSelectionScreen), findsOneWidget);
  });

  testWidgets('Arabic selection switches layout to right-to-left', (
    tester,
  ) async {
    await pumpFullApp(tester);
    await passSplash(tester);

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();

    expect(find.text('لا تفوّتك صلاة'), findsOneWidget);
    final direction = Directionality.of(
      tester.element(find.byType(OnboardingScreen)),
    );
    expect(direction, TextDirection.rtl);
  });

  testWidgets('saved language is restored on next launch', (tester) async {
    await pumpFullApp(
      tester,
      prefs: {onboardingCompletedKey: true, localeCodeKey: 'ar'},
    );
    await passSplash(tester);

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('السلام عليكم'), findsOneWidget);
  });

  group('Welcome screen', () {
    testWidgets('Log in and Create account navigate and come back', (
      tester,
    ) async {
      await pumpFullApp(tester, prefs: {onboardingCompletedKey: true});
      await passSplash(tester);

      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();
      expect(find.byType(PlaceholderScreen), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);

      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      expect(find.byType(PlaceholderScreen), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('language bottom sheet changes language and closes', (
      tester,
    ) async {
      final prefs = await pumpFullApp(
        tester,
        prefs: {onboardingCompletedKey: true},
      );
      await passSplash(tester);

      await tester.tap(find.text('Language: English'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tap(find.text('Soomaali').last);
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('Gal'), findsOneWidget);
      expect(prefs.getString(localeCodeKey), 'so');
    });
  });
}
