import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masjid_management/core/localization/app_locales.dart';
import 'package:masjid_management/core/localization/locale_provider.dart';
import 'package:masjid_management/core/theme/app_theme.dart';
import 'package:masjid_management/core/utils/clock_provider.dart';
import 'package:masjid_management/core/utils/date_formatter.dart';
import 'package:masjid_management/services/local_storage_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale controller starting at a given locale for tests.
class _FixedLocaleController extends LocaleController {
  _FixedLocaleController(this._locale);

  final Locale _locale;

  @override
  Locale build() => _locale;
}

/// Pumps a single widget inside the app's theme, localization and Riverpod
/// scope (no router). For full-app flows use `pumpFullApp`.
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

    // Same as main.dart: load intl date symbols.
    await initializeDateFormatting();
    AppDateFormatter.configure();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          clockProvider.overrideWith(
            (ref) => Stream.value(DateTime(2026, 11, 11, 14, 32, 5)),
          ),
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
