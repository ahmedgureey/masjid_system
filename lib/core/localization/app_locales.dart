import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';
import 'fallback_localizations.dart';

/// Supported app languages and the localization delegates.
abstract final class AppLocales {
  static const Locale english = Locale('en');
  static const Locale somali = Locale('so');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supported = [english, somali, arabic];

  /// Design decision DD-12: used when the device language is not supported.
  static const Locale fallback = somali;

  /// Order matters: for each type, the first delegate supporting the locale
  /// wins. Somali fallbacks come last because Flutter has no Somali strings.
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
    ...somaliFallbackDelegates,
  ];

  static bool isRtl(Locale locale) =>
      locale.languageCode == arabic.languageCode;

  /// Picks the supported locale matching [deviceLocale], else [fallback].
  static Locale resolve(Locale? deviceLocale) {
    if (deviceLocale == null) return fallback;
    for (final locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode) return locale;
    }
    return fallback;
  }
}
