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

  // ---------------------------------------------------------------------------
  // Demo session
  //
  // Who is signed in while there is no backend, so a page reload does not sign
  // the user out. Only the display name, email and phone the user typed — the
  // password is never written here, and this is not an auth token. The real
  // Supabase session will use secure storage instead.
  // ---------------------------------------------------------------------------
  static const String _demoNameKey = 'demo_session_name';
  static const String _demoEmailKey = 'demo_session_email';
  static const String _demoPhoneKey = 'demo_session_phone';

  /// Display name of the signed-in demo user, or null when signed out.
  String? get demoSessionName => _prefs.getString(_demoNameKey);
  String? get demoSessionEmail => _prefs.getString(_demoEmailKey);
  String? get demoSessionPhone => _prefs.getString(_demoPhoneKey);

  Future<void> saveDemoSession({
    required String displayName,
    String? email,
    String? phone,
  }) async {
    await _prefs.setString(_demoNameKey, displayName);
    await _setOrRemove(_demoEmailKey, email);
    await _setOrRemove(_demoPhoneKey, phone);
  }

  Future<void> clearDemoSession() async {
    await _prefs.remove(_demoNameKey);
    await _prefs.remove(_demoEmailKey);
    await _prefs.remove(_demoPhoneKey);
  }

  Future<void> _setOrRemove(String key, String? value) =>
      value == null ? _prefs.remove(key) : _prefs.setString(key, value);
}
