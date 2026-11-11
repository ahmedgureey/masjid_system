import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/constants/app_constants.dart';
import 'package:masjid_management/services/local_storage_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage keys used by [LocalStorageService] (kept in one place for tests).
const String onboardingCompletedKey = 'onboarding_completed';
const String localeCodeKey = 'locale_code';

/// Pumps the whole app (router, theme, localization) with in-memory
/// [SharedPreferences] seeded with [prefs]. Returns the prefs instance so
/// tests can check what was saved.
Future<SharedPreferences> pumpFullApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  Size? surfaceSize,
  double textScale = 1.0,
}) async {
  if (surfaceSize != null) {
    tester.view.physicalSize = surfaceSize * tester.view.devicePixelRatio;
    addTearDown(tester.view.reset);
  }
  if (textScale != 1.0) {
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }

  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(instance)],
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
