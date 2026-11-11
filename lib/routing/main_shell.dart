import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../core/localization/l10n.dart';

/// Bottom-navigation tabs, in display order (= shell branch order).
enum MainTab { home, settings, profile, about }

/// App shell with the bottom navigation: HOME · SETTINGS · PROFILE · ABOUT.
///
/// Uses the theme's `navigationBarTheme` (white bar, green selected icon and
/// label, grey unselected). The Home dashboard itself is unchanged; every
/// other screen (prayer times, calendar, news, donations…) still opens full
/// screen above this shell, so its back button returns to the tab.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(int index) => navigationShell.goBranch(
    index,
    // Re-tapping the active tab returns to its first screen.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final index = navigationShell.currentIndex;
    return PopScope(
      // System back on another tab returns to HOME instead of closing.
      canPop: index == MainTab.home.index,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(MainTab.home.index);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x141F2937),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBar(
            key: const Key('mainNavigationBar'),
            selectedIndex: index,
            onDestinationSelected: _select,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: l10n.tabHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_rounded),
                label: l10n.tabSettings,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_rounded),
                label: l10n.tabProfile,
              ),
              NavigationDestination(
                icon: const Icon(Icons.info_outline_rounded),
                label: l10n.tabAbout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
