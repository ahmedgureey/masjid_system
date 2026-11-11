import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The [SharedPreferences] instance, created once in `main.dart` and injected
/// with `sharedPreferencesProvider.overrideWithValue(prefs)`.
/// Tests override it with `SharedPreferences.setMockInitialValues`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  ),
);

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(ref.watch(sharedPreferencesProvider)),
);

/// Small key-value settings stored on the device (non-sensitive only).
/// Tokens and secrets will use secure storage, never this service.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _localeCodeKey = 'locale_code';

  bool get isOnboardingCompleted =>
      _prefs.getBool(_onboardingCompletedKey) ?? false;

  Future<void> setOnboardingCompleted() =>
      _prefs.setBool(_onboardingCompletedKey, true);

  /// Saved app language code (`en`, `so`, `ar`), or null if never chosen.
  String? get localeCode => _prefs.getString(_localeCodeKey);

  Future<void> setLocaleCode(String code) =>
      _prefs.setString(_localeCodeKey, code);

  static const String _themeModeKey = 'theme_mode';

  /// Saved appearance: `light`, `dark`, or null if never chosen.
  String? get themeMode => _prefs.getString(_themeModeKey);

  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);
}
