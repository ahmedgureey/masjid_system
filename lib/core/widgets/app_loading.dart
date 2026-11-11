import 'package:material_ui/material_ui.dart';

import '../localization/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Centered spinner with optional message — for actions and short waits.
/// For first loads of lists prefer [AppSkeleton] placeholders.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.message, this.showMessage = true});

  final String? message;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    final text = message ?? context.l10n.commonLoading;
    return Center(
      child: Semantics(
        liveRegion: true,
        label: text,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(
              dimension: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            if (showMessage) ...[
              const SizedBox(height: AppSpacing.space3),
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.neutral500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Grey placeholder block shaped like the content that is loading.
/// Static (no shimmer animation) — cheap on low-end phones and fine with
/// reduced motion.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AppRadius.sm,
  });

  /// A circle, e.g. avatar placeholder.
  const AppSkeleton.circle({super.key, double size = 40})
    : width = size,
      height = size,
      radius = AppRadius.full;

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A list-row skeleton (avatar + two lines), repeated [count] times.
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space2),
            child: Row(
              children: [
                AppSkeleton.circle(),
                SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSkeleton(height: 14),
                      SizedBox(height: AppSpacing.space2),
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: AppSkeleton(height: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
