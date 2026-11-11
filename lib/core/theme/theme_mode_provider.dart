import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../services/local_storage_service.dart';

/// Light / dark appearance chosen by the user. Starts light (the original
/// design) unless the user saved "dark"; the choice is remembered on the
/// device.
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.read(localStorageServiceProvider).themeMode == 'dark'
      ? ThemeMode.dark
      : ThemeMode.light;

  bool get isDark => state == ThemeMode.dark;

  Future<void> toggle() async {
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    await ref
        .read(localStorageServiceProvider)
        .setThemeMode(isDark ? 'dark' : 'light');
  }
}
