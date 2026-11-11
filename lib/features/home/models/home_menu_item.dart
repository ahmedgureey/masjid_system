import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../routing/app_routes.dart';

/// One card of the home menu (docs/al-ikhlas-plan.md §2).
class HomeMenuItem {
  const HomeMenuItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  final IconData icon;
  final String Function(AppLocalizations l10n) title;
  final String route;
}

/// The six home cards, in display order (two columns × three rows).
final List<HomeMenuItem> homeMenuItems = [
  HomeMenuItem(
    icon: Icons.mosque_rounded,
    title: (l10n) => l10n.homeMenuProfile,
    route: AppRoutes.mosqueProfile,
  ),
  HomeMenuItem(
    icon: Icons.schedule_rounded,
    title: (l10n) => l10n.homeMenuPrayer,
    route: AppRoutes.prayerSchedule,
  ),
  HomeMenuItem(
    icon: Icons.calendar_month_rounded,
    title: (l10n) => l10n.homeMenuCalendar,
    route: AppRoutes.calendar,
  ),
  HomeMenuItem(
    icon: Icons.newspaper_rounded,
    title: (l10n) => l10n.homeMenuNews,
    route: AppRoutes.news,
  ),
  HomeMenuItem(
    icon: Icons.favorite_rounded,
    title: (l10n) => l10n.homeMenuDonations,
    route: AppRoutes.donations,
  ),
  // Replaces "Nala Soo Xiriir" (contact details remain in the mosque
  // profile; the /contact placeholder route is kept for later).
  HomeMenuItem(
    icon: Icons.construction_rounded,
    title: (l10n) => l10n.homeMenuProjects,
    route: AppRoutes.projects,
  ),
];
