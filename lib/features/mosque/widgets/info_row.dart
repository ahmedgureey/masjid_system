import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Label + value row inside a profile section. Values are selectable so
/// phone numbers, emails and addresses can be copied.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.forceLtr = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Phone numbers, emails, URLs and coordinates stay left-to-right in
  /// Arabic layouts.
  final bool forceLtr;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
                const SizedBox(height: 2),
                SelectableText(
                  value,
                  textDirection: forceLtr ? TextDirection.ltr : null,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
