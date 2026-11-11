import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
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
    final (background, borderColor) = switch (variant) {
      AppCardVariant.standard => (AppColors.white, AppColors.neutral200),
      AppCardVariant.tinted => (AppColors.green50, Colors.transparent),
      AppCardVariant.gold => (AppColors.gold50, Colors.transparent),
      AppCardVariant.outlined => (AppColors.white, AppColors.neutral200),
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
