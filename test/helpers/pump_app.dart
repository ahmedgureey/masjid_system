import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/localization/app_locales.dart';
import 'package:masjid_management/core/localization/locale_provider.dart';
import 'package:masjid_management/core/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Locale controller fixed to a given locale for tests.
class _FixedLocaleController extends LocaleController {
  _FixedLocaleController(this._locale);

  final Locale _locale;

  @override
  Locale build() => _locale;
}

/// Pumps [child] inside the app's theme, localization and Riverpod scope.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    Locale locale = AppLocales.english,
    Size? surfaceSize,
    double textScale = 1.0,

    /// Set false when the tree contains endless animations (spinners).
    bool settle = true,
  }) async {
    if (surfaceSize != null) {
      view.physicalSize = surfaceSize * view.devicePixelRatio;
      addTearDown(view.reset);
    }
    if (textScale != 1.0) {
      platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(platformDispatcher.clearTextScaleFactorTestValue);
    }

    await pumpWidget(
      ProviderScope(
        overrides: [
          localeProvider.overrideWith(() => _FixedLocaleController(locale)),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final current = ref.watch(localeProvider);
            return MaterialApp(
              theme: AppTheme.forLocale(current),
              locale: current,
              supportedLocales: AppLocales.supported,
              localizationsDelegates: AppLocales.delegates,
              home: Scaffold(body: child),
            );
          },
        ),
      ),
    );
    settle ? await pumpAndSettle() : await pump();
  }
}
