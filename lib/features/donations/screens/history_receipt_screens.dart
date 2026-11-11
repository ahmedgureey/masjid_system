import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/finance_services.dart';
import '../data/donations_repository.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';

/// Time windows for the history date filter.
enum HistoryPeriod { all, last30Days, thisYear }

/// Pure filter used by the history screen (unit tested).
List<Donation> filterDonationHistory(
  Iterable<Donation> donations, {
  required DonationStateFilter state,
  String? campaignId,
  HistoryPeriod period = HistoryPeriod.all,
  required DateTime now,
  String query = '',
  Map<String, String> campaignTitles = const {},
}) {
  final q = query.trim().toLowerCase();
  final today = CalendarUtils.dateOnly(now);
  final from = switch (period) {
    HistoryPeriod.all => null,
    HistoryPeriod.last30Days => DateTime(
      today.year,
      today.month,
      today.day - 30,
    ),
    HistoryPeriod.thisYear => DateTime(today.year),
  };
  final list =
      donations
          .where(
            (d) =>
                state.matches(d) &&
                (campaignId == null || d.campaignId == campaignId) &&
                (from == null || !d.date.isBefore(from)) &&
                (q.isEmpty ||
                    d.reference.toLowerCase().contains(q) ||
                    (campaignTitles[d.campaignId] ?? '').toLowerCase().contains(
                      q,
                    )),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  return list;
}

/// "Taariikhda deeqaha" — the signed-in user's own records only.
class DonationHistoryScreen extends ConsumerStatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  ConsumerState<DonationHistoryScreen> createState() =>
      _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends ConsumerState<DonationHistoryScreen> {
  final _search = TextEditingController();
  DonationStateFilter _state = DonationStateFilter.all;
  String? _campaignId;
  HistoryPeriod _period = HistoryPeriod.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = ref.watch(donorUserIdProvider);
    final lang = ref.watch(localeProvider).languageCode;
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return Scaffold(
      appBar: AppTopBar(title: l10n.donHistoryTitle),
      body: SafeArea(
        top: false,
        child: userId == null
            ? ScrollableCenter(
                child: EmptyState(
                  icon: Icons.lock_outline_rounded,
                  title: l10n.donHistoryTitle,
                  message: l10n.donHistorySignIn,
                  actionLabel: l10n.newsSignIn,
                  onAction: () => context.push(AppRoutes.login),
                ),
              )
            : FinanceAsync<List<DonationCampaign>, List<Donation>>(
                first: ref.watch(campaignsProvider),
                second: ref.watch(donationsProvider),
                onRetry: () => ref.invalidate(donationsProvider),
                builder: (campaigns, donations) {
                  final titles = {for (final c in campaigns) c.id: c.title};
                  // Users only ever see their own records.
                  final mine = donations.where((d) => d.userId == userId);
                  final visible = filterDonationHistory(
                    mine,
                    state: _state,
                    campaignId: _campaignId,
                    period: _period,
                    now: now,
                    query: _search.text,
                    campaignTitles: titles,
                  );
                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.space4),
                    children: [
                      TextField(
                        key: const Key('historySearch'),
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: l10n.donHistorySearch,
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      _FilterRow<DonationStateFilter>(
                        values: DonationStateFilter.values,
                        selected: _state,
                        label: (v) => v.label(l10n),
                        keyPrefix: 'historyState',
                        onSelected: (v) => setState(() => _state = v),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      _FilterRow<HistoryPeriod>(
                        values: HistoryPeriod.values,
                        selected: _period,
                        label: (v) => switch (v) {
                          HistoryPeriod.all => l10n.donPeriodAll,
                          HistoryPeriod.last30Days => l10n.donPeriod30,
                          HistoryPeriod.thisYear => l10n.donPeriodYear,
                        },
                        keyPrefix: 'historyPeriod',
                        onSelected: (v) => setState(() => _period = v),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      DropdownButtonFormField<String?>(
                        key: const Key('historyCampaign'),
                        initialValue: _campaignId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.donCampaign,
                        ),
                        onChanged: (v) => setState(() => _campaignId = v),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.donFilterAll),
                          ),
                          for (final c in campaigns)
                            DropdownMenuItem(
                              value: c.id,
                              child: Text(
                                c.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      Text(
                        l10n.donHistoryPrivacy,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.neutral500),
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      if (visible.isEmpty)
                        EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: l10n.donHistoryEmpty,
                          message: mine.isEmpty
                              ? l10n.donHistoryEmptyMessage
                              : l10n.donHistoryNoMatch,
                        )
                      else
                        for (final d in visible)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.space3,
                            ),
                            child: DonationTile(
                              key: ValueKey('history-${d.id}'),
                              donation: d,
                              campaignTitle: titles[d.campaignId] ?? '—',
                              lang: lang,
                              trailing: d.hasReceipt
                                  ? IconButton(
                                      tooltip: l10n.donReceipt,
                                      icon: const Icon(
                                        Icons.receipt_long_rounded,
                                      ),
                                      onPressed: () => context.pushIfCurrent(
                                        AppRoutes.receipt(d.id),
                                      ),
                                    )
                                  : null,
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

class _FilterRow<T> extends StatelessWidget {
  const _FilterRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.keyPrefix,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final String keyPrefix;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final v in values)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.space2),
              child: ChoiceChip(
                key: ValueKey('$keyPrefix-${(v as Enum).name}'),
                label: Text(label(v)),
                selected: v == selected,
                onSelected: (_) => onSelected(v),
              ),
            ),
        ],
      ),
    );
  }
}

/// Receipt of a donation. Only confirmed real donations have a receipt;
/// visible to the donation owner or staff.
class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({super.key, required this.donationId});

  final String donationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final userId = ref.watch(donorUserIdProvider);
    final isStaff = ref.watch(canManageFinanceProvider);
    final mosque = ref.watch(mosqueProvider).value;

    return Scaffold(
      appBar: AppTopBar(title: l10n.donReceipt),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () => ref.invalidate(donationsProvider),
          builder: (campaigns, donations) {
            final d = donations.where((x) => x.id == donationId).firstOrNull;
            final allowed =
                d != null &&
                (isStaff || (userId != null && d.userId == userId));
            if (d == null || !allowed || !d.hasReceipt) {
              return ScrollableCenter(
                child: EmptyState(
                  key: const Key('receiptUnavailable'),
                  icon: Icons.receipt_long_outlined,
                  title: l10n.donReceiptUnavailable,
                  message: l10n.donReceiptUnavailableMessage,
                ),
              );
            }
            final title =
                campaigns
                    .where((c) => c.id == d.campaignId)
                    .firstOrNull
                    ?.title ??
                '—';
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                DonationReceiptCard(
                  donation: d,
                  campaignTitle: title,
                  mosqueName: mosque?.name.resolve(lang) ?? '—',
                  mosqueContact: mosque?.phone ?? mosque?.email,
                  lang: lang,
                ),
                const SizedBox(height: AppSpacing.space3),
                Text(
                  l10n.donReceiptExportPending,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.neutral500),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
