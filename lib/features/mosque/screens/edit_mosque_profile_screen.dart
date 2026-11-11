import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/localized_text.dart';
import '../data/mosque_repository.dart';
import '../models/mosque.dart';
import '../models/mosque_labels.dart';

/// Edit form for mosque administrators.
///
/// Saves through [MosqueController] → repository. Today that is an
/// in-memory mock: the success message says the change is temporary.
/// Access is guarded by the router (frontend-only, see
/// `canEditMosqueProfileProvider`).
class EditMosqueProfileScreen extends ConsumerWidget {
  const EditMosqueProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mosqueAsync = ref.watch(mosqueProvider);
    return mosqueAsync.when(
      loading: () => const Scaffold(body: AppLoadingIndicator()),
      error: (_, _) => Scaffold(
        appBar: const AppTopBar(),
        body: ErrorState(onRetry: () => ref.invalidate(mosqueProvider)),
      ),
      // Form state is created once from the mosque as it was when opened.
      data: (mosque) => _EditForm(initial: mosque),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({required this.initial});

  final Mosque initial;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  final _formKey = GlobalKey<FormState>();
  late final String _lang = ref.read(localeProvider).languageCode;

  late final Map<String, TextEditingController> _c;
  late MosqueCategory? _category = widget.initial.category;
  late Set<MosqueFacility> _facilities = {...widget.initial.facilities};

  late final Map<String, String> _initialTexts;
  bool _saving = false;
  bool _allowPop = false;

  static const _keys = [
    'name',
    'description',
    'year',
    'registration',
    'country',
    'city',
    'district',
    'address',
    'lat',
    'lng',
    'phone',
    'email',
    'website',
    'imam',
    'chairman',
    'administrator',
    'treasurer',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.initial;
    _initialTexts = {
      'name': m.name.values[_lang] ?? m.name.resolve(_lang),
      'description': m.description?.values[_lang] ?? '',
      'year': m.establishedYear?.toString() ?? '',
      'registration': m.registrationNumber ?? '',
      'country': m.country ?? '',
      'city': m.city ?? '',
      'district': m.district ?? '',
      'address': m.address ?? '',
      'lat': m.latitude?.toString() ?? '',
      'lng': m.longitude?.toString() ?? '',
      'phone': m.phone ?? '',
      'email': m.email ?? '',
      'website': m.website ?? '',
      'imam': m.imamName ?? '',
      'chairman': m.chairmanName ?? '',
      'administrator': m.administratorName ?? '',
      'treasurer': m.treasurerName ?? '',
    };
    _c = {
      for (final key in _keys)
        key: TextEditingController(text: _initialTexts[key])
          ..addListener(_onChanged),
    };
  }

  @override
  void dispose() {
    for (final controller in _c.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _isDirty =>
      _keys.any((k) => _c[k]!.text != _initialTexts[k]) ||
      _category != widget.initial.category ||
      !_sameSet(_facilities, widget.initial.facilities);

  static bool _sameSet(Set<MosqueFacility> a, Set<MosqueFacility> b) =>
      a.length == b.length && a.containsAll(b);

  String? _value(String key) {
    final text = _c[key]!.text.trim();
    return text.isEmpty ? null : text;
  }

  /// Replaces the current-language entry of [original], keeping the others.
  LocalizedText? _withCurrentLanguage(LocalizedText? original, String? text) {
    final values = {...?original?.values}..remove(_lang);
    if (text != null) values[_lang] = text;
    return values.isEmpty ? null : LocalizedText(values);
  }

  Mosque _buildMosque() {
    final m = widget.initial;
    return Mosque(
      id: m.id,
      name: _withCurrentLanguage(m.name, _value('name'))!,
      subtitle: m.subtitle,
      description: _withCurrentLanguage(m.description, _value('description')),
      category: _category,
      establishedYear: int.tryParse(_value('year') ?? ''),
      registrationNumber: _value('registration'),
      logoUrl: m.logoUrl,
      coverUrl: m.coverUrl,
      country: _value('country'),
      city: _value('city'),
      district: _value('district'),
      address: _value('address'),
      latitude: double.tryParse(_value('lat') ?? ''),
      longitude: double.tryParse(_value('lng') ?? ''),
      phone: _value('phone'),
      email: _value('email'),
      website: _value('website'),
      socialLinks: m.socialLinks,
      imamName: _value('imam'),
      chairmanName: _value('chairman'),
      administratorName: _value('administrator'),
      treasurerName: _value('treasurer'),
      facilities: _facilities,
    );
  }

  Future<void> _save() async {
    if (_saving) return; // prevents duplicate submissions
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(mosqueProvider.notifier).save(_buildMosque());
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSavedLocal)));
      setState(() => _allowPop = true);
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(l10n.profileSaveError),
        ),
      );
    }
  }

  Future<void> _cancel() async {
    if (!_isDirty || await _confirmDiscard()) {
      if (!mounted) return;
      setState(() => _allowPop = true);
      context.pop();
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

  String _languageName(AppLocalizations l10n) => switch (_lang) {
    'ar' => l10n.languageArabic,
    'so' => l10n.languageSomali,
    _ => l10n.languageEnglish,
  };

  Widget _field(
    String key,
    String label, {
    FormFieldValidator<String>? validator,
    bool required = false,
    TextInputType? keyboard,
    bool ltr = false,
    int maxLines = 1,
    int? maxLength,
    IconData? icon,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: AppTextField(
        label: label,
        controller: _c[key],
        isRequired: required,
        validator: validator,
        keyboardType: keyboard,
        textDirection: ltr ? TextDirection.ltr : null,
        maxLines: maxLines,
        maxLength: maxLength,
        prefixIcon: icon,
        inputFormatters: formatters,
        textInputAction: maxLines > 1
            ? TextInputAction.newline
            : TextInputAction.next,
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: AppColors.green800),
            ),
            const SizedBox(height: AppSpacing.space4),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final maxYear = DateTime.now().year;
    final numberFormatter = FilteringTextInputFormatter.allow(
      RegExp(r'[0-9.\-]'),
    );

    return PopScope(
      canPop: _allowPop || !_isDirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: Scaffold(
        appBar: AppTopBar(title: l10n.profileEditTitle),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                // Not a ListView: all fields must stay mounted so the form
                // validates every field, including ones scrolled away.
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.space4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppCard(
                          variant: AppCardVariant.tinted,
                          child: Text(
                            l10n.editLanguageNote(_languageName(l10n)),
                            style: textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space4),
                        _section(l10n.profileSectionBasic, [
                          _field(
                            'name',
                            l10n.fieldMosqueName,
                            required: true,
                            icon: Icons.mosque_outlined,
                            validator: AppValidators.minChars(
                              l10n,
                              2,
                              l10n.validationRequired,
                            ),
                          ),
                          _field(
                            'description',
                            l10n.fieldDescription,
                            maxLines: 3,
                            maxLength: 300,
                          ),
                          _CategoryField(
                            label: l10n.fieldCategory,
                            value: _category,
                            onChanged: (value) =>
                                setState(() => _category = value),
                          ),
                          const SizedBox(height: AppSpacing.space4),
                          _field(
                            'year',
                            l10n.fieldEstablished,
                            keyboard: TextInputType.number,
                            ltr: true,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: AppValidators.optional(
                              AppValidators.year(l10n, min: 600, max: maxYear),
                            ),
                          ),
                          _field(
                            'registration',
                            l10n.fieldRegistration,
                            ltr: true,
                          ),
                          _LogoField(l10n: l10n),
                        ]),
                        _section(l10n.profileSectionLocation, [
                          _field('country', l10n.fieldCountry),
                          _field('city', l10n.fieldCity),
                          _field('district', l10n.fieldDistrict),
                          _field('address', l10n.fieldAddress, maxLines: 2),
                          _field(
                            'lat',
                            l10n.fieldLatitude,
                            ltr: true,
                            keyboard: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            formatters: [numberFormatter],
                            validator: _pairedCoordinate(
                              'lng',
                              AppValidators.latitude(l10n),
                              l10n,
                            ),
                          ),
                          _field(
                            'lng',
                            l10n.fieldLongitude,
                            ltr: true,
                            keyboard: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            formatters: [numberFormatter],
                            validator: _pairedCoordinate(
                              'lat',
                              AppValidators.longitude(l10n),
                              l10n,
                            ),
                          ),
                        ]),
                        _section(l10n.profileSectionContact, [
                          _field(
                            'phone',
                            l10n.fieldPhone,
                            ltr: true,
                            keyboard: TextInputType.phone,
                            icon: Icons.call_outlined,
                            formatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+\s-]'),
                              ),
                            ],
                            validator: AppValidators.optional(
                              AppValidators.phone(l10n),
                            ),
                          ),
                          _field(
                            'email',
                            l10n.fieldEmail,
                            ltr: true,
                            keyboard: TextInputType.emailAddress,
                            icon: Icons.mail_outline_rounded,
                            validator: AppValidators.optional(
                              AppValidators.email(l10n),
                            ),
                          ),
                          _field(
                            'website',
                            l10n.fieldWebsite,
                            ltr: true,
                            keyboard: TextInputType.url,
                            icon: Icons.language_rounded,
                            validator: AppValidators.optional(
                              AppValidators.url(l10n),
                            ),
                          ),
                        ]),
                        _section(l10n.profileSectionLeadership, [
                          _field('imam', l10n.fieldImam),
                          _field('chairman', l10n.fieldChairman),
                          _field('administrator', l10n.fieldAdministrator),
                          _field('treasurer', l10n.fieldTreasurer),
                          Text(
                            l10n.profileLeadershipPrivacy,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ]),
                        _section(l10n.profileSectionFacilities, [
                          Text(
                            l10n.facilitiesHint,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                          for (final facility in MosqueFacility.values)
                            AppCheckboxField(
                              key: ValueKey(facility),
                              initialValue: _facilities.contains(facility),
                              label: Text(facility.label(l10n)),
                              onChanged: (checked) => setState(() {
                                _facilities = checked
                                    ? {..._facilities, facility}
                                    : ({..._facilities}..remove(facility));
                              }),
                            ),
                        ]),
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

  /// Coordinates are optional, but latitude and longitude go together.
  FormFieldValidator<String> _pairedCoordinate(
    String otherKey,
    FormFieldValidator<String> rangeValidator,
    AppLocalizations l10n,
  ) {
    return (value) {
      final empty = value == null || value.trim().isEmpty;
      final otherEmpty = _c[otherKey]!.text.trim().isEmpty;
      if (empty) return otherEmpty ? null : l10n.validationRequired;
      return rangeValidator(value);
    };
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final MosqueCategory? value;
  final ValueChanged<MosqueCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.space2),
        DropdownButtonFormField<MosqueCategory?>(
          initialValue: value,
          isExpanded: true,
          onChanged: onChanged,
          items: [
            const DropdownMenuItem(value: null, child: Text('—')),
            for (final category in MosqueCategory.values)
              DropdownMenuItem(
                value: category,
                child: Text(category.label(l10n)),
              ),
          ],
        ),
      ],
    );
  }
}

/// Logo picker placeholder: uploading needs storage (Supabase), so the
/// button is disabled and says why instead of pretending to work.
class _LogoField extends StatelessWidget {
  const _LogoField({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.fieldLogo,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.space2),
        Row(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.green800,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: BrandMark(size: 48),
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: AppButton.secondary(
                label: l10n.logoUpload,
                icon: Icons.upload_rounded,
                size: AppButtonSize.small,
                onPressed: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          l10n.logoUploadPending,
          style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
        ),
      ],
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
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space4,
          AppSpacing.space3,
          AppSpacing.space4,
          AppSpacing.space3,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                label: cancelLabel,
                expand: true,
                onPressed: onCancel,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: AppButton.primary(
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
