import 'package:material_ui/material_ui.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_spacing.dart';
import 'islamic_pattern.dart';

/// Dark-green gradient card with the Islamic pattern — used for the next
/// prayer, finance balance and class highlights.
/// Text on it: white, `green-100` for secondary, `goldOnDark` for gold.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.space5),
    this.showPattern = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool showPattern;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.xl);
    return Semantics(
      button: onTap != null,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: context.semanticColors.heroGradient,
          ),
          child: Stack(
            children: [
              if (showPattern) const Positioned.fill(child: IslamicPattern()),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(padding: padding, child: child),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
