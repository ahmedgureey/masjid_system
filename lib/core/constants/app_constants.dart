/// App-wide constants.
///
/// User-facing text here is temporary: all UI strings move to localization
/// files (English, Somali, Arabic) when localization is set up.
abstract final class AppConstants {
  static const String appName = 'Masjid System';

  /// Keep in sync with `version:` in pubspec.yaml (no package_info
  /// dependency is used to read it at runtime).
  static const String appVersion = '1.0.0';

  static const String bismillah = 'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

  /// Welcome screen verse — Surah Al-Jinn 72:18. Shown in Arabic in every
  /// app language (Qur'anic text is not translated here).
  static const String welcomeVerse =
      'وَأَنَّ الْمَسَاجِدَ لِلَّهِ فَلَا تَدْعُوا مَعَ اللَّهِ أَحَدًا';
  static const String welcomeVerseReference = '(الجن: 18)';

  /// Minimum time the splash screen stays visible (design: max 2 s).
  static const Duration splashMinDuration = Duration(milliseconds: 1500);

  /// The mosque this installation serves, matching the seeded row in
  /// supabase/migrations/0001_mosques.sql. The platform is multi-tenant by
  /// design, but one build serves one mosque until a selection flow exists.
  static const String defaultMosqueId = 'al-ikhlas';
}
