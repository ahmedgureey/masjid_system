import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/constants/app_constants.dart';
import 'package:masjid_management/features/onboarding/screens/welcome_screen.dart';
import 'package:masjid_management/features/splash/screens/splash_screen.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('launch: splash, then the welcome screen', (tester) async {
    await pumpFullApp(tester);

    // Splash is shown first, with the translated app name and Bismillah.
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Masjid Management App'), findsOneWidget);
    expect(find.text(AppConstants.bismillah), findsOneWidget);

    await passSplash(tester);

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
