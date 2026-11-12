import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../donations/application/finance_services.dart';
import '../../donations/data/donations_repository.dart';
import '../../donations/models/donation_models.dart';
import '../../donations/widgets/donation_widgets.dart';
import '../../donations/widgets/finance_async.dart';
import '../../mosque/data/mosque_repository.dart';
import '../../news/application/article_share_service.dart';
import '../application/project_logic.dart';
import '../data/projects_repository.dart';
import '../models/project_category.dart';
import '../models/project_models.dart';
import '../widgets/project_widgets.dart';

/// Project details: information, funding (confirmed donations of the linked
/// campaign), physical progress, milestones, updates and admin actions.
class ProjectDetailsScreen extends ConsumerWidget {
  const ProjectDetailsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canManage = ref.watch(canManageProjectsProvider);
    final project = ref
        .watch(projectsProvider)
        .value
        ?.where((p) => p.id == projectId)
        .firstOrNull;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.projDetailsTitle,
        actions: [
          if (project != null)
            IconButton(
              key: const Key('projectShare'),
              tooltip: l10n.newsShare,
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _share(context, ref, project),
            ),
          if (project != null && canManage) ...[
            IconButton(
              key: const Key('projectEdit'),
              tooltip: l10n.profileEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () =>
                  context.pushIfCurrent(AppRoutes.editProject(project.id)),
            ),
            IconButton(
              key: const Key('projectDelete'),
              tooltip: l10n.commonDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _delete(context, ref, project),
            ),
          ],
        ],
      ),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<MosqueProject>, List<Donation>>(
          first: ref.watch(projectsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () {
            ref
              ..invalidate(projectsProvider)
              ..invalidate(donationsProvider);
          },
          builder: (_, donations) => project == null
              ? ScrollableCenter(
                  child: EmptyState(
                    icon: Icons.construction_rounded,
                    title: l10n.projNotFound,
                  ),
                )
              : _Details(project: project, donations: donations),
        ),
      ),
    );
  }

  /// Confirms, deletes, then leaves: staying on the details of a project
  /// that no longer exists would only show the "not found" empty state.
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    MosqueProject project,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!await confirmDelete(context, title: l10n.deleteProjectTitle)) return;

    try {
      await ref.read(projectsProvider.notifier).delete(project.id);
    } on Object {
      // The project is still there, so stay on the page and say so rather
      // than popping back to a list that still shows it.
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteFailed)));
      return;
    }
    if (navigator.canPop()) navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.deleteDone)));
  }

  Future<void> _share(
    BuildContext context,
    WidgetRef ref,
    MosqueProject project,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      // Title and summary only: projects have no public URL yet.
      await ref
          .read(articleShareServiceProvider)
          .share(
            subject: project.title,
            text: '${project.title}\n\n${project.summary}',
          );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.newsShareError)));
    }
  }
}

class _Details extends ConsumerWidget {
  const _Details({required this.project, required this.donations});

  final MosqueProject project;
  final List<Donation> donations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final lang = ref.watch(localeProvider).languageCode;
    final canManage = ref.watch(canManageProjectsProvider);
    final isFinanceStaff = ref.watch(canManageFinanceProvider);
    final mosqueName = ref.watch(mosqueProvider).value?.name.resolve(lang);
    final category = projectCategoryById(project.categoryId);
    final funding = ProjectLogic.funding(project, donations);
    // Expenses are finance data: only loaded (watched) for finance staff.
    final expenses = isFinanceStaff ? ref.watch(expensesProvider).value : null;
    final updates = ProjectLogic.visibleUpdates(
      ref.watch(projectUpdatesProvider).value ?? const [],
      project.id,
      canManage: canManage,
    );
    final campaignId = project.fundingCampaignId;
    // The linked campaign must also still be ACTIVE — otherwise the donate
    // screen would have nowhere correct to record the money.
    final canDonate = ProjectLogic.canAcceptDonations(
      project,
      ref.watch(campaignsProvider).value ?? const [],
    );
    String date(DateTime d) => AppDateFormatter.fullDate(d, locale: lang);

    Widget card(String title, List<Widget> children, {Key? key}) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.space3),
      child: AppCard(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: textTheme.titleSmall),
            const SizedBox(height: AppSpacing.space2),
            ...children,
          ],
        ),
      ),
    );

    // Not a lazy ListView: the page is moderate in length and every
    // section (updates, donate button) must be reachable and testable.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ProjectCover(project: project, iconSize: 72),
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
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
            key: const Key('projectTitle'),
            style: textTheme.headlineSmall?.copyWith(
              color: semantic.brandText,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (project.isSample) ...[
            const SizedBox(height: AppSpacing.space2),
            DonationNotice(
              icon: Icons.science_outlined,
              text: l10n.projSampleTitle,
            ),
          ],
          card(l10n.projInfo, [
            DetailRow(
              label: l10n.projCategory,
              value: category.name.resolve(lang),
            ),
            if (mosqueName != null)
              DetailRow(label: l10n.projMosque, value: mosqueName),
            if (project.location != null)
              DetailRow(label: l10n.projLocation, value: project.location!),
            if (canManage && project.manager != null)
              DetailRow(label: l10n.projManager, value: project.manager!),
            if (project.startDate != null)
              DetailRow(
                label: l10n.donStartDate,
                value: date(project.startDate!),
              ),
            if (project.expectedEndDate != null)
              DetailRow(
                label: l10n.projExpectedEndLabel,
                value: date(project.expectedEndDate!),
              ),
            DetailRow(
              label: l10n.projLastUpdated,
              value: date(project.updatedAt),
            ),
          ]),
          card(l10n.eventDescription, [
            Text(
              project.description.isEmpty
                  ? project.summary
                  : project.description,
            ),
            if (project.objectives != null) ...[
              const SizedBox(height: AppSpacing.space2),
              Text(l10n.projObjectives, style: textTheme.labelLarge),
              Text(project.objectives!),
            ],
            if (project.beneficiaries != null) ...[
              const SizedBox(height: AppSpacing.space2),
              Text(l10n.projBeneficiaries, style: textTheme.labelLarge),
              Text(project.beneficiaries!),
            ],
          ]),
          card(key: const Key('projectFunding'), l10n.projFunding, [
            CampaignProgressView(progress: funding),
            const Divider(height: AppSpacing.space6),
            DetailRow(
              label: l10n.projBudget,
              value: project.budget.format(),
              valueKey: const Key('projectBudget'),
            ),
            DetailRow(
              label: l10n.projFundingTarget,
              value: project.effectiveFundingTarget.format(),
            ),
            DetailRow(
              label: l10n.donConfirmedReceived,
              value: funding.raised.format(),
              valueKey: const Key('projectRaised'),
            ),
            DetailRow(
              label: l10n.donRemainingLabel,
              value: funding.remaining.format(),
              valueKey: const Key('projectRemaining'),
            ),
            if (isFinanceStaff && expenses != null)
              DetailRow(
                label: l10n.projApprovedExpenses,
                value: ProjectLogic.approvedExpenses(
                  project.id,
                  expenses,
                  project.budget.currency,
                ).format(),
                valueKey: const Key('projectExpenses'),
              ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              campaignId == null ? l10n.projNoCampaign : l10n.projFundingRule,
              style: textTheme.bodySmall?.copyWith(color: semantic.mutedText),
            ),
            const SizedBox(height: AppSpacing.space1),
            Text(
              l10n.projReportsPending,
              style: textTheme.bodySmall?.copyWith(color: semantic.mutedText),
            ),
          ]),
          card(key: const Key('projectProgress'), l10n.projProgress, [
            PhysicalProgressView(percent: project.physicalProgress),
            if (project.progressNote != null) ...[
              const SizedBox(height: AppSpacing.space2),
              Text(project.progressNote!, style: textTheme.bodySmall),
            ],
            const SizedBox(height: AppSpacing.space2),
            Text(
              l10n.projProgressSeparate,
              style: textTheme.bodySmall?.copyWith(color: semantic.mutedText),
            ),
            if (project.milestones.isNotEmpty) ...[
              const Divider(height: AppSpacing.space6),
              Text(l10n.projMilestones, style: textTheme.titleSmall),
              for (final m in project.milestones)
                ListTile(
                  key: ValueKey('milestone-${m.id}'),
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    m.isCompleted
                        ? Icons.check_circle_rounded
                        : (m.status == MilestoneStatus.inProgress
                              ? Icons.timelapse_rounded
                              : Icons.radio_button_unchecked_rounded),
                    color: m.isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : semantic.mutedText,
                  ),
                  title: Text(m.title),
                  subtitle: Text(
                    [
                      m.status.label(l10n),
                      if (m.completedDate != null)
                        AppDateFormatter.shortDate(
                          m.completedDate!,
                          locale: lang,
                        )
                      else if (m.dueDate != null)
                        l10n.projDue(
                          AppDateFormatter.shortDate(m.dueDate!, locale: lang),
                        ),
                    ].join(' · '),
                  ),
                ),
            ],
          ]),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space4),
            child: SectionHeader(title: l10n.projUpdates),
          ),
          if (canManage)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                key: const Key('projectAddUpdate'),
                onPressed: () => context.pushIfCurrent(
                  AppRoutes.newProjectUpdate(project.id),
                ),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.projAddUpdate),
              ),
            ),
          if (updates.isEmpty)
            Text(
              l10n.projNoUpdates,
              style: textTheme.bodySmall?.copyWith(color: semantic.mutedText),
            )
          else
            for (final u in updates)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space2),
                child: AppCard(
                  key: ValueKey('update-${u.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.space2,
                        runSpacing: AppSpacing.space1,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            u.title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (!u.isPublished) StatusChip(label: l10n.projDraft),
                        ],
                      ),
                      Text(
                        '${date(u.date)} · ${u.author}'
                        '${u.progressPercent == null ? '' : ' · ${u.progressPercent}%'}',
                        style: textTheme.labelSmall?.copyWith(
                          color: semantic.mutedText,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space1),
                      Text(u.description),
                      if (canManage && u.revisions.isNotEmpty)
                        Text(
                          l10n.projEditedTimes(u.revisions.length),
                          style: textTheme.labelSmall?.copyWith(
                            color: semantic.mutedText,
                          ),
                        ),
                      if (canManage)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            key: ValueKey('editUpdate-${u.id}'),
                            onPressed: () => context.pushIfCurrent(
                              AppRoutes.editProjectUpdate(project.id, u.id),
                            ),
                            child: Text(l10n.profileEdit),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          if (canManage && project.history.isNotEmpty)
            card(key: const Key('projectHistory'), l10n.projHistory, [
              for (final h in project.history.reversed)
                Text(
                  '${AppDateFormatter.shortDate(h.at, locale: lang)} ${h.at.year}'
                  ' · ${h.actor} · ${h.note}',
                  style: textTheme.bodySmall,
                ),
            ]),
          const SizedBox(height: AppSpacing.space4),
          AppButton.primary(
            key: const Key('projectDonate'),
            label: l10n.projDonate,
            icon: Icons.favorite_rounded,
            expand: true,
            onPressed: canDonate
                ? () => context.pushIfCurrent(
                    // canDonate guarantees a linked campaign.
                    AppRoutes.donateToProject(project.id, campaignId!),
                  )
                : null,
          ),
          if (!canDonate) ...[
            const SizedBox(height: AppSpacing.space1),
            Text(
              campaignId == null
                  ? l10n.projNoCampaign
                  : l10n.projClosedForDonations,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: semantic.mutedText),
            ),
          ],
        ],
      ),
    );
  }
}
