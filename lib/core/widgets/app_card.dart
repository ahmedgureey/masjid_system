import 'package:material_ui/material_ui.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_spacing.dart';

enum AppCardVariant {
  /// White card with subtle border and shadow (default).
  standard,

  /// Green-50 background, no border — highlights, success, info.
  tinted,

  /// Gold-50 background — featured items, campaigns.
  gold,

  /// White with border only — dense content inside other cards.
  outlined,
}

/// Base card. Spec: `docs/design/reusable-components.md` §3.
/// When [onTap] is set the whole card is the tap target.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.variant = AppCardVariant.standard,
    this.padding = const EdgeInsets.all(AppSpacing.space4),
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final (background, borderColor) = switch (variant) {
      AppCardVariant.standard => (semantic.cardBackground, semantic.cardBorder),
      AppCardVariant.tinted => (semantic.tintedBackground, Colors.transparent),
      AppCardVariant.gold => (semantic.goldBackground, Colors.transparent),
      AppCardVariant.outlined => (semantic.cardBackground, semantic.cardBorder),
    };
    final borderRadius = BorderRadius.circular(AppRadius.lg);

    final card = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: variant == AppCardVariant.standard
            ? const [
                BoxShadow(
                  color: Color(0x0F1F2937), // darkText at 6%
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    if (onTap == null && semanticLabel == null) return card;
    return Semantics(button: onTap != null, label: semanticLabel, child: card);
  }
}
