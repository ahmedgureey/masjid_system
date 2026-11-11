import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/brand_mark.dart';

/// Logo + title + subtitle at the top of the auth screens.
/// The gold brand mark sits on a dark-green circle (gold needs a dark
/// background for contrast).
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: context.semanticColors.splashGradient,
          ),
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.space2),
            child: BrandMark(size: 56),
          ),
        ),
        const SizedBox(height: AppSpacing.space5),
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }
}
