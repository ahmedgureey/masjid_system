import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

/// Root widget: theme + router. Localization (English, Somali, Arabic/RTL)
/// is configured here in a later phase.
class MasjidApp extends ConsumerWidget {
  const MasjidApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
