import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app_locales.dart';

/// The app language currently selected.
///
/// Starts from the device language (or Somali when unsupported). Not yet
/// persisted between launches — saving the choice is added together with
/// local storage.
final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => AppLocales.resolve(PlatformDispatcher.instance.locale);

  void setLocale(Locale locale) {
    if (AppLocales.supported.contains(locale)) state = locale;
  }
}
