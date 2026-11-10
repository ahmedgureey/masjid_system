/// App-wide constants.
///
/// User-facing text here is temporary: all UI strings move to localization
/// files (English, Somali, Arabic) when localization is set up.
abstract final class AppConstants {
  static const String appName = 'Masjid Management App';

  /// Somali subtitle shown on the splash screen.
  static const String appNameSomali = 'Maamulka Masjidka';

  static const String bismillah = 'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

  /// Minimum time the splash screen stays visible (design: max 2 s).
  static const Duration splashMinDuration = Duration(milliseconds: 1500);
}
