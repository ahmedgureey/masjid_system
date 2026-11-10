import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/constants/app_constants.dart';
import 'package:masjid_management/features/home/presentation/home_screen.dart';
import 'package:masjid_management/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('app starts on splash and then opens home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MasjidApp()));

    // Splash is shown first, with app name and Bismillah.
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.bismillah), findsOneWidget);

    // After the minimum splash duration, the router navigates to home.
    await tester.pump(AppConstants.splashMinDuration);
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Project setup complete'), findsOneWidget);
  });
}
