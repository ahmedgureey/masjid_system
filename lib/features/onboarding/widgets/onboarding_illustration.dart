import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/islamic_pattern.dart';

/// Placeholder illustration until final artwork exists: a mihrab-arch shape
/// (green-50 with a faint pattern) holding a large green symbol and a small
/// gold badge. Sizes itself to the available space.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.icon,
    required this.accentIcon,
  });

  final IconData icon;
  final IconData accentIcon;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.clamp(0.0, 280.0);
          final height = constraints.maxHeight.isFinite
              ? constraints.maxHeight.clamp(0.0, width * 1.15)
              : width * 1.15;
          final iconSize = (height * 0.38).clamp(32.0, 120.0);
          final badgeSize = (iconSize * 0.55).clamp(28.0, 64.0);

          return Center(
            child: SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                // Mihrab arch: rounded top, square bottom.
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(width / 2),
                  bottom: const Radius.circular(24),
                ),
                child: ColoredBox(
                  color: AppColors.green50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Positioned.fill(
                        child: IslamicPattern(
                          color: AppColors.green600,
                          opacity: 0.08,
                          tileSize: 44,
                        ),
                      ),
                      Icon(icon, size: iconSize, color: AppColors.primary),
                      PositionedDirectional(
                        end: width * 0.18,
                        top: height * 0.22,
                        child: Container(
                          width: badgeSize,
                          height: badgeSize,
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            accentIcon,
                            size: badgeSize * 0.55,
                            // Dark on gold (6.98:1).
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
