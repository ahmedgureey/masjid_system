import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../authentication/application/demo_session_provider.dart';
import '../../donations/data/donations_repository.dart';
import '../../donations/models/donation_models.dart';
import '../../donations/models/money.dart';
import '../../donations/widgets/finance_async.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/project_logic.dart';
import '../data/projects_repository.dart';
import '../models/project_category.dart';
import '../models/project_models.dart';
import '../widgets/project_widgets.dart';

/// Message for a [ProjectFieldError].
String? projectErrorText(ProjectFieldError? e, AppLocalizations l10n) =>
    switch (e) {
      null => null,
      ProjectFieldError.required => l10n.validationRequired,
      ProjectFieldError.invalidAmount => l10n.projErrorAmount,
      ProjectFieldError.negative => l10n.projErrorNegative,
      ProjectFieldError.tooManyDecimals => l10n.donAmountDecimals,
      ProjectFieldError.endBeforeStart => l10n.projErrorDates,
      ProjectFieldError.percentRange => l10n.projErrorPercent,
    };

/// Shared discard-changes dialog.
Future<bool> confirmDiscard(BuildContext context) async {
  final l10n = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.discardTitle),
      content: Text(l10n.discardMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.discardKeepEditing),
        ),
        TextButton(
          key: const Key('discardConfirm'),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.discardConfirm),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Add / edit project (administrators; FRONTEND-ONLY guard in the router).
class ProjectFormScreen extends ConsumerWidget {
  const ProjectFormScreen({super.key, this.projectId});

  /// Null → new project.
  final String? projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return FinanceAsync<List<MosqueProject>, List<DonationCampaign>>(
      first: ref.watch(projectsProvider),
      second: ref.watch(campaignsProvider),
      onRetry: () => ref.invalidate(projectsProvider),
      builder: (projects, campaigns) {
        if (projectId == null) {
          return _ProjectForm(
            initial: null,
            campaigns: campaigns,
            projects: projects,
          );
        }
        final p = projects.where((x) => x.id == projectId).firstOrNull;
        if (p == null) {
          return Scaffold(
            appBar: const AppTopBar(),
            body: EmptyState(
              icon: Icons.construction_rounded,
              title: l10n.projNotFound,
            ),
          );
        }
        return _ProjectForm(
          initial: p,
          campaigns: campaigns,
          projects: projects,
        );
      },
    );
  }
}

class _MilestoneDraft {
  _MilestoneDraft({
    required this.id,
    String title = '',
    this.status = MilestoneStatus.pending,
    this.due,
    this.completed,
  }) : title = TextEditingController(text: title);

  final String id;
  final TextEditingController title;
  MilestoneStatus status;
  DateTime? due;
  DateTime? completed;
}

class _ProjectForm extends ConsumerStatefulWidget {
  const _ProjectForm({
    required this.initial,
    required this.campaigns,
    required this.projects,
  });

  final MosqueProject? initial;
  final List<DonationCampaign> campaigns;
  final List<MosqueProject> projects;

  @override
  ConsumerState<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<_ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final MosqueProject? _p = widget.initial;
  late final _title = TextEditingController(text: _p?.title);
  late final _summary = TextEditingController(text: _p?.summary);
  late final _description = TextEditingController(text: _p?.description);
  late final _location = TextEditingController(text: _p?.location);
  late final _manager = TextEditingController(text: _p?.manager);
  late final _budget = TextEditingController(
    text: _p == null ? '' : _amountText(_p.budget),
  );
  late final _target = TextEditingController(
    text: _p?.fundingTarget == null ? '' : _amountText(_p!.fundingTarget!),
  );
  late final _progress = TextEditingController(
    text: _p?.physicalProgress?.toString(),
  );
  late final _progressNote = TextEditingController(text: _p?.progressNote);
  late final _objectives = TextEditingController(text: _p?.objectives);
  late final _beneficiaries = TextEditingController(text: _p?.beneficiaries);
  late String? _categoryId = _p?.categoryId;
  late Currency _currency = _p?.budget.currency ?? Currency.usd;
  late ProjectStatus _status = _p?.status ?? ProjectStatus.planned;
  late DateTime? _start = _p?.startDate;
  late DateTime? _end = _p?.expectedEndDate;
  late bool _featured = _p?.isFeatured ?? false;
  late String? _campaignId = _p?.fundingCampaignId;
  late final List<_MilestoneDraft> _milestones = [
    for (final m in _p?.milestones ?? const <ProjectMilestone>[])
      _MilestoneDraft(
        id: m.id,
        title: m.title,
        status: m.status,
        due: m.dueDate,
        completed: m.completedDate,
      ),
  ];
  bool _dirty = false;
  bool _saving = false;
  bool _allowPop = false;
  int _msSeq = 0;

  static String _amountText(Money m) =>
      (m.minor / 100).toStringAsFixed(m.minor % 100 == 0 ? 0 : 2);

  /// Campaigns selectable for [currency]: active, same currency, not linked
  /// to another project. The campaign this project is ALREADY linked to is
  /// kept (even if it has since closed) so editing never drops the link
  /// silently and the dropdown value always exists in its items.
  List<DonationCampaign> _campaignsFor(Currency currency) {
    final list = ProjectLogic.availableCampaigns(
      projectId: _p?.id,
      currency: currency,
      campaigns: widget.campaigns,
      projects: widget.projects,
    );
    final current = widget.campaigns
        .where(
          (c) =>
              c.id == _p?.fundingCampaignId &&
              c.currency == currency &&
              !list.any((x) => x.id == c.id),
        )
        .firstOrNull;
    return [?current, ...list];
  }

  void _changed() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _summary,
      _description,
      _location,
      _manager,
      _budget,
      _target,
      _progress,
      _progressNote,
      _objectives,
      _beneficiaries,
      for (final m in _milestones) m.title,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  DateTime get _today {
    final n = ref.read(clockProvider).value ?? DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<DateTime?> _pick(DateTime? initial) => showDatePicker(
    context: context,
    initialDate: initial ?? _today,
    firstDate: DateTime(_today.year - 10),
    lastDate: DateTime(_today.year + 10),
  );

  String? _opt(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  MosqueProject _build(String actor) {
    final now = ref.read(clockProvider).value ?? DateTime.now();
    final budget = ProjectValidation.parseAmount(_budget.text, _currency)!;
    final target = _target.text.trim().isEmpty
        ? null
        : ProjectValidation.parseAmount(_target.text, _currency);
    final old = _p;
    final notes = <String>[
      if (old == null) context.l10n.projHistoryCreated,
      if (old != null && old.budget != budget)
        context.l10n.projHistoryBudget(old.budget.format(), budget.format()),
      if (old != null && old.status != _status)
        context.l10n.projHistoryStatus(
          old.status.label(context.l10n),
          _status.label(context.l10n),
        ),
      if (old != null && old.fundingCampaignId != _campaignId)
        context.l10n.projHistoryCampaign,
      if (old != null) context.l10n.projHistoryEdited,
    ];
    return MosqueProject(
      id: old?.id ?? 'proj-local-${now.microsecondsSinceEpoch}',
      mosqueId:
          old?.mosqueId ??
          ref.read(mosqueProvider).value?.id ??
          LocalProjectsRepository.sampleMosqueId,
      title: _title.text.trim(),
      summary: _summary.text.trim(),
      description: _description.text.trim(),
      categoryId: _categoryId!,
      location: _opt(_location),
      manager: _opt(_manager),
      budget: budget,
      fundingTarget: target,
      startDate: _start,
      expectedEndDate: _end,
      status: _status,
      isFeatured: _featured,
      fundingCampaignId: _campaignId,
      physicalProgress: int.tryParse(_progress.text.trim()),
      progressNote: _opt(_progressNote),
      objectives: _opt(_objectives),
      beneficiaries: _opt(_beneficiaries),
      milestones: [
        for (final m in _milestones)
          if (m.title.text.trim().isNotEmpty)
            ProjectMilestone(
              id: m.id,
              title: m.title.text.trim(),
              status: m.status,
              dueDate: m.due,
              completedDate: m.status == MilestoneStatus.completed
                  ? (m.completed ?? _today)
                  : null,
            ),
      ],
      coverImageUrl: old?.coverImageUrl,
      imageUrls: old?.imageUrls ?? const [],
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
      history: [
        ...?old?.history,
        ProjectChange(at: now, actor: actor, note: notes.join(' · ')),
      ],
      isSample: old?.isSample ?? false,
    );
  }

  Future<void> _save() async {
    if (_saving) return; // prevents duplicate submissions
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actor = ref.read(demoSessionProvider)?.displayName ?? '—';
    try {
      final saved = await ref
          .read(projectsProvider.notifier)
          .save(_build(actor));
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.donRecordedLocal)));
      setState(() => _allowPop = true);
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.project(saved.id));
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

  Future<void> _cancel() async {
    if (!_dirty || await confirmDiscard(context)) {
      if (!mounted) return;
      setState(() => _allowPop = true);
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.projects);
      }
    }
  }

  Widget _gap(Widget child, {Key? key}) => Padding(
    key: key,
    padding: const EdgeInsets.only(bottom: AppSpacing.space4),
    child: child,
  );

  Widget _text(
    String key,
    String label,
    TextEditingController c, {
    bool required = false,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
  }) => _gap(
    key: Key(key),
    AppTextField(
      label: label,
      controller: c,
      isRequired: required,
      maxLines: maxLines,
      keyboardType: keyboard,
      inputFormatters: formatters,
      onChanged: (_) => _changed(),
      validator:
          validator ??
          (required
              ? (v) => projectErrorText(
                  ProjectValidation.requiredText(v),
                  context.l10n,
                )
              : null),
    ),
  );

  Widget _dateTile(
    Key key,
    String label,
    DateTime? value,
    ValueChanged<DateTime?> set,
  ) {
    final lang = ref.watch(localeProvider).languageCode;
    return ListTile(
      key: key,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today_outlined),
      title: Text(label),
      subtitle: Text(
        value == null ? '—' : AppDateFormatter.fullDate(value, locale: lang),
      ),
      trailing: value == null
          ? const Icon(Icons.edit_calendar_outlined)
          : IconButton(
              tooltip: context.l10n.newsClearSearch,
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                set(null);
                _changed();
              },
            ),
      onTap: () async {
        final d = await _pick(value);
        if (d != null) {
          set(d);
          _changed();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final mosqueName = ref.watch(mosqueProvider).value?.name.resolve(lang);
    final amountFormatter = FilteringTextInputFormatter.allow(
      RegExp(r'[0-9.,\-]'),
    );
    final dateError = projectErrorText(
      ProjectValidation.dates(_start, _end),
      l10n,
    );
    final campaigns = _campaignsFor(_currency);

    return PopScope(
      canPop: _allowPop || !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: Scaffold(
        appBar: AppTopBar(
          title: widget.initial == null ? l10n.projAdd : l10n.projEditTitle,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.space4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _text(
                          'projFieldTitle',
                          l10n.projFieldTitle,
                          _title,
                          required: true,
                        ),
                        _text(
                          'projFieldSummary',
                          l10n.projFieldSummary,
                          _summary,
                          required: true,
                          maxLines: 2,
                        ),
                        _text(
                          'projFieldDescription',
                          l10n.eventDescription,
                          _description,
                          maxLines: 4,
                        ),
                        _gap(
                          key: const Key('projFieldCategory'),
                          DropdownButtonFormField<String>(
                            initialValue: _categoryId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: '${l10n.projCategory} *',
                            ),
                            validator: (v) =>
                                v == null ? l10n.eventValidationChoose : null,
                            onChanged: (v) {
                              setState(() => _categoryId = v);
                              _changed();
                            },
                            items: [
                              for (final c in projectCategories)
                                DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name.resolve(lang)),
                                ),
                            ],
                          ),
                        ),
                        if (mosqueName != null)
                          _gap(
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.mosque_rounded),
                              title: Text(l10n.projMosque),
                              subtitle: Text(mosqueName),
                            ),
                          ),
                        _text(
                          'projFieldLocation',
                          l10n.projLocation,
                          _location,
                        ),
                        _text('projFieldManager', l10n.projManager, _manager),
                        _gap(
                          DropdownButtonFormField<Currency>(
                            initialValue: _currency,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.donCurrencyLabel,
                            ),
                            onChanged: (v) {
                              final next = v ?? Currency.usd;
                              setState(() {
                                _currency = next;
                                // A campaign in another currency can't fund
                                // this project: clear it here (not in build).
                                if (!_campaignsFor(next)
                                    .any((c) => c.id == _campaignId)) {
                                  _campaignId = null;
                                }
                              });
                              _changed();
                            },
                            items: [
                              for (final c in Currency.values)
                                DropdownMenuItem(value: c, child: Text(c.code)),
                            ],
                          ),
                        ),
                        _text(
                          'projFieldBudget',
                          l10n.projBudgetLabel(_currency.code),
                          _budget,
                          required: true,
                          keyboard: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          formatters: [amountFormatter],
                          validator: (v) => projectErrorText(
                            ProjectValidation.budget(v, _currency),
                            l10n,
                          ),
                        ),
                        _text(
                          'projFieldTarget',
                          l10n.projFundingTargetOptional(_currency.code),
                          _target,
                          keyboard: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          formatters: [amountFormatter],
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? null
                              : projectErrorText(
                                  ProjectValidation.budget(v, _currency),
                                  l10n,
                                ),
                        ),
                        _gap(
                          key: const Key('projFieldCampaign'),
                          DropdownButtonFormField<String?>(
                            // New key per currency → the field is recreated
                            // with the new items and value (no stale state).
                            key: ValueKey('projCampaign-${_currency.code}'),
                            initialValue: _campaignId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.projLinkedCampaign,
                              helperText: l10n.projLinkedCampaignHint,
                              helperMaxLines: 3,
                            ),
                            onChanged: (v) {
                              setState(() => _campaignId = v);
                              _changed();
                            },
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(l10n.projNoCampaignOption),
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
                        ),
                        _dateTile(
                          const Key('projFieldStart'),
                          l10n.donStartDate,
                          _start,
                          (d) => setState(() => _start = d),
                        ),
                        _dateTile(
                          const Key('projFieldEnd'),
                          l10n.projExpectedEndLabel,
                          _end,
                          (d) => setState(() => _end = d),
                        ),
                        if (dateError != null)
                          Text(
                            dateError,
                            key: const Key('projDateError'),
                            style: textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.space3),
                        _gap(
                          DropdownButtonFormField<ProjectStatus>(
                            initialValue: _status,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.eventFieldStatus,
                            ),
                            onChanged: (v) {
                              setState(
                                () => _status = v ?? ProjectStatus.planned,
                              );
                              _changed();
                            },
                            items: [
                              for (final s in ProjectStatus.values)
                                DropdownMenuItem(
                                  value: s,
                                  child: Text(s.label(l10n)),
                                ),
                            ],
                          ),
                        ),
                        _text(
                          'projFieldProgress',
                          l10n.projPhysicalProgressField,
                          _progress,
                          keyboard: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) => projectErrorText(
                            ProjectValidation.percent(v),
                            l10n,
                          ),
                        ),
                        _text(
                          'projFieldProgressNote',
                          l10n.projProgressNote,
                          _progressNote,
                          maxLines: 2,
                        ),
                        _text(
                          'projFieldObjectives',
                          l10n.projObjectives,
                          _objectives,
                          maxLines: 2,
                        ),
                        _text(
                          'projFieldBeneficiaries',
                          l10n.projBeneficiaries,
                          _beneficiaries,
                        ),
                        SwitchListTile(
                          key: const Key('projFieldFeatured'),
                          contentPadding: EdgeInsets.zero,
                          value: _featured,
                          title: Text(l10n.projFeaturedSwitch),
                          onChanged: (v) {
                            setState(() => _featured = v);
                            _changed();
                          },
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        AppButton.secondary(
                          label: l10n.projUploadImages,
                          icon: Icons.photo_library_outlined,
                          size: AppButtonSize.small,
                          onPressed: null,
                        ),
                        const SizedBox(height: AppSpacing.space1),
                        Text(
                          l10n.projImagesPending,
                          style: textTheme.bodySmall?.copyWith(
                            color: context.semanticColors.mutedText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space4),
                        Text(l10n.projMilestones, style: textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.space2),
                        for (final m in _milestones) _milestoneEditor(m),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton.icon(
                            key: const Key('projAddMilestone'),
                            onPressed: () {
                              setState(
                                () => _milestones.add(
                                  _MilestoneDraft(id: 'ms-new-${++_msSeq}'),
                                ),
                              );
                              _changed();
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.projAddMilestone),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space3),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton.secondary(
                        key: const Key('projCancel'),
                        label: l10n.profileCancel,
                        expand: true,
                        onPressed: _saving ? null : _cancel,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: AppButton.primary(
                        key: const Key('projSave'),
                        label: l10n.profileSave,
                        icon: Icons.check_rounded,
                        expand: true,
                        isLoading: _saving,
                        onPressed: dateError == null ? _save : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _milestoneEditor(_MilestoneDraft m) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    return Padding(
      key: ValueKey('msEditor-${m.id}'),
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: AppCard(
        variant: AppCardVariant.outlined,
        padding: const EdgeInsets.all(AppSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: m.title,
                    onChanged: (_) => _changed(),
                    decoration: InputDecoration(
                      labelText: l10n.projMilestoneTitle,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.projRemoveMilestone,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () {
                    setState(() => _milestones.remove(m));
                    _changed();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space2),
            DropdownButtonFormField<MilestoneStatus>(
              initialValue: m.status,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.eventFieldStatus),
              onChanged: (v) {
                setState(() => m.status = v ?? MilestoneStatus.pending);
                _changed();
              },
              items: [
                for (final s in MilestoneStatus.values)
                  DropdownMenuItem(value: s, child: Text(s.label(l10n))),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.projDueDate),
              subtitle: Text(
                m.due == null
                    ? '—'
                    : AppDateFormatter.fullDate(m.due!, locale: lang),
              ),
              onTap: () async {
                final d = await _pick(m.due);
                if (d != null) {
                  setState(() => m.due = d);
                  _changed();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Add / edit a progress update. Editing keeps the previous text in the
/// update's revision history.
class ProjectUpdateFormScreen extends ConsumerStatefulWidget {
  const ProjectUpdateFormScreen({
    super.key,
    required this.projectId,
    this.updateId,
  });

  final String projectId;
  final String? updateId;

  @override
  ConsumerState<ProjectUpdateFormScreen> createState() =>
      _ProjectUpdateFormScreenState();
}

class _ProjectUpdateFormScreenState
    extends ConsumerState<ProjectUpdateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _percent = TextEditingController();
  DateTime? _date;
  String? _milestoneId;
  bool _published = true;
  bool _loaded = false;
  bool _saving = false;
  ProjectUpdate? _existing;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _percent.dispose();
    super.dispose();
  }

  void _load(List<ProjectUpdate> updates) {
    if (_loaded) return;
    _loaded = true;
    final e = updates.where((u) => u.id == widget.updateId).firstOrNull;
    _existing = e;
    if (e != null) {
      _title.text = e.title;
      _description.text = e.description;
      _percent.text = e.progressPercent?.toString() ?? '';
      _date = e.date;
      _milestoneId = e.milestoneId;
      _published = e.isPublished;
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final now = ref.read(clockProvider).value ?? DateTime.now();
    try {
      await ref
          .read(projectUpdatesProvider.notifier)
          .save(
            ProjectUpdate(
              id: _existing?.id ?? '',
              projectId: widget.projectId,
              title: _title.text.trim(),
              description: _description.text.trim(),
              date: _date ?? now,
              progressPercent: int.tryParse(_percent.text.trim()),
              milestoneId: _milestoneId,
              author:
                  _existing?.author ??
                  ref.read(demoSessionProvider)?.displayName ??
                  '—',
              isPublished: _published,
            ),
            now: now,
          );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.donRecordedLocal)));
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.project(widget.projectId));
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
    return FinanceAsync<List<MosqueProject>, List<ProjectUpdate>>(
      first: ref.watch(projectsProvider),
      second: ref.watch(projectUpdatesProvider),
      onRetry: () => ref.invalidate(projectUpdatesProvider),
      builder: (projects, updates) {
        _load(updates);
        final project = projects
            .where((p) => p.id == widget.projectId)
            .firstOrNull;
        if (project == null) {
          return Scaffold(
            appBar: const AppTopBar(),
            body: EmptyState(
              icon: Icons.construction_rounded,
              title: l10n.projNotFound,
            ),
          );
        }
        return Scaffold(
          appBar: AppTopBar(
            title: _existing == null
                ? l10n.projAddUpdate
                : l10n.projEditUpdateTitle,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(project.title),
                    const SizedBox(height: AppSpacing.space3),
                    Padding(
                      key: const Key('updFieldTitle'),
                      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
                      child: AppTextField(
                        label: l10n.projUpdateTitle,
                        controller: _title,
                        isRequired: true,
                        validator: (v) => projectErrorText(
                          ProjectValidation.requiredText(v),
                          l10n,
                        ),
                      ),
                    ),
                    Padding(
                      key: const Key('updFieldDescription'),
                      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
                      child: AppTextField(
                        label: l10n.eventDescription,
                        controller: _description,
                        isRequired: true,
                        maxLines: 4,
                        validator: (v) => projectErrorText(
                          ProjectValidation.requiredText(v),
                          l10n,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text(l10n.donDate),
                      subtitle: Text(
                        AppDateFormatter.fullDate(
                          _date ??
                              ref.read(clockProvider).value ??
                              DateTime.now(),
                          locale: lang,
                        ),
                      ),
                      onTap: () async {
                        final now = DateTime.now();
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _date ?? now,
                          firstDate: DateTime(now.year - 10),
                          lastDate: DateTime(now.year + 1),
                        );
                        if (d != null) setState(() => _date = d);
                      },
                    ),
                    Padding(
                      key: const Key('updFieldPercent'),
                      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
                      child: AppTextField(
                        label: l10n.projUpdatePercent,
                        controller: _percent,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) => projectErrorText(
                          ProjectValidation.percent(v),
                          l10n,
                        ),
                      ),
                    ),
                    if (project.milestones.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.space4,
                        ),
                        child: DropdownButtonFormField<String?>(
                          initialValue: _milestoneId,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: l10n.projUpdateMilestone,
                          ),
                          onChanged: (v) => setState(() => _milestoneId = v),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('—'),
                            ),
                            for (final m in project.milestones)
                              DropdownMenuItem(
                                value: m.id,
                                child: Text(m.title),
                              ),
                          ],
                        ),
                      ),
                    SwitchListTile(
                      key: const Key('updFieldPublished'),
                      contentPadding: EdgeInsets.zero,
                      value: _published,
                      title: Text(l10n.projPublishSwitch),
                      subtitle: Text(l10n.projPublishHint),
                      onChanged: (v) => setState(() => _published = v),
                    ),
                    if (_existing != null && _existing!.revisions.isNotEmpty)
                      Text(l10n.projEditedTimes(_existing!.revisions.length)),
                    const SizedBox(height: AppSpacing.space4),
                    AppButton.primary(
                      key: const Key('updSave'),
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
      },
    );
  }
}
