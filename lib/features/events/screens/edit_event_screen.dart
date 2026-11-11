import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../application/event_validation.dart';
import '../data/events_repository.dart';
import '../models/event_labels.dart';
import '../models/mosque_event.dart';

/// Add / edit event form for mosque administrators ("Ku dar Dhacdo" /
/// "Wax ka beddel"). Access is guarded by the router (frontend-only, see
/// `canManageEventsProvider`). Saves go to the in-memory mock repository;
/// the success message says the change is temporary.
class EditEventScreen extends ConsumerWidget {
  const EditEventScreen({super.key, this.eventId});

  /// Null → new event.
  final String? eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final eventsAsync = ref.watch(eventsProvider);
    return eventsAsync.when(
      loading: () => const Scaffold(body: AppLoadingIndicator()),
      error: (_, _) => Scaffold(
        appBar: const AppTopBar(),
        body: ErrorState(onRetry: () => ref.invalidate(eventsProvider)),
      ),
      data: (events) {
        if (eventId == null) return const _EventForm(initial: null);
        final event = events.where((e) => e.id == eventId).firstOrNull;
        if (event == null) {
          return Scaffold(
            appBar: const AppTopBar(),
            body: EmptyState(
              icon: Icons.event_busy_rounded,
              title: l10n.eventNotFound,
            ),
          );
        }
        return _EventForm(initial: event);
      },
    );
  }
}

class _EventForm extends ConsumerStatefulWidget {
  const _EventForm({required this.initial});

  final MosqueEvent? initial;

  @override
  ConsumerState<_EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<_EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final String _lang = ref.read(localeProvider).languageCode;

  late final _title = TextEditingController(text: widget.initial?.title);
  late final _description = TextEditingController(
    text: widget.initial?.description,
  );
  late final _location = TextEditingController(text: widget.initial?.location);
  late final _organizer = TextEditingController(
    text: widget.initial?.organizer,
  );
  late final _registrationDetails = TextEditingController(
    text: widget.initial?.registration?.details,
  );
  final _dateText = TextEditingController();
  final _startText = TextEditingController();
  final _endText = TextEditingController();

  late EventCategory? _category = widget.initial?.category;
  late EventStatus _status = widget.initial?.status ?? EventStatus.scheduled;
  late DateTime? _date = widget.initial?.start;
  late TimeOfDay? _start = widget.initial == null
      ? null
      : TimeOfDay.fromDateTime(widget.initial!.start);
  late TimeOfDay? _end = widget.initial?.end == null
      ? null
      : TimeOfDay.fromDateTime(widget.initial!.end!);
  late bool _registration = widget.initial?.registration != null;

  bool _saving = false;
  bool _allowPop = false;

  bool get _isNew => widget.initial == null;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _title,
      _description,
      _location,
      _organizer,
      _registrationDetails,
    ]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshPickerTexts();
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _location,
      _organizer,
      _registrationDetails,
      _dateText,
      _startText,
      _endText,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  String _formatTime(TimeOfDay t) => AppDateFormatter.time(
    DateTime(2000, 1, 1, t.hour, t.minute),
    use24h: MediaQuery.alwaysUse24HourFormatOf(context),
    locale: _lang,
  );

  void _refreshPickerTexts() {
    _dateText.text = _date == null
        ? ''
        : AppDateFormatter.fullDate(_date!, locale: _lang);
    _startText.text = _start == null ? '' : _formatTime(_start!);
    _endText.text = _end == null ? '' : _formatTime(_end!);
  }

  static int? _minutes(TimeOfDay? t) =>
      t == null ? null : t.hour * 60 + t.minute;

  MosqueEvent _snapshot() {
    final i = widget.initial;
    final date = _date;
    final start = _start;
    String? opt(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final startDate = date == null || start == null
        ? (i?.start ?? DateTime(0))
        : DateTime(date.year, date.month, date.day, start.hour, start.minute);
    final end = _end;
    return MosqueEvent(
      id: i?.id ?? 'local-${DateTime.now().microsecondsSinceEpoch}',
      title: _title.text.trim(),
      description: _description.text.trim(),
      category: _category ?? EventCategory.other,
      start: startDate,
      end: end == null || date == null
          ? null
          : DateTime(date.year, date.month, date.day, end.hour, end.minute),
      location: _location.text.trim(),
      organizer: opt(_organizer),
      imageUrl: i?.imageUrl,
      status: _status,
      registration: _registration && opt(_registrationDetails) != null
          ? EventRegistration(details: opt(_registrationDetails)!)
          : null,
      isSample: i?.isSample ?? false,
    );
  }

  bool get _isDirty {
    final i = widget.initial;
    if (i == null) {
      return _title.text.trim().isNotEmpty ||
          _description.text.trim().isNotEmpty ||
          _location.text.trim().isNotEmpty ||
          _organizer.text.trim().isNotEmpty ||
          _registrationDetails.text.trim().isNotEmpty ||
          _category != null ||
          _date != null ||
          _start != null ||
          _end != null ||
          _registration ||
          _status != EventStatus.scheduled;
    }
    final s = _snapshot();
    return s.title != i.title ||
        s.description != i.description ||
        s.category != i.category ||
        s.start != i.start ||
        s.end != i.end ||
        s.location != i.location ||
        s.organizer != i.organizer ||
        s.status != i.status ||
        s.registration != i.registration ||
        _registration != (i.registration != null);
  }

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider).value ?? DateTime.now();
    final initial = _date ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(initial.year - 5),
      lastDate: DateTime(now.year + 5, 12, 31),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _date = picked;
      _refreshPickerTexts();
    });
  }

  Future<void> _pickTime({required bool start}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          (start ? _start : _end ?? _start) ??
          const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (start) {
        _start = picked;
      } else {
        _end = picked;
      }
      _refreshPickerTexts();
    });
  }

  String? _dateTimeMessage(EventDateTimeError? error) {
    final l10n = context.l10n;
    return switch (error) {
      null => null,
      EventDateTimeError.required => l10n.validationRequired,
      EventDateTimeError.pastDate => l10n.eventValidationPastDate,
      EventDateTimeError.endNotAfterStart => l10n.eventValidationEndBeforeStart,
    };
  }

  Future<void> _save() async {
    if (_saving) return; // prevents duplicate submissions
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(eventsProvider.notifier).save(_snapshot());
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.eventSavedLocal)));
      setState(() => _allowPop = true);
      _leave();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(l10n.eventSaveError),
        ),
      );
    }
  }

  /// Back to the previous screen, or to the calendar when the form was
  /// opened directly (deep link) and there is nothing to go back to.
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.calendar);
    }
  }

  Future<void> _cancel() async {
    if (!_isDirty || await _confirmDiscard()) {
      if (!mounted) return;
      setState(() => _allowPop = true);
      _leave();
    }
  }

  Future<bool> _confirmDiscard() async {
    final l10n = context.l10n;
    final discard = await showDialog<bool>(
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
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.discardConfirm),
          ),
        ],
      ),
    );
    return discard ?? false;
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
    final today = ref.watch(clockProvider).value ?? DateTime.now();

    return PopScope(
      canPop: _allowPop || !_isDirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: Scaffold(
        appBar: AppTopBar(
          title: _isNew ? l10n.eventFormNewTitle : l10n.eventFormEditTitle,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                // Not a ListView: every field stays mounted for validation.
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.space4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _gap(
                          key: const Key('eventFieldTitle'),
                          AppTextField(
                            label: l10n.eventFieldTitle,
                            controller: _title,
                            isRequired: true,
                            maxLength: 100,
                            textInputAction: TextInputAction.next,
                            validator: AppValidators.minChars(
                              l10n,
                              3,
                              l10n.validationRequired,
                            ),
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldDescription'),
                          AppTextField(
                            label: l10n.eventDescription,
                            controller: _description,
                            isRequired: true,
                            maxLines: 4,
                            maxLength: 1000,
                            validator: AppValidators.required(l10n),
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldCategory'),
                          DropdownButtonFormField<EventCategory>(
                            initialValue: _category,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: '${l10n.eventCategory} *',
                            ),
                            validator: (v) =>
                                v == null ? l10n.eventValidationChoose : null,
                            onChanged: (v) => setState(() => _category = v),
                            items: [
                              for (final c in EventCategory.values)
                                DropdownMenuItem(
                                  value: c,
                                  child: Text(c.label(l10n)),
                                ),
                            ],
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldDate'),
                          AppTextField(
                            label: l10n.eventDate,
                            controller: _dateText,
                            isRequired: true,
                            readOnly: true,
                            prefixIcon: Icons.calendar_today_outlined,
                            onTap: _pickDate,
                            validator: (_) => _dateTimeMessage(
                              EventValidation.date(
                                _date,
                                today: today,
                                isNew: _isNew,
                              ),
                            ),
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldStart'),
                          AppTextField(
                            label: l10n.eventFieldStart,
                            controller: _startText,
                            isRequired: true,
                            readOnly: true,
                            prefixIcon: Icons.schedule_rounded,
                            onTap: () => _pickTime(start: true),
                            validator: (_) => _dateTimeMessage(
                              EventValidation.startTime(_minutes(_start)),
                            ),
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldEnd'),
                          AppTextField(
                            label: l10n.eventFieldEnd,
                            controller: _endText,
                            readOnly: true,
                            prefixIcon: Icons.schedule_outlined,
                            onTap: () => _pickTime(start: false),
                            suffix: _end == null
                                ? null
                                : IconButton(
                                    tooltip: l10n.eventClearEnd,
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () => setState(() {
                                      _end = null;
                                      _refreshPickerTexts();
                                    }),
                                  ),
                            validator: (_) => _dateTimeMessage(
                              EventValidation.endTime(
                                _minutes(_start),
                                _minutes(_end),
                              ),
                            ),
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldLocation'),
                          AppTextField(
                            label: l10n.eventLocation,
                            controller: _location,
                            isRequired: true,
                            prefixIcon: Icons.place_outlined,
                            validator: AppValidators.required(l10n),
                          ),
                        ),
                        _gap(
                          key: const Key('eventFieldOrganizer'),
                          AppTextField(
                            label: l10n.eventOrganizer,
                            controller: _organizer,
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                        ),
                        _gap(
                          DropdownButtonFormField<EventStatus>(
                            initialValue: _status,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.eventFieldStatus,
                            ),
                            onChanged: (v) => setState(
                              () => _status = v ?? EventStatus.scheduled,
                            ),
                            items: [
                              for (final s in EventStatus.values)
                                DropdownMenuItem(
                                  value: s,
                                  child: Text(s.label(l10n)),
                                ),
                            ],
                          ),
                        ),
                        _gap(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.eventFieldImage,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.space2),
                              AppButton.secondary(
                                label: l10n.eventImageUpload,
                                icon: Icons.image_outlined,
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
                        SwitchListTile(
                          key: const Key('eventFieldRegistrationSwitch'),
                          contentPadding: EdgeInsets.zero,
                          value: _registration,
                          title: Text(l10n.eventRegistrationRequired),
                          onChanged: (v) => setState(() => _registration = v),
                        ),
                        if (_registration)
                          _gap(
                            key: const Key('eventFieldRegistration'),
                            AppTextField(
                              label: l10n.eventFieldRegistrationDetails,
                              controller: _registrationDetails,
                              isRequired: true,
                              maxLines: 3,
                              validator: AppValidators.required(l10n),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              _ActionBar(
                saveLabel: l10n.profileSave,
                cancelLabel: l10n.profileCancel,
                saving: _saving,
                onSave: _save,
                onCancel: _saving ? null : _cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.saveLabel,
    required this.cancelLabel,
    required this.saving,
    required this.onSave,
    required this.onCancel,
  });

  final String saveLabel;
  final String cancelLabel;
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F1F2937),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space3),
        child: Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                key: const Key('eventCancelButton'),
                label: cancelLabel,
                expand: true,
                onPressed: onCancel,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: AppButton.primary(
                key: const Key('eventSaveButton'),
                label: saveLabel,
                icon: Icons.check_rounded,
                expand: true,
                isLoading: saving,
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
