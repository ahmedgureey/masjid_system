import 'package:material_ui/material_ui.dart';

import '../core/localization/l10n.dart';
import '../core/widgets/widgets.dart';

/// TEMPORARY — stands in for screens of upcoming modules so that every
/// button navigates somewhere (no broken routes). Replaced module by module.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String Function(AppLocalizations l10n) title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppTopBar(title: title(l10n)),
      body: EmptyState(
        icon: Icons.construction_rounded,
        title: l10n.comingSoonTitle,
        message: l10n.comingSoonMessage,
      ),
    );
  }
}
