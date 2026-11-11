import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Onboarding page dots: active page is a green pill. Order follows text
/// direction automatically (reversed in Arabic).
class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: context.l10n.onboardingPageLabel(index + 1, count),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++)
              AnimatedContainer(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space1,
                ),
                width: i == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == index ? AppColors.primary : AppColors.neutral200,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
