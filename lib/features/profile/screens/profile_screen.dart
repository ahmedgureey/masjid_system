import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../authentication/application/demo_session_provider.dart';
import '../../settings/screens/settings_screen.dart';

/// PROFILE tab. Shows the (demo) session: name, email and phone as typed on
/// the login / register form (memory only). Editing the profile and
/// changing the password need the backend, so they are not offered as
/// working features.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final session = ref.watch(demoSessionProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.profileTabTitle,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: session == null
            ? LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: EmptyState(
                        icon: Icons.account_circle_outlined,
                        title: l10n.profileSignedOutTitle,
                        message: l10n.profileSignedOutMessage,
                        actionLabel: l10n.profileSignIn,
                        onAction: () => context.pushIfCurrent(AppRoutes.login),
                      ),
                    ),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.space4),
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        UserAvatar(name: session.displayName, size: 80),
                        const SizedBox(height: AppSpacing.space3),
                        Text(
                          session.displayName,
                          key: const Key('profileName'),
                          textAlign: TextAlign.center,
                          style: textTheme.titleLarge?.copyWith(
                            color: context.semanticColors.brandText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (session.email != null)
                          Text(
                            session.email!,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: context.semanticColors.mutedText,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.space2),
                        StatusChip(
                          label: l10n.demoBannerTitle,
                          type: StatusType.gold,
                          icon: Icons.science_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  AppCard(
                    key: const Key('profileAccountInfo'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.profileAccountInfo,
                          style: textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        _InfoLine(
                          icon: Icons.person_outline_rounded,
                          label: l10n.profileFullName,
                          value: session.displayName,
                        ),
                        _InfoLine(
                          icon: Icons.mail_outline_rounded,
                          label: l10n.profileEmail,
                          value: session.email ?? l10n.profileNotProvided,
                        ),
                        _InfoLine(
                          icon: Icons.call_outlined,
                          label: l10n.profilePhone,
                          value: session.phone ?? l10n.profileNotProvided,
                        ),
                        _InfoLine(
                          icon: Icons.verified_user_outlined,
                          label: l10n.profileAccountType,
                          value: l10n.profileDemoAccount,
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        Text(
                          l10n.profileDemoNote,
                          style: textTheme.bodySmall?.copyWith(
                            color: context.semanticColors.mutedText,
                          ),
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
                          key: const Key('profileEdit'),
                          icon: Icons.edit_outlined,
                          title: l10n.profileEditProfile,
                          subtitle: l10n.profileNeedsBackend,
                        ),
                        const Divider(height: 1),
                        SettingsTile(
                          key: const Key('profileChangePassword'),
                          icon: Icons.lock_outline_rounded,
                          title: l10n.profileChangePassword,
                          subtitle: l10n.profileNeedsBackend,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  AppButton.destructive(
                    key: const Key('profileSignOut'),
                    label: l10n.logout,
                    icon: Icons.logout_rounded,
                    expand: true,
                    onPressed: () {
                      ref.read(demoSessionProvider.notifier).signOut();
                      context.go(AppRoutes.home);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(value, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Round avatar with the user's initials (no photo upload yet).
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.size = 40});

  final String? name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w.characters.first.toUpperCase())
        .join();
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.gold300,
      foregroundColor: AppColors.green900,
      child: initials.isEmpty
          ? Icon(Icons.person_rounded, size: size * 0.6)
          : Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
