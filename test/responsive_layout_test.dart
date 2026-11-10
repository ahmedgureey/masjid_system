import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/constants/app_constants.dart';
import 'package:masjid_management/features/home/presentation/home_screen.dart';
import 'package:material_ui/material_ui.dart';

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

  cases.forEach((name, spec) {
    final (size, textScale) = spec;

    testWidgets('splash and home render without overflow on $name', (
      tester,
    ) async {
      tester.view.physicalSize = size * tester.view.devicePixelRatio;
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(const ProviderScope(child: MasjidApp()));
      expect(find.text(AppConstants.appName), findsOneWidget);

      await tester.pump(AppConstants.splashMinDuration);
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
