import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../routing/app_routes.dart';

/// One slide of the dashboard hero carousel: a service the mosque offers,
/// introduced with a short sentence (docs/al-ikhlas-plan.md §2).
///
/// Deliberately editorial — the compact index of the same services lives in
/// the menu grid below the header, so the two never look alike.
class MosqueServiceSlide {
  const MosqueServiceSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) subtitle;

  /// Opened when the slide is tapped. Always an existing route.
  final String route;
}

/// The six hero slides, in rotation order.
final List<MosqueServiceSlide> mosqueServiceSlides = [
  MosqueServiceSlide(
    icon: Icons.mosque_rounded,
    title: (l10n) => l10n.heroSalahTitle,
    subtitle: (l10n) => l10n.heroSalahSubtitle,
    route: AppRoutes.prayerSchedule,
  ),
  MosqueServiceSlide(
    icon: Icons.menu_book_rounded,
    title: (l10n) => l10n.heroQuranTitle,
    subtitle: (l10n) => l10n.heroQuranSubtitle,
    route: AppRoutes.news,
  ),
  MosqueServiceSlide(
    icon: Icons.construction_rounded,
    title: (l10n) => l10n.heroProjectsTitle,
    subtitle: (l10n) => l10n.heroProjectsSubtitle,
    route: AppRoutes.projects,
  ),
  MosqueServiceSlide(
    icon: Icons.volunteer_activism_rounded,
    title: (l10n) => l10n.heroDonationsTitle,
    subtitle: (l10n) => l10n.heroDonationsSubtitle,
    route: AppRoutes.donations,
  ),
  MosqueServiceSlide(
    icon: Icons.event_rounded,
    title: (l10n) => l10n.heroEventsTitle,
    subtitle: (l10n) => l10n.heroEventsSubtitle,
    route: AppRoutes.calendar,
  ),
  MosqueServiceSlide(
    icon: Icons.groups_rounded,
    title: (l10n) => l10n.heroCommunityTitle,
    subtitle: (l10n) => l10n.heroCommunitySubtitle,
    route: AppRoutes.mosqueProfile,
  ),
];
