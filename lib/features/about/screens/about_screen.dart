import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Developer details supplied by the owner (shown exactly as given).
abstract final class DeveloperInfo {
  static const String name = 'Ahmed Gureey';
  static const String title = 'Mobile App Developer';
  static const String phone = '0612341376';
  static const String email = 'ahmedgureey2018@gmail.com';
  static const String location = 'Muqdisho, Soomaaliya';
}

/// Availability of an app feature, shown honestly on the About screen.
enum FeatureState { availableDemo, comingSoon }

/// ABOUT tab: app information, features (with their real status) and the
/// developer card.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final features = <(IconData, String, String, FeatureState)>[
      (
        Icons.schedule_rounded,
        l10n.aboutFeaturePrayer,
        l10n.aboutFeaturePrayerDesc,
        FeatureState.availableDemo,
      ),
      (
        Icons.volunteer_activism_rounded,
        l10n.aboutFeatureDonations,
        l10n.aboutFeatureDonationsDesc,
        FeatureState.availableDemo,
      ),
      (
        Icons.event_rounded,
        l10n.aboutFeatureEvents,
        l10n.aboutFeatureEventsDesc,
        FeatureState.availableDemo,
      ),
      (
        Icons.menu_book_rounded,
        l10n.aboutFeatureQuran,
        l10n.aboutFeatureQuranDesc,
        FeatureState.comingSoon,
      ),
      (
        Icons.campaign_rounded,
        l10n.aboutFeatureAnnouncements,
        l10n.aboutFeatureAnnouncementsDesc,
        FeatureState.availableDemo,
      ),
      (
        Icons.notifications_rounded,
        l10n.aboutFeatureNotifications,
        l10n.aboutFeatureNotificationsDesc,
        FeatureState.comingSoon,
      ),
      (
        Icons.person_rounded,
        l10n.aboutFeatureProfile,
        l10n.aboutFeatureProfileDesc,
        FeatureState.availableDemo,
      ),
      (
        Icons.settings_rounded,
        l10n.aboutFeatureSettings,
        l10n.aboutFeatureSettingsDesc,
        FeatureState.availableDemo,
      ),
    ];

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.aboutTitle,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            // App header.
            HeroCard(
              child: Column(
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.green800,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.white, width: 3),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: BrandMark(size: 72),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  Text(
                    AppConstants.appName,
                    key: const Key('aboutAppName'),
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    l10n.aboutVersion(AppConstants.appVersion),
                    key: const Key('aboutVersion'),
                    style: textTheme.bodySmall?.copyWith(
                      color: context.semanticColors.goldOnDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.aboutDescriptionTitle, style: textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.space2),
                  Text(l10n.aboutDescription1, style: textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.space2),
                  Text(l10n.aboutDescription2, style: textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            SectionHeader(title: l10n.aboutFeaturesTitle),
            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space4,
                vertical: AppSpacing.space2,
              ),
              child: Column(
                children: [
                  for (final (icon, title, desc, state) in features)
                    _FeatureRow(
                      icon: icon,
                      title: title,
                      description: desc,
                      state: state,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              l10n.aboutFeaturesNote,
              style: textTheme.bodySmall?.copyWith(
                color: context.semanticColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.space5),
            SectionHeader(title: l10n.aboutDeveloperTitle),
            const DeveloperCard(),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.state,
  });

  final IconData icon;
  final String title;
  final String description;
  final FeatureState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.semanticColors.tintedBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    state == FeatureState.availableDemo
                        ? StatusChip(
                            label: l10n.aboutStatusDemo,
                            type: StatusType.success,
                          )
                        : StatusChip(label: l10n.comingSoonTitle),
                  ],
                ),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: context.semanticColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "About the Developer" card. The email is tappable: without a
/// url_launcher dependency it copies the address to the clipboard instead
/// of opening the mail app.
class DeveloperCard extends StatelessWidget {
  const DeveloperCard({super.key});

  Future<void> _copy(BuildContext context, String value, String message) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;

    Widget contact({
      required Key key,
      required IconData icon,
      required String label,
      required String value,
      VoidCallback? onTap,
      bool ltr = false,
    }) => InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.space2,
          horizontal: AppSpacing.space1,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.semanticColors.mutedText,
                    ),
                  ),
                  Text(
                    value,
                    textDirection: ltr ? TextDirection.ltr : null,
                    style: textTheme.bodyLarge?.copyWith(
                      color: onTap == null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.neutral400,
              ),
          ],
        ),
      ),
    );

    return AppCard(
      key: const Key('developerCard'),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: semantic.heroGradient,
              border: Border.all(color: semantic.gold, width: 3),
            ),
            child: Center(
              child: Text(
                'AG',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            DeveloperInfo.name,
            key: const Key('developerName'),
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: context.semanticColors.brandText,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            DeveloperInfo.title,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall?.copyWith(color: semantic.goldText),
          ),
          const Divider(height: AppSpacing.space6),
          contact(
            key: const Key('developerEmail'),
            icon: Icons.email_outlined,
            label: l10n.aboutEmail,
            value: DeveloperInfo.email,
            ltr: true,
            onTap: () =>
                _copy(context, DeveloperInfo.email, l10n.aboutEmailCopied),
          ),
          contact(
            key: const Key('developerPhone'),
            icon: Icons.call_outlined,
            label: l10n.aboutPhone,
            value: DeveloperInfo.phone,
            ltr: true,
            onTap: () =>
                _copy(context, DeveloperInfo.phone, l10n.aboutPhoneCopied),
          ),
          contact(
            key: const Key('developerLocation'),
            icon: Icons.location_on_outlined,
            label: l10n.aboutLocation,
            value: DeveloperInfo.location,
          ),
        ],
      ),
    );
  }
}
