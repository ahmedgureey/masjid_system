import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../donations/application/finance_calculations.dart';
import '../../donations/widgets/donation_widgets.dart';
import '../models/project_category.dart';
import '../models/project_models.dart';

extension ProjectStatusLabels on ProjectStatus {
  String label(AppLocalizations l10n) => switch (this) {
    ProjectStatus.planned => l10n.projStatusPlanned,
    ProjectStatus.ongoing => l10n.projStatusOngoing,
    ProjectStatus.paused => l10n.projStatusPaused,
    ProjectStatus.completed => l10n.projStatusCompleted,
    ProjectStatus.cancelled => l10n.projStatusCancelled,
  };

  StatusChip chip(AppLocalizations l10n) => switch (this) {
    ProjectStatus.planned => StatusChip(
      label: label(l10n),
      type: StatusType.info,
      icon: Icons.event_note_rounded,
    ),
    ProjectStatus.ongoing => StatusChip(
      label: label(l10n),
      type: StatusType.success,
      icon: Icons.construction_rounded,
    ),
    ProjectStatus.paused => StatusChip(
      label: label(l10n),
      type: StatusType.warning,
      icon: Icons.pause_circle_outline_rounded,
    ),
    ProjectStatus.completed => StatusChip(
      label: label(l10n),
      type: StatusType.gold,
      icon: Icons.check_circle_outline_rounded,
    ),
    ProjectStatus.cancelled => StatusChip(
      label: label(l10n),
      type: StatusType.error,
      icon: Icons.cancel_outlined,
    ),
  };
}

extension MilestoneStatusLabels on MilestoneStatus {
  String label(AppLocalizations l10n) => switch (this) {
    MilestoneStatus.pending => l10n.projMilestonePending,
    MilestoneStatus.inProgress => l10n.projMilestoneInProgress,
    MilestoneStatus.completed => l10n.projMilestoneCompleted,
  };
}

/// Project image, or a branded placeholder with the category icon (no
/// images are uploaded yet).
class ProjectCover extends StatelessWidget {
  const ProjectCover({super.key, required this.project, this.iconSize = 48});

  final MosqueProject project;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.green600, AppColors.green800],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const IslamicPattern(),
          Center(
            child: Icon(
              projectCategoryById(project.categoryId).icon,
              size: iconSize,
              color: AppColors.gold300,
            ),
          ),
        ],
      ),
    );
    final url = project.coverImageUrl;
    if (url == null) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

/// Physical (construction / work) progress — shown separately from
/// funding progress.
class PhysicalProgressView extends StatelessWidget {
  const PhysicalProgressView({super.key, required this.percent});

  final int? percent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final p = percent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.construction_rounded,
              size: 18,
              color: semantic.goldText,
            ),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Text(
                l10n.projPhysicalProgress,
                style: textTheme.titleSmall,
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Text(
                p == null ? l10n.projProgressUnknown : '$p%',
                key: const Key('projectPhysicalPercent'),
                textAlign: TextAlign.end,
                style: textTheme.titleSmall?.copyWith(color: semantic.goldText),
              ),
            ),
          ],
        ),
        if (p != null) ...[
          const SizedBox(height: AppSpacing.space1),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: p / 100,
              minHeight: 8,
              color: semantic.gold,
              backgroundColor: semantic.goldBackground,
            ),
          ),
        ],
      ],
    );
  }
}

/// Project card for the list.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.funding,
    required this.mosqueName,
    required this.lang,
    required this.onTap,
  });

  final MosqueProject project;
  final CampaignProgress funding;
  final String? mosqueName;
  final String lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final category = projectCategoryById(project.categoryId);
    final date = project.expectedEndDate ?? project.startDate;
    return AppCard(
      onTap: onTap,
      semanticLabel: project.title,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: SizedBox(height: 110, child: ProjectCover(project: project)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  children: [
                    StatusChip(
                      label: category.name.resolve(lang),
                      icon: category.icon,
                    ),
                    project.status.chip(l10n),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  project.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  project.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: context.semanticColors.mutedText,
                  ),
                ),
                if (mosqueName != null || date != null) ...[
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    [
                      ?mosqueName,
                      if (date != null)
                        project.expectedEndDate != null
                            ? l10n.projExpectedEnd(
                                AppDateFormatter.shortDate(date, locale: lang),
                              )
                            : l10n.projStarts(
                                AppDateFormatter.shortDate(date, locale: lang),
                              ),
                    ].join(' · '),
                    style: textTheme.labelSmall?.copyWith(
                      color: context.semanticColors.mutedText,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.space3),
                CampaignProgressView(progress: funding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
