import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Dark-green header: logo, name, description, type, and (for
/// administrators) the edit button.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.descriptionText,
    this.categoryLabel,
    this.logoUrl,
    this.onEdit,
    this.editLabel,
  });

  final String name;

  /// Description, or the "not added yet" message.
  final String descriptionText;
  final String? categoryLabel;
  final String? logoUrl;
  final VoidCallback? onEdit;
  final String? editLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return HeroCard(
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: logoUrl != null
                  ? Image.network(logoUrl!, fit: BoxFit.cover)
                  : const ColoredBox(
                      color: AppColors.green800,
                      child: Center(child: BrandMark(size: 64)),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            name,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(color: AppColors.white),
          ),
          if (categoryLabel != null) ...[
            const SizedBox(height: AppSpacing.space2),
            StatusChip(
              label: categoryLabel!,
              type: StatusType.gold,
              icon: Icons.mosque_rounded,
            ),
          ],
          const SizedBox(height: AppSpacing.space2),
          Text(
            descriptionText,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.green100),
          ),
          if (onEdit != null && editLabel != null) ...[
            const SizedBox(height: AppSpacing.space4),
            AppButton.accent(
              label: editLabel!,
              icon: Icons.edit_rounded,
              size: AppButtonSize.small,
              onPressed: onEdit,
            ),
          ],
        ],
      ),
    );
  }
}
