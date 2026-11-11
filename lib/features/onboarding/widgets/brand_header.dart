import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/islamic_pattern.dart';

/// Dark-green header band with the Islamic pattern and a curved (arch)
/// bottom edge. Used by the language and welcome screens. Draws behind the
/// status bar; [child] is placed inside the safe area.
///
/// With [goldRim] a thin gold line follows the curved bottom edge.
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.child,
    this.goldRim = false,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.space6,
      AppSpacing.space6,
      AppSpacing.space6,
      AppSpacing.space8,
    ),
  });

  final Widget child;
  final bool goldRim;
  final EdgeInsetsGeometry padding;

  static const _curve = BorderRadius.vertical(
    bottom: Radius.elliptical(220, 40),
  );
  static const double _rimWidth = 3;

  @override
  Widget build(BuildContext context) {
    final header = ClipRRect(
      borderRadius: _curve,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: context.semanticColors.splashGradient,
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: IslamicPattern()),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: padding,
                // Full width so centered content is centered on screen.
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ],
        ),
      ),
    );

    if (!goldRim) return header;

    // Gold band of the same shape, slightly taller, behind the header.
    return ClipRRect(
      borderRadius: _curve,
      child: ColoredBox(
        color: AppColors.gold,
        child: Padding(
          padding: const EdgeInsets.only(bottom: _rimWidth),
          child: header,
        ),
      ),
    );
  }
}
