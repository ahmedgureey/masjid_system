import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/onboarding/screens/language_selection_screen.dart';
import 'package:masjid_management/features/onboarding/screens/onboarding_screen.dart';
import 'package:masjid_management/features/onboarding/screens/welcome_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/test_app.dart';

/// Phone sizes from docs/design/responsive-guidelines.md §9.
/// A RenderFlex overflow makes the test fail, so these tests guard against
/// clipped layouts on small phones and with large system text.
void main() {
  const cases = <String, (Size, double)>{
    'small Android 320x640 @100%': (Size(320, 640), 1.0),
    'standard Android 360x780 @200%': (Size(360, 780), 2.0),
    'iPhone SE 375x667 @200%': (Size(375, 667), 2.0),
    'iPhone Pro Max 440x956 @130%': (Size(440, 956), 1.3),
  };

  for (final MapEntry(key: name, value: (size, textScale)) in cases.entries) {
    for (final locale in ['en', 'so', 'ar']) {
      testWidgets('onboarding flow fits on $name [$locale]', (tester) async {
        await pumpFullApp(
          tester,
          prefs: {localeCodeKey: locale},
          surfaceSize: size,
          textScale: textScale,
        );
        await passSplash(tester);
        await goTo(tester, AppRoutes.languageSelection);
        expect(find.byType(LanguageSelectionScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Language → onboarding.
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(find.byType(OnboardingScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Skip → welcome.
        await tester.tap(find.byType(TextButton).first);
        await tester.pumpAndSettle();
        expect(find.byType(WelcomeScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
