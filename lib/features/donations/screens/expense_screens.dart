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
import '../../mosque/data/mosque_repository.dart';
import '../../projects/data/projects_repository.dart';
import '../../projects/models/project_models.dart';
import '../application/donation_validation.dart';
import '../application/finance_calculations.dart';
import '../data/donations_repository.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../models/money.dart';
import '../widgets/donation_widgets.dart';
import '../widgets/finance_async.dart';
import 'donate_screen.dart' show amountErrorText;
import 'staff_screens.dart';

/// Staff: mosque expenses (not visible to ordinary donors).
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final async = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppTopBar(title: l10n.donExpensesTitle),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('expenseAdd'),
        onPressed: () => context.pushIfCurrent(AppRoutes.newExpense),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.donExpenseAdd),
      ),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, _) => ScrollableCenter(
            child: ErrorState(onRetry: () => ref.invalidate(expensesProvider)),
          ),
          data: (expenses) {
            final sorted = [...expenses]
              ..sort((a, b) => b.date.compareTo(a.date));
            final currencies = {for (final e in expenses) e.amount.currency};
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space4,
                AppSpacing.space4,
                AppSpacing.space4,
                96,
              ),
              children: [
                DonationNotice(
                  icon: Icons.admin_panel_settings_outlined,
                  variant: AppCardVariant.tinted,
                  text: l10n.donExpensesNotice,
                ),
                const SizedBox(height: AppSpacing.space3),
                for (final c in currencies)
                  AppCard(
                    child: DetailRow(
                      label: l10n.donExpensesApprovedTotal(c.code),
                      value: FinanceCalculations.expensesTotal(
                        expenses,
                        c,
                      ).format(),
                      valueKey: ValueKey('expenseTotal-${c.code}'),
                    ),
                  ),
                const SizedBox(height: AppSpacing.space3),
                if (sorted.isEmpty)
                  EmptyState(
                    icon: Icons.receipt_outlined,
                    title: l10n.donExpensesEmpty,
                  )
                else
                  for (final e in sorted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                      child: AppCard(
                        key: ValueKey('expense-${e.id}'),
                        onTap: () =>
                            context.pushIfCurrent(AppRoutes.expense(e.id)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: AppSpacing.space2,
                              runSpacing: AppSpacing.space1,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  e.amount.format(),
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    decoration: e.isVoided
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                expenseStatusChip(e, l10n),
                              ],
                            ),
                            Text(e.description),
                            Text(
                              '${e.category.label(l10n)} · '
                              '${AppDateFormatter.shortDate(e.date, locale: lang)} '
                              '${e.date.year}',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.neutral500,
                              ),
                            ),
                          ],
                        ),
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

/// Staff: record a new expense (saved as pending approval).
class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _reason = TextEditingController();
  final _amount = TextEditingController();
  final _payee = TextEditingController();
  ExpenseCategory? _category;
  String? _projectId;
  Currency _currency = Currency.usd;
  late DateTime _date = ref.read(clockProvider).value ?? DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_description, _reason, _amount, _payee]) {
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
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(expensesProvider.notifier)
          .add(
            MosqueExpense(
              id: '',
              mosqueId:
                  ref.read(mosqueProvider).value?.id ??
                  LocalDonationsRepository.sampleMosqueId,
              category: _category!,
              description: _description.text.trim(),
              reason: _reason.text.trim(),
              amount: DonationValidation.parse(_amount.text, _currency)!,
              date: _date,
              payee: _payee.text.trim().isEmpty ? null : _payee.text.trim(),
              projectId: _projectId,
              recordedBy: staffActor(ref),
              status: ExpenseStatus.pending,
            ),
          );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.donRecordedLocal)));
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.expenses);
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
    final textTheme = Theme.of(context).textTheme;
    Widget gap(Widget child, {Key? key}) => Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: child,
    );
    return Scaffold(
      appBar: AppTopBar(title: l10n.donExpenseAdd),
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
                  key: const Key('expenseCategory'),
                  DropdownButtonFormField<ExpenseCategory>(
                    initialValue: _category,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: '${l10n.donExpenseCategory} *',
                    ),
                    validator: (v) =>
                        v == null ? l10n.eventValidationChoose : null,
                    onChanged: (v) => setState(() => _category = v),
                    items: [
                      for (final c in ExpenseCategory.values)
                        DropdownMenuItem(value: c, child: Text(c.label(l10n))),
                    ],
                  ),
                ),
                gap(
                  key: const Key('expenseDescription'),
                  AppTextField(
                    label: l10n.eventDescription,
                    controller: _description,
                    isRequired: true,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.validationRequired
                        : null,
                  ),
                ),
                gap(
                  key: const Key('expenseReason'),
                  AppTextField(
                    label: l10n.donExpenseReason,
                    controller: _reason,
                    isRequired: true,
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.validationRequired
                        : null,
                  ),
                ),
                gap(
                  DropdownButtonFormField<Currency>(
                    initialValue: _currency,
                    decoration: InputDecoration(
                      labelText: l10n.donCurrencyLabel,
                    ),
                    onChanged: (v) =>
                        setState(() => _currency = v ?? Currency.usd),
                    items: [
                      for (final c in Currency.values)
                        DropdownMenuItem(value: c, child: Text(c.code)),
                    ],
                  ),
                ),
                gap(
                  key: const Key('expenseAmount'),
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
                    textDirection: TextDirection.ltr,
                    validator: (v) => amountErrorText(
                      DonationValidation.amount(v, _currency),
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
                gap(
                  AppTextField(label: l10n.donExpensePayee, controller: _payee),
                ),
                gap(
                  key: const Key('expenseProject'),
                  DropdownButtonFormField<String?>(
                    initialValue: _projectId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.projExpenseProject,
                    ),
                    onChanged: (v) => setState(() => _projectId = v),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('—')),
                      for (final p
                          in ref.watch(projectsProvider).value ??
                              const <MosqueProject>[])
                        DropdownMenuItem(
                          value: p.id,
                          child: Text(p.title, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                  ),
                ),
                gap(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppButton.secondary(
                        label: l10n.donExpenseDocument,
                        icon: Icons.attach_file_rounded,
                        size: AppButtonSize.small,
                        onPressed: null,
                      ),
                      const SizedBox(height: AppSpacing.space1),
                      Text(
                        l10n.eventImagePending,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  l10n.donExpensePendingNote,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                AppButton.primary(
                  key: const Key('expenseSave'),
                  label: l10n.profileSave,
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

/// Staff: one expense with approve / reject / void and audit trail.
class ExpenseDetailsScreen extends ConsumerStatefulWidget {
  const ExpenseDetailsScreen({super.key, required this.expenseId});

  final String expenseId;

  @override
  ConsumerState<ExpenseDetailsScreen> createState() =>
      _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends ConsumerState<ExpenseDetailsScreen> {
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

  DateTime get _now => ref.read(clockProvider).value ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final async = ref.watch(expensesProvider);
    return Scaffold(
      appBar: AppTopBar(title: l10n.donExpenseDetails),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, _) => ScrollableCenter(
            child: ErrorState(onRetry: () => ref.invalidate(expensesProvider)),
          ),
          data: (expenses) {
            final e = expenses
                .where((x) => x.id == widget.expenseId)
                .firstOrNull;
            if (e == null) {
              return ScrollableCenter(
                child: EmptyState(
                  icon: Icons.receipt_outlined,
                  title: l10n.donRecordNotFound,
                ),
              );
            }
            final pending = !e.isVoided && e.status == ExpenseStatus.pending;
            final notifier = ref.read(expensesProvider.notifier);
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: expenseStatusChip(e, l10n),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  e.amount.format(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.green800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                AppCard(
                  child: Column(
                    children: [
                      DetailRow(
                        label: l10n.donExpenseCategory,
                        value: e.category.label(l10n),
                      ),
                      DetailRow(
                        label: l10n.eventDescription,
                        value: e.description,
                      ),
                      DetailRow(label: l10n.donExpenseReason, value: e.reason),
                      DetailRow(
                        label: l10n.donDate,
                        value: AppDateFormatter.fullDate(e.date, locale: lang),
                      ),
                      if (e.payee != null)
                        DetailRow(label: l10n.donExpensePayee, value: e.payee!),
                      DetailRow(label: l10n.donRecordedBy, value: e.recordedBy),
                      if (e.isVoided)
                        DetailRow(
                          label: l10n.donVoidReason,
                          value: e.voidReason ?? '—',
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                if (pending) ...[
                  AppButton.primary(
                    key: const Key('expenseApprove'),
                    label: l10n.donExpenseApprove,
                    icon: Icons.check_circle_outline_rounded,
                    expand: true,
                    isLoading: _busy,
                    onPressed: () => _run(
                      () => notifier.setStatus(
                        e.id,
                        ExpenseStatus.approved,
                        actor: staffActor(ref),
                        now: _now,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  AppButton.secondary(
                    key: const Key('expenseReject'),
                    label: l10n.donExpenseReject,
                    icon: Icons.cancel_outlined,
                    expand: true,
                    onPressed: _busy
                        ? null
                        : () => _run(
                            () => notifier.setStatus(
                              e.id,
                              ExpenseStatus.rejected,
                              actor: staffActor(ref),
                              now: _now,
                            ),
                          ),
                  ),
                ],
                if (!e.isVoided) ...[
                  const SizedBox(height: AppSpacing.space2),
                  AppButton.destructive(
                    key: const Key('expenseVoid'),
                    label: l10n.donVoid,
                    icon: Icons.block_rounded,
                    expand: true,
                    onPressed: _busy
                        ? null
                        : () async {
                            final reason = await showVoidReasonDialog(context);
                            if (reason == null || !mounted) return;
                            await _run(
                              () => notifier.voidExpense(
                                e.id,
                                reason: reason,
                                actor: staffActor(ref),
                                now: _now,
                              ),
                            );
                          },
                  ),
                ],
                const SizedBox(height: AppSpacing.space4),
                AuditTrailCard(entries: e.audit, lang: lang),
              ],
            );
          },
        ),
      ),
    );
  }
}
