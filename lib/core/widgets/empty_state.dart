import 'package:material_ui/material_ui.dart';

import '../localization/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

/// Shown when a list or screen has no content.
/// Icon + title + one-line explanation + optional primary action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      icon: icon,
      iconColor: AppColors.primary,
      iconBackground: AppColors.green50,
      title: title ?? context.l10n.emptyGenericTitle,
      message: message ?? context.l10n.emptyGenericMessage,
      action: actionLabel != null && onAction != null
          ? AppButton.primary(label: actionLabel!, onPressed: onAction)
          : null,
    );
  }
}

/// Shared layout for empty and error states.
class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.space5),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown when loading fails. Friendly message + "Try again".
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.title, this.message, this.onRetry});

  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _StateLayout(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      iconBackground: AppColors.errorContainer,
      title: title ?? l10n.errorGenericTitle,
      message: message ?? l10n.errorGenericMessage,
      action: onRetry != null
          ? AppButton.secondary(
              label: l10n.commonRetry,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            )
          : null,
    );
  }
}

/// Full-width warning banner shown at the top of screens when offline.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        color: AppColors.warningContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.errorOfflineTitle,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                  Text(
                    l10n.errorOfflineMessage,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
