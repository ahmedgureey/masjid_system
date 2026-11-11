import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../application/mosque_permissions.dart';
import '../data/mosque_repository.dart';
import '../models/mosque.dart';
import '../models/mosque_labels.dart';
import '../widgets/info_row.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section_card.dart';

/// "Macluumaadka Masaajidka" — public mosque profile. Only information that
/// has been entered is shown; empty sections say so.
class MosqueProfileScreen extends ConsumerWidget {
  const MosqueProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mosqueAsync = ref.watch(mosqueProvider);
    final canEdit = ref.watch(canEditMosqueProfileProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.profileTitle,
        actions: [
          if (canEdit)
            IconButton(
              tooltip: l10n.profileEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () =>
                  context.pushIfCurrent(AppRoutes.editMosqueProfile),
            ),
        ],
      ),
      body: mosqueAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (_, _) =>
            ErrorState(onRetry: () => ref.invalidate(mosqueProvider)),
        data: (mosque) => _ProfileBody(mosque: mosque, canEdit: canEdit),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.mosque, required this.canEdit});

  final Mosque mosque;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final textTheme = Theme.of(context).textTheme;
    void openEdit() => context.pushIfCurrent(AppRoutes.editMosqueProfile);
    final onAdd = canEdit ? openEdit : null;

    String? text(String? value) =>
        (value == null || value.trim().isEmpty) ? null : value.trim();
    final description = mosque.description?.resolve(lang);

    InfoRow? row(
      IconData icon,
      String label,
      String? value, {
      bool ltr = false,
    }) {
      final v = text(value);
      return v == null
          ? null
          : InfoRow(icon: icon, label: label, value: v, forceLtr: ltr);
    }

    final basic = [
      row(
        Icons.mosque_outlined,
        l10n.fieldMosqueName,
        mosque.name.resolve(lang),
      ),
      row(
        Icons.category_outlined,
        l10n.fieldCategory,
        mosque.category?.label(l10n),
      ),
      row(
        Icons.event_outlined,
        l10n.fieldEstablished,
        mosque.establishedYear?.toString(),
        ltr: true,
      ),
      row(
        Icons.badge_outlined,
        l10n.fieldRegistration,
        mosque.registrationNumber,
        ltr: true,
      ),
    ].nonNulls.toList();

    final location = [
      row(Icons.public_rounded, l10n.fieldCountry, mosque.country),
      row(Icons.location_city_rounded, l10n.fieldCity, mosque.city),
      row(Icons.holiday_village_outlined, l10n.fieldDistrict, mosque.district),
      row(Icons.place_outlined, l10n.fieldAddress, mosque.address),
      if (mosque.hasCoordinates)
        row(
          Icons.my_location_rounded,
          l10n.fieldCoordinates,
          '${mosque.latitude!.toStringAsFixed(6)}, '
          '${mosque.longitude!.toStringAsFixed(6)}',
          ltr: true,
        ),
    ].nonNulls.toList();

    final contact = [
      row(Icons.call_outlined, l10n.fieldPhone, mosque.phone, ltr: true),
      row(Icons.mail_outline_rounded, l10n.fieldEmail, mosque.email, ltr: true),
      row(Icons.language_rounded, l10n.fieldWebsite, mosque.website, ltr: true),
      for (final entry in mosque.socialLinks.entries)
        row(Icons.share_outlined, entry.key, entry.value, ltr: true),
    ].nonNulls.toList();

    final leadership = [
      row(Icons.record_voice_over_outlined, l10n.fieldImam, mosque.imamName),
      row(Icons.groups_outlined, l10n.fieldChairman, mosque.chairmanName),
      row(
        Icons.manage_accounts_outlined,
        l10n.fieldAdministrator,
        mosque.administratorName,
      ),
      row(
        Icons.account_balance_wallet_outlined,
        l10n.fieldTreasurer,
        mosque.treasurerName,
      ),
    ].nonNulls.toList();

    final facilities = [
      for (final facility in MosqueFacility.values)
        if (mosque.facilities.contains(facility))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space1),
            child: Row(
              children: [
                Icon(facility.icon, size: 20, color: AppColors.primary),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Text(facility.label(l10n), style: textTheme.bodyLarge),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
    ];

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(
              name: mosque.name.resolve(lang),
              descriptionText: text(description) ?? l10n.profileNoDescription,
              categoryLabel: mosque.category?.label(l10n),
              logoUrl: mosque.logoUrl,
              onEdit: canEdit ? openEdit : null,
              editLabel: l10n.profileEdit,
            ),
            if (canEdit) ...[
              const SizedBox(height: AppSpacing.space3),
              AppCard(
                variant: AppCardVariant.tinted,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: Text(
                        l10n.profileAuthNotice,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.space4),
            ProfileSectionCard(
              icon: Icons.info_outline_rounded,
              title: l10n.profileSectionBasic,
              onAdd: onAdd,
              children: basic,
            ),
            const SizedBox(height: AppSpacing.space3),
            ProfileSectionCard(
              icon: Icons.place_outlined,
              title: l10n.profileSectionLocation,
              onAdd: onAdd,
              children: location,
            ),
            const SizedBox(height: AppSpacing.space3),
            ProfileSectionCard(
              icon: Icons.contact_phone_outlined,
              title: l10n.profileSectionContact,
              onAdd: onAdd,
              children: contact,
            ),
            const SizedBox(height: AppSpacing.space3),
            ProfileSectionCard(
              icon: Icons.groups_outlined,
              title: l10n.profileSectionLeadership,
              onAdd: onAdd,
              footnote: l10n.profileLeadershipPrivacy,
              children: leadership,
            ),
            const SizedBox(height: AppSpacing.space3),
            // No service feature (prayer times, events, donations…) is built
            // yet — they are placeholders — so none is listed as available.
            ProfileSectionCard(
              icon: Icons.volunteer_activism_outlined,
              title: l10n.profileSectionServices,
              emptyMessage: l10n.profileServicesPending,
              children: const [],
            ),
            const SizedBox(height: AppSpacing.space3),
            ProfileSectionCard(
              icon: Icons.apartment_rounded,
              title: l10n.profileSectionFacilities,
              onAdd: onAdd,
              children: facilities,
            ),
          ],
        ),
      ),
    );
  }
}
