import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/islamic_pattern.dart';

/// Dark-green header band with the Islamic pattern and a curved (arch)
/// bottom edge. Used by the language and welcome screens. Draws behind the
/// status bar; [child] is placed inside the safe area.
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.elliptical(220, 40),
      ),
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
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.space6,
                  AppSpacing.space6,
                  AppSpacing.space6,
                  AppSpacing.space8,
                ),
                // Full width so centered content is centered on screen.
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
