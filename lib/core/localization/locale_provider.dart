import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../services/local_storage_service.dart';
import 'app_locales.dart';

/// The app language currently selected.
///
/// Starts from the saved choice; if none, from the device language (Somali
/// when the device language is unsupported). Changes are saved on the device.
final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final saved = ref.read(localStorageServiceProvider).localeCode;
    if (saved != null) return AppLocales.resolve(Locale(saved));
    return AppLocales.resolve(PlatformDispatcher.instance.locale);
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppLocales.supported.contains(locale)) return;
    state = locale;
    await ref
        .read(localStorageServiceProvider)
        .setLocaleCode(locale.languageCode);
  }
}
