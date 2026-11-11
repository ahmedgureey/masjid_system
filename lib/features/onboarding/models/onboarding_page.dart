import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';

/// Content of one onboarding slide. Text is resolved from translations at
/// build time, so the same data works in English, Somali and Arabic.
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.accentIcon,
    required this.title,
    required this.body,
  });

  /// Main symbol drawn inside the arch illustration.
  final IconData icon;

  /// Small gold badge symbol.
  final IconData accentIcon;

  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) body;
}

/// The three onboarding slides (docs/design/screen-designs.md §2b).
final List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    icon: Icons.mosque_rounded,
    accentIcon: Icons.schedule_rounded,
    title: (l10n) => l10n.onboarding1Title,
    body: (l10n) => l10n.onboarding1Body,
  ),
  OnboardingPage(
    icon: Icons.volunteer_activism_rounded,
    accentIcon: Icons.verified_rounded,
    title: (l10n) => l10n.onboarding2Title,
    body: (l10n) => l10n.onboarding2Body,
  ),
  OnboardingPage(
    icon: Icons.menu_book_rounded,
    accentIcon: Icons.event_rounded,
    title: (l10n) => l10n.onboarding3Title,
    body: (l10n) => l10n.onboarding3Body,
  ),
];
