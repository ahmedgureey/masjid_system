/// App-wide constants.
///
/// User-facing text here is temporary: all UI strings move to localization
/// files (English, Somali, Arabic) when localization is set up.
abstract final class AppConstants {
  static const String appName = 'Masjid Management App';

  static const String bismillah = 'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

  /// Welcome screen verse — Surah Al-Jinn 72:18. Shown in Arabic in every
  /// app language (Qur'anic text is not translated here).
  static const String welcomeVerse =
      'وَأَنَّ الْمَسَاجِدَ لِلَّهِ فَلَا تَدْعُوا مَعَ اللَّهِ أَحَدًا';
  static const String welcomeVerseReference = '(الجن: 18)';

  /// Minimum time the splash screen stays visible (design: max 2 s).
  static const Duration splashMinDuration = Duration(milliseconds: 1500);
}
