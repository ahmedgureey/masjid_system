import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../localization/app_locales.dart';
import '../../localization/l10n.dart';
import '../../localization/locale_provider.dart';
import '../../theme/app_spacing.dart';
import 'language_option_tile.dart';

/// The three language options bound to [localeProvider]. Selecting one
/// switches the app language immediately (live preview, incl. RTL).
class LanguageOptionsList extends ConsumerWidget {
  const LanguageOptionsList({super.key, this.onSelected});

  /// Called after the language changed (e.g. to close a bottom sheet).
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    final l10n = context.l10n;
    final options = <(Locale, String)>[
      (AppLocales.english, l10n.languageEnglish),
      (AppLocales.somali, l10n.languageSomali),
      (AppLocales.arabic, l10n.languageArabic),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (locale, label) in options) ...[
          LanguageOptionTile(
            label: label,
            selected: current == locale,
            onTap: () async {
              await ref.read(localeProvider.notifier).setLocale(locale);
              onSelected?.call();
            },
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
      ],
    );
  }
}
