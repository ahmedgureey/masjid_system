import 'package:material_ui/material_ui.dart';

import '../localization/l10n.dart';
import '../theme/app_spacing.dart';

/// Section title with an optional "See all ›" link.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.actionLabel,
  });

  final String title;
  final VoidCallback? onSeeAll;

  /// Defaults to "See all".
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel ?? context.l10n.commonSeeAll),
                  // chevron_right mirrors automatically in RTL.
                  const Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
