import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/localization/app_locales.dart';
import 'core/localization/l10n.dart';
import 'core/localization/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

/// Root widget: theme, localization (English / Somali / Arabic with RTL)
/// and router.
class MasjidApp extends ConsumerWidget {
  const MasjidApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.forLocale(locale),
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: AppLocales.delegates,
      routerConfig: router,
    );
  }
}
