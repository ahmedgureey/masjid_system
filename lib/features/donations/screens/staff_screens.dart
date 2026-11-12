import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../authentication/application/demo_session_provider.dart';
import '../application/donation_validation.dart';
import '../data/donations_repository.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';
import 'donate_screen.dart' show amountErrorText;

/// Name recorded in the audit trail for staff actions (demo session name).
String staffActor(WidgetRef ref) =>
    ref.read(demoSessionProvider)?.displayName ?? '—';

/// Asks for a mandatory void reason. Returns null when cancelled.
Future<String?> showVoidReasonDialog(BuildContext context) {
  final l10n = context.l10n;
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.donVoidTitle),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.donVoidExplain),
            const SizedBox(height: AppSpacing.space3),
            TextFormField(
              key: const Key('voidReasonField'),
              controller: controller,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.donVoidReason),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.validationRequired
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.profileCancel),
        ),
        TextButton(
          key: const Key('voidConfirm'),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.of(dialogContext).pop(controller.text.trim());
            }
          },
          child: Text(l10n.donVoid),
        ),
      ],
    ),
  );
}

/// Staff home: links to recording, expenses and reports, the pending
/// queue and all donation records with filters.
class StaffDonationsScreen extends ConsumerStatefulWidget {
  const StaffDonationsScreen({super.key});

  @override
  ConsumerState<StaffDonationsScreen> createState() =>
      _StaffDonationsScreenState();
}

class _StaffDonationsScreenState extends ConsumerState<StaffDonationsScreen> {
  DonationStateFilter _state = DonationStateFilter.all;
  PaymentMethod? _method;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    return Scaffold(
      appBar: AppTopBar(title: l10n.donStaffTitle),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () => ref.invalidate(donationsProvider),
          builder: (campaigns, donations) {
            final titles = {for (final c in campaigns) c.id: c.title};
            final pending = donations
                .where(DonationStateFilter.pending.matches)
                .toList();
            final visible =
                donations
                    .where(
                      (d) =>
                          _state.matches(d) &&
                          (_method == null || d.method == _method),
                    )
                    .toList()
                  ..sort((a, b) => b.date.compareTo(a.date));
            Widget tile(Donation d) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space3),
              child: DonationTile(
                key: ValueKey('staff-${d.id}'),
                donation: d,
                campaignTitle: titles[d.campaignId] ?? '—',
                lang: lang,
                onTap: () =>
                    context.pushIfCurrent(AppRoutes.staffDonation(d.id)),
              ),
            );
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                DonationNotice(
                  key: const Key('staffNotice'),
                  icon: Icons.admin_panel_settings_outlined,
                  variant: AppCardVariant.tinted,
                  text: l10n.donStaffNotice,
                ),
                const SizedBox(height: AppSpacing.space3),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space2,
                  children: [
                    ActionChip(
                      key: const Key('staffRecord'),
                      avatar: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.donRecordOffline),
                      onPressed: () =>
                          context.pushIfCurrent(AppRoutes.recordDonation),
                    ),
                    ActionChip(
                      key: const Key('staffExpenses'),
                      avatar: const Icon(Icons.receipt_outlined, size: 18),
                      label: Text(l10n.donExpensesTitle),
                      onPressed: () =>
                          context.pushIfCurrent(AppRoutes.expenses),
                    ),
                    ActionChip(
                      key: const Key('staffReports'),
                      avatar: const Icon(Icons.bar_chart_rounded, size: 18),
                      label: Text(l10n.donReportsTitle),
                      onPressed: () =>
                          context.pushIfCurrent(AppRoutes.financeReports),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space4),
                SectionHeader(title: l10n.donPendingReview(pending.length)),
                if (pending.isEmpty)
                  Text(l10n.donNoPending)
                else
                  ...pending.map(tile),
                const SizedBox(height: AppSpacing.space4),
                SectionHeader(title: l10n.donAllRecords),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final s in DonationStateFilter.values)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: AppSpacing.space2,
                          ),
                          child: ChoiceChip(
                            key: ValueKey('staffState-${s.name}'),
                            label: Text(s.label(l10n)),
                            selected: _state == s,
                            onSelected: (_) => setState(() => _state = s),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: AppSpacing.space2,
                        ),
                        child: ChoiceChip(
                          label: Text(l10n.donAllMethods),
                          selected: _method == null,
                          onSelected: (_) => setState(() => _method = null),
                        ),
                      ),
                      for (final m in PaymentMethod.values)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: AppSpacing.space2,
                          ),
                          child: ChoiceChip(
                            key: ValueKey('staffMethod-${m.name}'),
                            label: Text(m.label(l10n)),
                            selected: _method == m,
                            onSelected: (_) => setState(() => _method = m),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                if (visible.isEmpty)
                  EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: l10n.donHistoryEmpty,
                  )
                else
                  ...visible.map(tile),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Staff: record a donation received offline. It is saved as PENDING and
/// must be verified separately before it counts.
class RecordDonationScreen extends ConsumerStatefulWidget {
  const RecordDonationScreen({super.key});

  @override
  ConsumerState<RecordDonationScreen> createState() =>
      _RecordDonationScreenState();
}

class _RecordDonationScreenState extends ConsumerState<RecordDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _donor = TextEditingController();
  DonationCampaign? _campaign;
  PaymentMethod _method = PaymentMethod.cash;
  late DateTime _date = ref.read(clockProvider).value ?? DateTime.now();
  bool _anonymous = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_amount, _reference, _donor]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider).value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_saving) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final campaign = _campaign!;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(donationsProvider.notifier)
          .recordOffline(
            Donation(
              id: '',
              mosqueId: campaign.mosqueId,
              reference: '',
              campaignId: campaign.id,
              amount: DonationValidation.parse(
                _amount.text,
                campaign.currency,
              )!,
              date: _date,
              method: _method,
              status: DonationStatus.pending,
              donorName: _anonymous || _donor.text.trim().isEmpty
                  ? null
                  : _donor.text.trim(),
              isAnonymous: _anonymous,
              externalReference: _reference.text.trim().isEmpty
                  ? null
                  : _reference.text.trim(),
              recordedBy: staffActor(ref),
            ),
          );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.donRecordedLocal)));
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.financeStaff);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(l10n.donSubmitError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final campaigns = (ref.watch(campaignsProvider).value ?? const [])
        .where((c) => c.status == CampaignStatus.active)
        .toList();
    final currency = _campaign?.currency;
    Widget gap(Widget child, {Key? key}) => Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: child,
    );

    return Scaffold(
      appBar: AppTopBar(title: l10n.donRecordOffline),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gap(
                  DonationNotice(
                    icon: Icons.info_outline_rounded,
                    variant: AppCardVariant.tinted,
                    text: l10n.donRecordExplain,
                  ),
                ),
                gap(
                  key: const Key('recordCampaign'),
                  DropdownButtonFormField<DonationCampaign>(
                    initialValue: _campaign,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: '${l10n.donCampaign} *',
                    ),
                    validator: (v) =>
                        v == null ? l10n.eventValidationChoose : null,
                    onChanged: (c) => setState(() => _campaign = c),
                    items: [
                      for (final c in campaigns)
                        DropdownMenuItem(
                          value: c,
                          child: Text(c.title, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                  ),
                ),
                gap(
                  key: const Key('recordAmount'),
                  AppTextField(
                    label: l10n.donAmountLabel(currency?.code ?? '—'),
                    controller: _amount,
                    isRequired: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
                    ],
                    textDirection: TextDirection.ltr,
                    validator: (v) => currency == null
                        ? null
                        : amountErrorText(
                            DonationValidation.amount(v, currency),
                            l10n,
                          ),
                  ),
                ),
                gap(
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: Text(l10n.donDate),
                    subtitle: Text(
                      AppDateFormatter.fullDate(_date, locale: lang),
                    ),
                    trailing: const Icon(Icons.edit_calendar_outlined),
                    onTap: _pickDate,
                  ),
                ),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space2,
                  children: [
                    for (final m in PaymentMethod.values)
                      ChoiceChip(
                        key: ValueKey('recordMethod-${m.name}'),
                        avatar: Icon(m.icon, size: 18),
                        label: Text(m.label(l10n)),
                        selected: _method == m,
                        onSelected: (_) => setState(() => _method = m),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space4),
                gap(
                  AppTextField(
                    label: l10n.donExternalReference,
                    controller: _reference,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _anonymous,
                  title: Text(l10n.donAnonymous),
                  onChanged: (v) => setState(() => _anonymous = v),
                ),
                if (!_anonymous)
                  gap(
                    AppTextField(
                      label: l10n.donDonorNameOptional,
                      controller: _donor,
                    ),
                  ),
                AppButton.primary(
                  key: const Key('recordSave'),
                  label: l10n.donRecordSave,
                  icon: Icons.check_rounded,
                  expand: true,
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Staff: one donation record with verification, void and audit trail.
class StaffDonationDetailsScreen extends ConsumerStatefulWidget {
  const StaffDonationDetailsScreen({super.key, required this.donationId});

  final String donationId;

  @override
  ConsumerState<StaffDonationDetailsScreen> createState() =>
      _StaffDonationDetailsScreenState();
}

class _StaffDonationDetailsScreenState
    extends ConsumerState<StaffDonationDetailsScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      await action();
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(l10n.donSubmitError),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirm(Donation d) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.donConfirmTitle),
        content: Text(l10n.donConfirmExplain),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.profileCancel),
          ),
          TextButton(
            key: const Key('confirmDonationYes'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.donConfirm),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await _run(
      () => ref
          .read(donationsProvider.notifier)
          .confirm(
            d.id,
            actor: staffActor(ref),
            now: ref.read(clockProvider).value ?? DateTime.now(),
          ),
    );
  }

  /// Removes the record for good, after a warning that names the gentler
  /// option. A record that counts in the totals gets the stronger wording;
  /// a demo, pending or already-voided one does not need it.
  Future<void> _delete(Donation d) async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final ok = await confirmDelete(
      context,
      title: l10n.deleteDonationTitle,
      message: d.countsAsConfirmed ? l10n.deleteCountedMessage : null,
    );
    if (!ok || !mounted) return;

    await _run(() => ref.read(donationsProvider.notifier).delete(d.id));
    // _run reports its own failure; only leave if the record really went.
    if (!mounted) return;
    final remaining = ref.read(donationsProvider).value ?? const <Donation>[];
    final gone = !remaining.any((x) => x.id == d.id);
    if (gone && navigator.canPop()) navigator.pop();
  }

  Future<void> _void(Donation d) async {
    final reason = await showVoidReasonDialog(context);
    if (reason == null || !mounted) return;
    await _run(
      () => ref
          .read(donationsProvider.notifier)
          .voidDonation(
            d.id,
            reason: reason,
            actor: staffActor(ref),
            now: ref.read(clockProvider).value ?? DateTime.now(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppTopBar(title: l10n.donRecordDetails),
      body: SafeArea(
        top: false,
        child: FinanceAsync<List<DonationCampaign>, List<Donation>>(
          first: ref.watch(campaignsProvider),
          second: ref.watch(donationsProvider),
          onRetry: () => ref.invalidate(donationsProvider),
          builder: (campaigns, donations) {
            final d = donations
                .where((x) => x.id == widget.donationId)
                .firstOrNull;
            if (d == null) {
              return ScrollableCenter(
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.donRecordNotFound,
                ),
              );
            }
            final title =
                campaigns
                    .where((c) => c.id == d.campaignId)
                    .firstOrNull
                    ?.title ??
                '—';
            final canConfirm =
                !d.isDemo && !d.isVoided && d.status == DonationStatus.pending;
            final canVoid = !d.isDemo && !d.isVoided;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: donationStatusChip(d, l10n),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  d.amount.format(),
                  key: const Key('staffDetailAmount'),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.green800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                AppCard(
                  child: Column(
                    children: [
                      DetailRow(label: l10n.donReference, value: d.reference),
                      DetailRow(label: l10n.donCampaign, value: title),
                      DetailRow(
                        label: l10n.donDate,
                        value: AppDateFormatter.fullDate(d.date, locale: lang),
                      ),
                      DetailRow(
                        label: l10n.donMethod,
                        value: d.method.label(l10n),
                      ),
                      DetailRow(
                        label: l10n.donDonor,
                        value: d.displayDonor ?? l10n.donAnonymousDonor,
                      ),
                      if (d.externalReference != null)
                        DetailRow(
                          label: l10n.donExternalReference,
                          value: d.externalReference!,
                        ),
                      if (d.recordedBy != null)
                        DetailRow(
                          label: l10n.donRecordedBy,
                          value: d.recordedBy!,
                        ),
                      if (d.isVoided)
                        DetailRow(
                          label: l10n.donVoidReason,
                          value: d.voidReason ?? '—',
                          valueKey: const Key('staffVoidReason'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                if (canConfirm)
                  AppButton.primary(
                    key: const Key('staffConfirm'),
                    label: l10n.donConfirm,
                    icon: Icons.verified_outlined,
                    expand: true,
                    isLoading: _busy,
                    onPressed: () => _confirm(d),
                  ),
                if (canVoid) ...[
                  const SizedBox(height: AppSpacing.space2),
                  AppButton.destructive(
                    key: const Key('staffVoid'),
                    label: l10n.donVoid,
                    icon: Icons.block_rounded,
                    expand: true,
                    onPressed: _busy ? null : () => _void(d),
                  ),
                ],
                if (d.hasReceipt) ...[
                  const SizedBox(height: AppSpacing.space2),
                  AppButton.secondary(
                    key: const Key('staffReceipt'),
                    label: l10n.donReceipt,
                    icon: Icons.receipt_long_rounded,
                    expand: true,
                    onPressed: () =>
                        context.pushIfCurrent(AppRoutes.receipt(d.id)),
                  ),
                ],
                // Last, and below voiding: of the two destructive actions
                // this is the one with no way back, so it should not be the
                // one the thumb finds first.
                const SizedBox(height: AppSpacing.space2),
                AppButton.destructive(
                  key: const Key('staffDeleteDonation'),
                  label: l10n.commonDelete,
                  icon: Icons.delete_outline_rounded,
                  expand: true,
                  onPressed: _busy ? null : () => _delete(d),
                ),
                const SizedBox(height: AppSpacing.space4),
                _AuditList(entries: d.audit, lang: lang),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AuditList extends StatelessWidget {
  const _AuditList({required this.entries, required this.lang});

  final List<AuditEntry> entries;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      key: const Key('auditTrail'),
      variant: AppCardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.donAudit, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.space2),
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space2),
              child: Text(
                '${AppDateFormatter.shortDate(e.at, locale: lang)} ${e.at.year} · '
                '${e.action.label(l10n)} · ${e.actor}'
                '${e.note == null ? '' : ' — ${e.note}'}',
                style: textTheme.bodySmall,
              ),
            ),
          Text(
            l10n.donAuditNote,
            style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }
}

/// Shared audit list for expenses.
class AuditTrailCard extends StatelessWidget {
  const AuditTrailCard({super.key, required this.entries, required this.lang});

  final List<AuditEntry> entries;
  final String lang;

  @override
  Widget build(BuildContext context) =>
      _AuditList(entries: entries, lang: lang);
}
