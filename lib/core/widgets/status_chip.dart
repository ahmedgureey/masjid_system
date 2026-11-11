import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum StatusType { success, warning, error, info, neutral, gold }

/// Small status label: icon + text + color (never color alone).
/// Examples: Approved, Pending, Voided, Present, Absent, Registered, Next.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusType.neutral,
    this.icon,
  });

  final String label;
  final StatusType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (type) {
      StatusType.success => (AppColors.successContainer, AppColors.success),
      StatusType.warning => (AppColors.warningContainer, AppColors.warning),
      StatusType.error => (AppColors.errorContainer, AppColors.error),
      StatusType.info => (AppColors.infoContainer, AppColors.info),
      StatusType.neutral =>
        Theme.of(context).brightness == Brightness.dark
            ? (AppColors.darkSurfaceRaised, AppColors.darkTextMuted)
            : (AppColors.neutral50, AppColors.neutral600),
      // Gold fill always uses dark text (gold on white fails contrast).
      StatusType.gold => (AppColors.gold, AppColors.darkText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space2,
        vertical: AppSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: AppSpacing.space1),
          ],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
