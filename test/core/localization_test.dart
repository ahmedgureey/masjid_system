import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masjid_management/core/localization/app_locales.dart';
import 'package:masjid_management/core/theme/app_theme.dart';
import 'package:masjid_management/core/theme/app_typography.dart';
import 'package:masjid_management/core/utils/date_formatter.dart';
import 'package:masjid_management/features/component_gallery/presentation/component_gallery_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Locale resolution', () {
    test('supported device languages are used', () {
      expect(AppLocales.resolve(const Locale('ar', 'SA')), AppLocales.arabic);
      expect(AppLocales.resolve(const Locale('en', 'US')), AppLocales.english);
      expect(AppLocales.resolve(const Locale('so')), AppLocales.somali);
    });

    test('unsupported device language falls back to Somali', () {
      expect(AppLocales.resolve(const Locale('fr')), AppLocales.somali);
      expect(AppLocales.resolve(null), AppLocales.somali);
    });
  });

  group('Theme per locale', () {
    test('Arabic uses Noto Sans Arabic with larger body text', () {
      final arabic = AppTheme.forLocale(AppLocales.arabic).textTheme.bodyLarge!;
      final latin = AppTheme.forLocale(AppLocales.english).textTheme.bodyLarge!;
      expect(arabic.fontFamily, AppTypography.arabicFontFamily);
      expect(arabic.fontSize, greaterThan(latin.fontSize!));
      expect(arabic.letterSpacing, 0);
    });
  });

  group('Date formatter', () {
    final date = DateTime(2026, 11, 11); // Wednesday

    // Same initialization as main.dart.
    setUpAll(initializeDateFormatting);

    test('English', () {
      expect(
        AppDateFormatter.fullDate(date, locale: 'en'),
        'Wednesday, November 11, 2026',
      );
    });

    test('Somali (custom names, intl has none)', () {
      expect(
        AppDateFormatter.fullDate(date, locale: 'so'),
        'Arbaco, 11 Nofembar 2026',
      );
      expect(AppDateFormatter.shortDate(date, locale: 'so'), 'Arb 11 Nof');
    });
  });

  group('Component gallery in all languages', () {
    for (final locale in AppLocales.supported) {
      testWidgets('renders in ${locale.languageCode} on a small phone', (
        tester,
      ) async {
        await tester.pumpApp(
          const ComponentGalleryScreen(),
          locale: locale,
          surfaceSize: const Size(360, 780),
        );

        expect(tester.takeException(), isNull);
        final direction = Directionality.of(
          tester.element(find.byType(ComponentGalleryScreen)),
        );
        expect(
          direction,
          locale == AppLocales.arabic ? TextDirection.rtl : TextDirection.ltr,
        );
      });
    }

    testWidgets('Somali strings are shown (fallback delegates work)', (
      tester,
    ) async {
      await tester.pumpApp(
        const ComponentGalleryScreen(),
        locale: AppLocales.somali,
      );
      expect(find.text('Qaybaha naqshadda'), findsOneWidget);
      expect(find.text('Diiwaangeli deeq'), findsOneWidget);
    });

    testWidgets('Arabic strings are shown right-to-left', (tester) async {
      await tester.pumpApp(
        const ComponentGalleryScreen(),
        locale: AppLocales.arabic,
      );
      expect(find.text('المكونات'), findsOneWidget);
    });

    testWidgets('gallery has no overflow at 200% text on 360 dp', (
      tester,
    ) async {
      await tester.pumpApp(
        const ComponentGalleryScreen(),
        locale: AppLocales.somali,
        surfaceSize: const Size(360, 780),
        textScale: 2.0,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
