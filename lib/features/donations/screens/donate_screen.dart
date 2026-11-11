import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../mosque/data/mosque_repository.dart';
import '../../projects/data/projects_repository.dart';
import '../application/donation_validation.dart';
import '../application/finance_services.dart';
import '../data/donations_repository.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../models/money.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';

/// Maps an [AmountError] to its (Somali) message.
String? amountErrorText(AmountError? error, AppLocalizations l10n) =>
    switch (error) {
      null => null,
      AmountError.required => l10n.validationRequired,
      AmountError.invalid => l10n.donAmountInvalid,
      AmountError.notPositive => l10n.donAmountNotPositive,
      AmountError.tooManyDecimals => l10n.donAmountDecimals,
      AmountError.tooLarge => l10n.donAmountTooLarge,
    };

/// Donation form — DEMO ONLY. No payment provider is connected and no card
/// or bank credentials are ever requested. A submission is stored as a demo
/// record ("Tijaabo — lama socodsiin"), never counted and never receipted.
class DonateScreen extends ConsumerWidget {
  const DonateScreen({super.key, this.campaignId, this.projectId});

  final String? campaignId;

  /// Project the donation is for (its linked campaign is pre-selected and
  /// the project name is shown). Money is still recorded on the campaign —
  /// the single source of truth.
  final String? projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppTopBar(title: l10n.donDonate),
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
          builder: (campaigns, _) {
            final active = campaigns
                .where((c) => c.status == CampaignStatus.active)
                .toList();
            if (active.isEmpty) {
              return ScrollableCenter(
                child: EmptyState(
                  icon: Icons.campaign_outlined,
                  title: l10n.donNoCampaigns,
                  message: l10n.donNoCampaignsMessage,
                ),
              );
            }
            final requested = active
                .where((c) => c.id == campaignId)
                .firstOrNull;
            // A specific campaign was asked for (e.g. from a project) but it
            // is closed / missing: say so instead of silently recording the
            // donation on a different campaign.
            if (campaignId != null && requested == null) {
              return ScrollableCenter(
                child: EmptyState(
                  key: const Key('donateCampaignClosed'),
                  icon: Icons.campaign_outlined,
                  title: l10n.donCampaignClosed,
                ),
              );
            }
            final initial = requested ?? active.first;
            final projectTitle = projectId == null
                ? null
                : ref
                      .watch(projectsProvider)
                      .value
                      ?.where((p) => p.id == projectId)
                      .firstOrNull
                      ?.title;
            return _DonateForm(
              campaigns: active,
              initial: initial,
              projectTitle: projectTitle,
            );
          },
        ),
      ),
    );
  }
}

class _DonateForm extends ConsumerStatefulWidget {
  const _DonateForm({
    required this.campaigns,
    required this.initial,
    this.projectTitle,
  });

  final List<DonationCampaign> campaigns;
  final DonationCampaign initial;
  final String? projectTitle;

  @override
  ConsumerState<_DonateForm> createState() => _DonateFormState();
}

class _DonateFormState extends ConsumerState<_DonateForm> {
  static const List<int> suggested = [5, 10, 20, 50, 100];

  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _message = TextEditingController();
  late DonationCampaign _campaign = widget.initial;
  PaymentMethod _method = PaymentMethod.mobileMoney;
  bool _anonymous = false;
  bool _saving = false;
  Donation? _submitted;

  @override
  void dispose() {
    for (final c in [_amount, _name, _contact, _message]) {
      c.dispose();
    }
    super.dispose();
  }

  Currency get _currency => _campaign.currency;

  String? _opt(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    if (_saving) return; // prevents duplicate submissions
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = DonationValidation.parse(_amount.text, _currency)!;
    final mosque = ref.read(mosqueProvider).value;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final d = await ref
          .read(donationsProvider.notifier)
          .submitDemo(
            Donation(
              id: '',
              mosqueId: mosque?.id ?? LocalDonationsRepository.sampleMosqueId,
              reference: '',
              campaignId: _campaign.id,
              amount: amount,
              date: ref.read(clockProvider).value ?? DateTime.now(),
              method: _method,
              status: DonationStatus.pending,
              isDemo: true,
              userId: ref.read(donorUserIdProvider),
              donorName: _anonymous ? null : _opt(_name),
              donorContact: _anonymous ? null : _opt(_contact),
              isAnonymous: _anonymous,
              message: _opt(_message),
            ),
          );
      if (!mounted) return;
      setState(() {
        _saving = false;
        _submitted = d;
      });
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

  Widget _gap(Widget child, {Key? key}) => Padding(
    key: key,
    padding: const EdgeInsets.only(bottom: AppSpacing.space4),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final submitted = _submitted;
    if (submitted != null) {
      return _DemoDone(donation: submitted, campaign: _campaign);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _gap(
              DonationNotice(
                key: const Key('donateDemoWarning'),
                icon: Icons.warning_amber_rounded,
                title: l10n.donDemoWarningTitle,
                text: l10n.donDemoWarningBody,
              ),
            ),
            if (widget.projectTitle != null)
              _gap(
                DonationNotice(
                  key: const Key('donateProjectBanner'),
                  icon: Icons.construction_rounded,
                  variant: AppCardVariant.tinted,
                  title: l10n.projDonatingTo,
                  text: widget.projectTitle!,
                ),
              ),
            _gap(
              key: const Key('donateCampaignField'),
              DropdownButtonFormField<DonationCampaign>(
                initialValue: _campaign,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.donCampaign),
                onChanged: (c) {
                  if (c != null) setState(() => _campaign = c);
                },
                items: [
                  for (final c in widget.campaigns)
                    DropdownMenuItem(
                      value: c,
                      child: Text(c.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
              ),
            ),
            Text(
              l10n.donSuggested,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                for (final v in suggested)
                  ChoiceChip(
                    key: ValueKey('suggested-$v'),
                    label: Text(Money.major(v, _currency).format()),
                    selected:
                        DonationValidation.parse(_amount.text, _currency) ==
                        Money.major(v, _currency),
                    onSelected: (_) => setState(() => _amount.text = '$v'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            _gap(
              key: const Key('donateAmountField'),
              AppTextField(
                label: l10n.donAmountLabel(_currency.code),
                controller: _amount,
                isRequired: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
                ],
                prefixText: _currency.symbol,
                textDirection: TextDirection.ltr,
                onChanged: (_) => setState(() {}),
                validator: (v) => amountErrorText(
                  DonationValidation.amount(v, _currency),
                  l10n,
                ),
              ),
            ),
            Text(
              l10n.donCurrencyNote(_currency.code),
              key: const Key('donateCurrency'),
              style: textTheme.bodySmall?.copyWith(color: AppColors.neutral600),
            ),
            const SizedBox(height: AppSpacing.space3),
            SwitchListTile(
              key: const Key('donateAnonymous'),
              contentPadding: EdgeInsets.zero,
              value: _anonymous,
              title: Text(l10n.donAnonymous),
              subtitle: Text(l10n.donAnonymousHint),
              onChanged: (v) => setState(() => _anonymous = v),
            ),
            if (!_anonymous) ...[
              _gap(
                key: const Key('donateName'),
                AppTextField(
                  label: l10n.donDonorNameOptional,
                  controller: _name,
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ),
              _gap(
                key: const Key('donateContact'),
                AppTextField(
                  label: l10n.donDonorContactOptional,
                  helperText: l10n.donDonorContactHint,
                  controller: _contact,
                  prefixIcon: Icons.call_outlined,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
            _gap(
              AppTextField(
                label: l10n.donMessageOptional,
                controller: _message,
                maxLines: 3,
                maxLength: 300,
              ),
            ),
            Text(
              l10n.donMethod,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                for (final m in PaymentMethod.values)
                  ChoiceChip(
                    key: ValueKey('method-${m.name}'),
                    avatar: Icon(m.icon, size: 18),
                    label: Text(m.label(l10n)),
                    selected: _method == m,
                    onSelected: (_) => setState(() => _method = m),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              l10n.donMethodNote,
              style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
            ),
            const SizedBox(height: AppSpacing.space5),
            AppButton.primary(
              key: const Key('donateSubmit'),
              label: l10n.donSubmitDemo,
              icon: Icons.science_outlined,
              expand: true,
              isLoading: _saving,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Confirmation after a demo submission — explicitly NOT a payment and NOT
/// a receipt.
class _DemoDone extends ConsumerWidget {
  const _DemoDone({required this.donation, required this.campaign});

  final Donation donation;
  final DonationCampaign campaign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final signedIn = ref.watch(donorUserIdProvider) != null;
    return SingleChildScrollView(
      key: const Key('donateDemoDone'),
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.science_outlined,
            size: 56,
            color: AppColors.gold600,
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            l10n.donDemoDoneTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.green800,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          DonationNotice(
            icon: Icons.warning_amber_rounded,
            text: l10n.donDemoDoneBody,
          ),
          const SizedBox(height: AppSpacing.space3),
          AppCard(
            child: Column(
              children: [
                DetailRow(
                  label: l10n.donReference,
                  value: donation.reference,
                  valueKey: const Key('demoReference'),
                ),
                DetailRow(label: l10n.donCampaign, value: campaign.title),
                DetailRow(
                  label: l10n.donAmount,
                  value: donation.amount.format(),
                ),
                DetailRow(
                  label: l10n.donMethod,
                  value: donation.method.label(l10n),
                ),
                DetailRow(
                  label: l10n.donPaymentStatus,
                  value: l10n.donStatusDemo,
                  valueKey: const Key('demoStatus'),
                ),
              ],
            ),
          ),
          if (!signedIn) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              l10n.donDemoNotSavedSignedOut,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
            ),
          ],
          const SizedBox(height: AppSpacing.space4),
          AppButton.primary(
            key: const Key('demoViewHistory'),
            label: l10n.donHistoryTitle,
            icon: Icons.history_rounded,
            expand: true,
            onPressed: () => context.pushReplacement(AppRoutes.donationHistory),
          ),
          const SizedBox(height: AppSpacing.space2),
          AppButton.secondary(
            key: const Key('demoBack'),
            label: l10n.donBackToDonations,
            expand: true,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.donations);
              }
            },
          ),
        ],
      ),
    );
  }
}
