import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/constants/app_constants.dart';
import 'package:masjid_management/core/utils/clock_provider.dart';
import 'package:masjid_management/core/utils/date_formatter.dart';
import 'package:masjid_management/routing/app_router.dart';
import 'package:masjid_management/services/local_storage_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage keys used by [LocalStorageService] (kept in one place for tests).
const String onboardingCompletedKey = 'onboarding_completed';
const String localeCodeKey = 'locale_code';

/// Fixed "now" used by tests (Wednesday 11 November 2026, 14:32:05).
final DateTime testNow = DateTime(2026, 11, 11, 14, 32, 5);

/// Pumps the whole app (router, theme, localization) with in-memory
/// [SharedPreferences] seeded with [prefs]. Returns the prefs instance so
/// tests can check what was saved.
Future<SharedPreferences> pumpFullApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  Size? surfaceSize,
  double textScale = 1.0,
  List<Override> overrides = const [],
  Stream<DateTime> Function()? clock,
}) async {
  if (surfaceSize != null) {
    tester.view.physicalSize = surfaceSize * tester.view.devicePixelRatio;
    addTearDown(tester.view.reset);
  }
  if (textScale != 1.0) {
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }

  // Same as main.dart: load intl date symbols.
  await initializeDateFormatting();
  AppDateFormatter.configure();
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(instance),
        // Fixed time: deterministic, and no ticking timer for pumpAndSettle.
        clockProvider.overrideWith(
          (ref) => clock?.call() ?? Stream.value(testNow),
        ),
        ...overrides,
      ],
      child: const MasjidApp(),
    ),
  );
  return instance;
}

/// Waits for the splash screen to finish and navigation to settle.
Future<void> passSplash(WidgetTester tester) async {
  await tester.pump(AppConstants.splashMinDuration);
  await tester.pumpAndSettle();
}

/// A container for unit tests that read providers without pumping a widget.
/// Seeds in-memory [SharedPreferences], which providers that persist state
/// (the demo session, theme, locale) need in order to build.
Future<ProviderContainer> testContainer({
  Map<String, Object> prefs = const {},
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(instance),
      ...overrides,
    ],
  );
}

/// Navigates the running app to [location] (e.g. screens that are not part
/// of the default start-up flow, such as `/language`).
Future<void> goTo(WidgetTester tester, String location) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MasjidApp)),
  );
  container.read(appRouterProvider).go(location);
  await tester.pumpAndSettle();
}
