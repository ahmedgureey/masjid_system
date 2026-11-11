import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

/// Rounded card with an icon + heading. When [children] is empty it shows
/// "No information added yet" and, for administrators, an "Add information"
/// action.
class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.onAdd,
    this.emptyMessage,
    this.footnote,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  /// Shown only for authorized users when the section is empty.
  final VoidCallback? onAdd;
  final String? emptyMessage;

  /// Small note at the bottom (e.g. privacy notice).
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.green50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.green800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          const Divider(),
          if (children.isEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              emptyMessage ?? l10n.profileNoData,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            if (onAdd != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.profileAddInfo),
                ),
              ),
          ] else
            ...children,
          if (footnote != null) ...[
            const SizedBox(height: AppSpacing.space2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: AppColors.neutral500,
                ),
                const SizedBox(width: AppSpacing.space2),
                Expanded(
                  child: Text(
                    footnote!,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
