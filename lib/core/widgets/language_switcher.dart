import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../localization/app_locales.dart';
import '../localization/l10n.dart';
import '../localization/locale_provider.dart';

/// Segmented English / Soomaali / العربية selector bound to [localeProvider].
/// Used in onboarding, settings and the component gallery.
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = context.l10n;

    return SegmentedButton<Locale>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: AppLocales.english,
          label: Text(l10n.languageEnglish),
        ),
        ButtonSegment(
          value: AppLocales.somali,
          label: Text(l10n.languageSomali),
        ),
        ButtonSegment(
          value: AppLocales.arabic,
          label: Text(l10n.languageArabic),
        ),
      ],
      selected: {locale},
      onSelectionChanged: (selection) =>
          ref.read(localeProvider.notifier).setLocale(selection.first),
    );
  }
}
