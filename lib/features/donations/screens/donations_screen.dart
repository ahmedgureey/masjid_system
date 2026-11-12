import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../application/finance_calculations.dart';
import '../application/finance_services.dart';
import '../data/donations_repository.dart';
import '../models/donation_models.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';

/// "Deeqaha" — overview: explanation, quick actions, active campaigns.
class DonationsScreen extends ConsumerWidget {
  const DonationsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(campaignsProvider)
      ..invalidate(donationsProvider);
    await ref.read(campaignsProvider.future);
  }

  /// Clears the whole "TUSAALE" set after confirming. Real donations and
  /// expenses are untouched: those are voided, never deleted.
  Future<void> _clearSamples(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    if (!await confirmDelete(context, title: l10n.deleteSamplesTitle)) return;

    try {
      await ref.read(donationsProvider.notifier).clearSampleData();
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteFailed)));
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text(l10n.deleteDone)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canManage = ref.watch(canManageFinanceProvider);

    return Scaffold(
      appBar: AppTopBar(title: l10n.donTitle),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () => _refresh(ref),
          builder: (campaigns, donations) {
            final active = campaigns
                .where((c) => c.status == CampaignStatus.active)
                .toList();
            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView(
                key: const Key('donationsList'),
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.space4),
                children: [
                  HeroCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.volunteer_activism_rounded,
                          color: AppColors.gold300,
                          size: 32,
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        Text(
                          l10n.donIntro,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  if (campaigns.any((c) => c.isSample)) ...[
                    const SizedBox(height: AppSpacing.space3),
                    DonationNotice(
                      key: const Key('donationsSampleNotice'),
                      icon: Icons.science_outlined,
                      title: l10n.donSampleTitle,
                      text: l10n.donSampleMessage,
                      // Only an administrator may clear it, and the way out
                      // sits in the warning itself. Real donations and
                      // expenses are voided, never deleted, so this touches
                      // the sample set alone.
                      action: canManage
                          ? TextButton.icon(
                              key: const Key('clearSampleData'),
                              onPressed: () => _clearSamples(context, ref),
                              icon: const Icon(
                                Icons.delete_sweep_outlined,
                                size: 18,
                              ),
                              label: Text(l10n.deleteSamplesAction),
                            )
                          : null,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.space4),
                  _QuickActions(canManage: canManage),
                  const SizedBox(height: AppSpacing.space3),
                  DonationNotice(
                    icon: Icons.info_outline_rounded,
                    variant: AppCardVariant.tinted,
                    title: l10n.donConfirmedVsPendingTitle,
                    text: l10n.donConfirmedVsPendingBody,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  SectionHeader(
                    title: l10n.donActiveCampaigns,
                    actionLabel: l10n.donSeeAll,
                    onSeeAll: () =>
                        context.pushIfCurrent(AppRoutes.donationCampaigns),
                  ),
                  if (active.isEmpty)
                    EmptyState(
                      icon: Icons.campaign_outlined,
                      title: l10n.donNoCampaigns,
                      message: l10n.donNoCampaignsMessage,
                    )
                  else
                    for (final c in active)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.space3,
                        ),
                        child: CampaignCard(
                          key: ValueKey('campaign-${c.id}'),
                          campaign: c,
                          progress: FinanceCalculations.campaignProgress(
                            c,
                            donations,
                          ),
                          onTap: () =>
                              context.pushIfCurrent(AppRoutes.campaign(c.id)),
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.canManage});

  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget action(Key key, IconData icon, String label, String route) =>
        _ActionTile(
          key: key,
          icon: icon,
          label: label,
          onTap: () => context.pushIfCurrent(route),
        );
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: action(
                  const Key('donQuickDonate'),
                  Icons.favorite_rounded,
                  l10n.donDonate,
                  AppRoutes.donate,
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: action(
                  const Key('donQuickHistory'),
                  Icons.history_rounded,
                  l10n.donHistoryTitle,
                  AppRoutes.donationHistory,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space3),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: action(
                  const Key('donQuickCampaigns'),
                  Icons.campaign_rounded,
                  l10n.donCampaignsTitle,
                  AppRoutes.donationCampaigns,
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: canManage
                    ? action(
                        const Key('donQuickStaff'),
                        Icons.admin_panel_settings_outlined,
                        l10n.donStaffTitle,
                        AppRoutes.financeStaff,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.green100),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space3),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: AppSpacing.space2),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(color: AppColors.green800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
