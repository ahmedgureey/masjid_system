import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/widgets/language/language_selector_button.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';

/// SETTINGS tab. Language, Appearance (light / dark) and About App work;
/// the other sections are listed but disabled and clearly marked "coming
/// soon" — nothing pretends to work.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.settingsTitle,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsTile(
                    key: const Key('settingsNotifications'),
                    icon: Icons.notifications_none_rounded,
                    title: l10n.settingsNotifications,
                    subtitle: l10n.settingsNotificationsPending,
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    key: const Key('settingsLanguage'),
                    icon: Icons.language_rounded,
                    title: l10n.settingsLanguage,
                    subtitle: l10n.settingsLanguageHint,
                    onTap: () => showLanguageSheet(context),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    key: const Key('settingsAppearance'),
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.semanticColors.tintedBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(l10n.settingsAppearance),
                    subtitle: Text(
                      isDark ? l10n.themeDarkActive : l10n.themeLightActive,
                    ),
                    value: isDark,
                    onChanged: (_) =>
                        ref.read(themeModeProvider.notifier).toggle(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsTile(
                    key: const Key('settingsPrivacy'),
                    icon: Icons.shield_outlined,
                    title: l10n.settingsPrivacy,
                    subtitle: l10n.settingsPrivacyPending,
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    key: const Key('settingsHelp'),
                    icon: Icons.help_outline_rounded,
                    title: l10n.settingsHelp,
                    subtitle: l10n.settingsHelpPending,
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    key: const Key('settingsAbout'),
                    icon: Icons.info_outline_rounded,
                    title: l10n.settingsAbout,
                    subtitle: l10n.settingsAboutHint,
                    // Switches to the ABOUT tab.
                    onTap: () => context.go(AppRoutes.about),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One settings row. Without [onTap] the row is disabled and shows a
/// "coming soon" badge.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final enabled = onTap != null;
    return ListTile(
      enabled: enabled,
      onTap: onTap,
      minVerticalPadding: AppSpacing.space3,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled
              ? context.semanticColors.tintedBackground
              : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurfaceRaised
                    : AppColors.neutral50),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled
              ? Theme.of(context).colorScheme.primary
              : context.semanticColors.mutedText,
        ),
      ),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: enabled
          ? const Icon(Icons.chevron_right_rounded)
          : StatusChip(label: l10n.comingSoonTitle),
    );
  }
}
