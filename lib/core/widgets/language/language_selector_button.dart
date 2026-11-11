import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../localization/l10n.dart';
import '../../localization/locale_provider.dart';
import '../../theme/app_spacing.dart';
import 'language_options_list.dart';

/// Bottom sheet with the three languages; closes after a choice.
void showLanguageSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space6,
          0,
          AppSpacing.space6,
          AppSpacing.space4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              sheetContext.l10n.language,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.space4),
            LanguageOptionsList(
              onSelected: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}

/// "🌐 Luqadda: Soomaali ▾" — opens a bottom sheet with the three languages.
/// Switching works (and is saved on the device).
class LanguageSelectorButton extends ConsumerWidget {
  const LanguageSelectorButton({super.key});

  String _languageName(AppLocalizations l10n, Locale locale) =>
      switch (locale.languageCode) {
        'ar' => l10n.languageArabic,
        'so' => l10n.languageSomali,
        _ => l10n.languageEnglish,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(localeProvider);

    return TextButton(
      onPressed: () => showLanguageSheet(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language_rounded, size: 20),
          const SizedBox(width: AppSpacing.space2),
          Flexible(
            child: Text('${l10n.language}: ${_languageName(l10n, locale)}'),
          ),
          const SizedBox(width: AppSpacing.space1),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ],
      ),
    );
  }
}
