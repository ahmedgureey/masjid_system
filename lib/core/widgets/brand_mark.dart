import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

/// The app's brand mark: a gold mosque symbol inside a gold ring.
///
/// Designed for dark green backgrounds (splash, hero cards), where gold has
/// sufficient contrast. Temporary until the final app-icon artwork exists.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Masjid Management App logo',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.green900.withValues(alpha: 0.35),
          border: Border.all(color: AppColors.gold, width: size * 0.03),
        ),
        child: Icon(
          Icons.mosque_rounded,
          size: size * 0.55,
          color: AppColors.gold,
        ),
      ),
    );
  }
}
