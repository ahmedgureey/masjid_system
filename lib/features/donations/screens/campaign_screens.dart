import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/finance_calculations.dart';
import '../data/donations_repository.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';

/// All public campaigns, filterable by status and category.
class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  CampaignStatus? _status = CampaignStatus.active;
  CampaignCategory? _category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppTopBar(title: l10n.donCampaignsTitle),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () {
            ref
              ..invalidate(campaignsProvider)
              ..invalidate(donationsProvider);
          },
          builder: (campaigns, donations) {
            final visible = campaigns
                .where(
                  (c) =>
                      (_status == null || c.status == _status) &&
                      (_category == null || c.category == _category),
                )
                .toList();
            Widget chip<T>(
              Key key,
              String label,
              T? value,
              T? current,
              ValueChanged<T?> onSelected,
            ) => Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.space2),
              child: ChoiceChip(
                key: key,
                label: Text(label),
                selected: value == current,
                onSelected: (_) => onSelected(value),
              ),
            );
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      chip<CampaignStatus>(
                        const Key('campStatus-all'),
                        l10n.donFilterAll,
                        null,
                        _status,
                        (v) => setState(() => _status = v),
                      ),
                      for (final s in [
                        CampaignStatus.active,
                        CampaignStatus.completed,
                      ])
                        chip<CampaignStatus>(
                          ValueKey('campStatus-${s.name}'),
                          s.label(l10n),
                          s,
                          _status,
                          (v) => setState(() => _status = v),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      chip<CampaignCategory>(
                        const Key('campCat-all'),
                        l10n.donAllCategories,
                        null,
                        _category,
                        (v) => setState(() => _category = v),
                      ),
                      for (final c in CampaignCategory.values)
                        chip<CampaignCategory>(
                          ValueKey('campCat-${c.name}'),
                          c.label(l10n),
                          c,
                          _category,
                          (v) => setState(() => _category = v),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                if (visible.isEmpty)
                  EmptyState(
                    icon: Icons.campaign_outlined,
                    title: l10n.donNoCampaigns,
                    message: l10n.donNoCampaignsFilter,
                  )
                else
                  for (final c in visible)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
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
            );
          },
        ),
      ),
    );
  }
}

/// Campaign details with confirmed progress and the donate button.
class CampaignDetailsScreen extends ConsumerWidget {
  const CampaignDetailsScreen({super.key, required this.campaignId});

  final String campaignId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final mosque = ref.watch(mosqueProvider).value;

    return Scaffold(
      appBar: AppTopBar(title: l10n.donCampaignDetails),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () {
            ref
              ..invalidate(campaignsProvider)
              ..invalidate(donationsProvider);
          },
          builder: (campaigns, donations) {
            final c = campaigns.where((x) => x.id == campaignId).firstOrNull;
            if (c == null) {
              return ScrollableCenter(
                child: EmptyState(
                  icon: Icons.campaign_outlined,
                  title: l10n.donCampaignNotFound,
                ),
              );
            }
            final progress = FinanceCalculations.campaignProgress(c, donations);
            final canDonate = c.status == CampaignStatus.active;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CampaignCover(campaign: c, iconSize: 72),
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  children: [
                    StatusChip(
                      label: c.category.label(l10n),
                      icon: c.category.icon,
                    ),
                    StatusChip(
                      label: c.status.label(l10n),
                      type: c.status.type,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  c.title,
                  key: const Key('campaignTitle'),
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.green800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (c.isSample) ...[
                  const SizedBox(height: AppSpacing.space2),
                  DonationNotice(
                    icon: Icons.science_outlined,
                    text: l10n.donSampleTitle,
                  ),
                ],
                const SizedBox(height: AppSpacing.space3),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CampaignProgressView(progress: progress),
                      const Divider(height: AppSpacing.space6),
                      DetailRow(
                        label: l10n.donTarget,
                        value: progress.target.format(),
                      ),
                      DetailRow(
                        label: l10n.donConfirmedReceived,
                        value: progress.raised.format(),
                      ),
                      DetailRow(
                        label: l10n.donRemainingLabel,
                        value: progress.remaining.format(),
                        valueKey: const Key('campaignRemaining'),
                      ),
                      DetailRow(
                        label: l10n.donCurrencyLabel,
                        value: c.currency.code,
                      ),
                      if (c.startDate != null)
                        DetailRow(
                          label: l10n.donStartDate,
                          value: AppDateFormatter.fullDate(
                            c.startDate!,
                            locale: lang,
                          ),
                        ),
                      if (c.endDate != null)
                        DetailRow(
                          label: l10n.donEndDate,
                          value: AppDateFormatter.fullDate(
                            c.endDate!,
                            locale: lang,
                          ),
                        ),
                    ],
                  ),
                ),
                if (progress.raised.isZero) ...[
                  const SizedBox(height: AppSpacing.space3),
                  DonationNotice(
                    key: const Key('campaignNoDonations'),
                    icon: Icons.info_outline_rounded,
                    variant: AppCardVariant.tinted,
                    text: l10n.donNoConfirmedYet,
                  ),
                ],
                const SizedBox(height: AppSpacing.space3),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.eventDescription, style: textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.space2),
                      Text(c.description),
                    ],
                  ),
                ),
                if (mosque != null) ...[
                  const SizedBox(height: AppSpacing.space3),
                  AppCard(
                    variant: AppCardVariant.outlined,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mosque_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: Text(
                            mosque.name.resolve(lang),
                            style: textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.space4),
                AppButton.primary(
                  key: const Key('campaignDonateButton'),
                  label: l10n.donDonate,
                  icon: Icons.favorite_rounded,
                  expand: true,
                  onPressed: canDonate
                      ? () => context.pushIfCurrent(AppRoutes.donateTo(c.id))
                      : null,
                ),
                if (!canDonate) ...[
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    l10n.donCampaignClosed,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
