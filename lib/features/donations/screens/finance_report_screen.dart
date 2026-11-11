import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../application/finance_calculations.dart';
import '../data/donations_repository.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';

/// Staff: financial report for a day / month / year, per currency, with
/// the calculation rules shown transparently. No export controls (export is
/// not implemented).
class FinanceReportScreen extends ConsumerStatefulWidget {
  const FinanceReportScreen({super.key});

  @override
  ConsumerState<FinanceReportScreen> createState() =>
      _FinanceReportScreenState();
}

class _FinanceReportScreenState extends ConsumerState<FinanceReportScreen> {
  late ReportPeriod _period = ReportPeriod(
    ReportGranularity.month,
    ref.read(clockProvider).value ?? DateTime.now(),
  );

  String _periodLabel(String lang) => switch (_period.granularity) {
    ReportGranularity.day => AppDateFormatter.fullDate(
      _period.start,
      locale: lang,
    ),
    ReportGranularity.month => AppDateFormatter.monthYear(
      _period.start,
      locale: lang,
    ),
    ReportGranularity.year => '${_period.start.year}',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppTopBar(title: l10n.donReportsTitle),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () {
            ref
              ..invalidate(donationsProvider)
              ..invalidate(expensesProvider);
          },
          builder: (campaigns, donations) {
            if (expensesAsync.hasError) {
              return ScrollableCenter(
                child: ErrorState(
                  onRetry: () => ref.invalidate(expensesProvider),
                ),
              );
            }
            final expenses = expensesAsync.value;
            if (expenses == null) return const AppLoadingIndicator();
            final titles = {for (final c in campaigns) c.id: c.title};
            final report = FinanceCalculations.report(
              period: _period,
              donations: donations,
              expenses: expenses,
            );
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                if (donations.any((d) => d.isSample)) ...[
                  DonationNotice(
                    icon: Icons.science_outlined,
                    text: l10n.donReportSample,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                ],
                Wrap(
                  spacing: AppSpacing.space2,
                  children: [
                    for (final g in ReportGranularity.values)
                      ChoiceChip(
                        key: ValueKey('reportGranularity-${g.name}'),
                        label: Text(switch (g) {
                          ReportGranularity.day => l10n.donReportDay,
                          ReportGranularity.month => l10n.donReportMonth,
                          ReportGranularity.year => l10n.donReportYear,
                        }),
                        selected: _period.granularity == g,
                        onSelected: (_) => setState(
                          () => _period = ReportPeriod(g, _period.start),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                Row(
                  children: [
                    IconButton(
                      key: const Key('reportPrev'),
                      tooltip: l10n.donReportPrev,
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: () =>
                          setState(() => _period = _period.shift(-1)),
                    ),
                    Expanded(
                      child: Text(
                        _periodLabel(lang),
                        key: const Key('reportPeriodLabel'),
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.green800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('reportNext'),
                      tooltip: l10n.donReportNext,
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: () =>
                          setState(() => _period = _period.shift(1)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space3),
                if (report.isEmpty)
                  EmptyState(
                    icon: Icons.bar_chart_rounded,
                    title: l10n.donReportEmpty,
                    message: l10n.donReportEmptyMessage,
                  )
                else
                  for (final r in report.byCurrency.values) ...[
                    _CurrencySection(report: r, titles: titles),
                    const SizedBox(height: AppSpacing.space3),
                  ],
                const SizedBox(height: AppSpacing.space2),
                SectionHeader(title: l10n.donReportProgress),
                for (final c in campaigns.where(
                  (c) => c.status == CampaignStatus.active,
                ))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(c.title, style: textTheme.titleSmall),
                          const SizedBox(height: AppSpacing.space2),
                          CampaignProgressView(
                            progress: FinanceCalculations.campaignProgress(
                              c,
                              donations,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.space2),
                DonationNotice(
                  key: const Key('reportRules'),
                  icon: Icons.rule_rounded,
                  variant: AppCardVariant.outlined,
                  title: l10n.donReportRulesTitle,
                  text: l10n.donReportRules,
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  l10n.donReportExportPending,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
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

class _CurrencySection extends StatelessWidget {
  const _CurrencySection({required this.report, required this.titles});

  final CurrencyReport report;
  final Map<String, String> titles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final code = report.currency.code;
    return AppCard(
      key: ValueKey('report-$code'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.donCurrencyNote(code),
            style: textTheme.titleSmall?.copyWith(color: AppColors.green800),
          ),
          const SizedBox(height: AppSpacing.space2),
          DetailRow(
            label: l10n.donReportConfirmed,
            value: report.confirmedDonations.format(),
            valueKey: ValueKey('reportConfirmed-$code'),
          ),
          DetailRow(
            label: l10n.donReportExpenses,
            value: report.expenses.format(),
            valueKey: ValueKey('reportExpenses-$code'),
          ),
          DetailRow(
            label: l10n.donReportNet,
            value: report.net.format(),
            valueKey: ValueKey('reportNet-$code'),
          ),
          Text(
            l10n.donReportNetNote,
            style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
          ),
          if (report.byCampaign.isNotEmpty) ...[
            const Divider(height: AppSpacing.space6),
            Text(l10n.donReportByCampaign, style: textTheme.titleSmall),
            for (final e in report.byCampaign.entries)
              DetailRow(label: titles[e.key] ?? e.key, value: e.value.format()),
          ],
          if (report.byMethod.isNotEmpty) ...[
            const Divider(height: AppSpacing.space6),
            Text(l10n.donReportByMethod, style: textTheme.titleSmall),
            for (final e in report.byMethod.entries)
              DetailRow(label: e.key.label(l10n), value: e.value.format()),
          ],
        ],
      ),
    );
  }
}
