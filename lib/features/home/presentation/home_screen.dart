import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/brand_mark.dart';

/// Temporary Home placeholder confirming the project setup.
///
/// The real Home dashboard (next-prayer hero, quick actions, announcements,
/// bottom navigation) is built in a later phase following
/// `docs/design/screen-designs.md` §5.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> _plannedModules = [
    'Prayer times',
    'Donations',
    'Events',
    'Quran classes',
    'Notifications',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.semanticColors;

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: colors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: Row(
                  children: [
                    const BrandMark(size: 56),
                    const SizedBox(width: AppSpacing.space4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assalamu alaikum',
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space1),
                          Text(
                            AppDateFormatter.fullDate(DateTime.now()),
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.green100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project setup complete', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      'Theme, routing and folder structure are ready. '
                      'Features will be built in the next phases.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),
            Text('Planned modules', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.space3),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                for (final module in _plannedModules) Chip(label: Text(module)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
