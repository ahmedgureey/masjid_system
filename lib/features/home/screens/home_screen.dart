import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../authentication/application/demo_session_provider.dart';
import '../../mosque/data/mosque_repository.dart';
import '../models/home_menu_item.dart';
import '../widgets/home_header.dart';
import '../widgets/home_menu_card.dart';

/// Home screen for visitors (no login needed): mosque header and the six
/// menu cards. docs/al-ikhlas-plan.md §2.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(localeProvider).languageCode;
    final mosqueAsync = ref.watch(mosqueProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.semanticColors.pageBackground,
        body: mosqueAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(mosqueProvider)),
          data: (mosque) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(
                  name: mosque.name.resolve(locale),
                  subtitle: mosque.subtitle?.resolve(locale),
                  coverUrl: mosque.coverUrl,
                  logoUrl: mosque.logoUrl,
                  dateText: AppDateFormatter.fullDate(now, locale: locale),
                  timeText: AppDateFormatter.time(
                    now,
                    use24h: use24h,
                    locale: locale,
                  ),
                  isDarkMode: ref.watch(themeModeProvider) == ThemeMode.dark,
                  onToggleTheme: () =>
                      ref.read(themeModeProvider.notifier).toggle(),
                  onNotificationsTap: () =>
                      context.pushIfCurrent(AppRoutes.notifications),
                  onServiceTap: (route) => context.pushIfCurrent(route),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.space4,
                      AppSpacing.space4,
                      AppSpacing.space4,
                      AppSpacing.space6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _DemoSessionBanner(),
                        SectionHeader(title: l10n.homeMenuTitle),
                        _MenuGrid(items: homeMenuItems),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Two-column grid; cards in a row share the same height.
class _MenuGrid extends StatelessWidget {
  const _MenuGrid({required this.items});

  final List<HomeMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final pair = items.skip(i).take(2).toList();
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < 2; j++) ...[
                if (j == 1) const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: j < pair.length
                      ? HomeMenuCard(
                          icon: pair[j].icon,
                          title: pair[j].title(l10n),
                          onTap: () => context.pushIfCurrent(pair[j].route),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: AppSpacing.space3));
      }
    }
    return Column(children: rows);
  }
}

/// Shown only after the (temporary) demo login, so it is never mistaken for
/// a real account.
class _DemoSessionBanner extends ConsumerWidget {
  const _DemoSessionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(demoSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: AppCard(
        variant: AppCardVariant.gold,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.science_outlined,
              color: context.semanticColors.goldText,
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.demoBannerTitle,
                    style: textTheme.titleSmall?.copyWith(
                      color: context.semanticColors.goldText,
                    ),
                  ),
                  Text(
                    l10n.demoBannerMessage,
                    style: textTheme.bodyMedium?.copyWith(
                      color: context.semanticColors.goldText,
                    ),
                  ),
                  TextButton(
                    // Flush with the text above it; still a full-height tap
                    // target.
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, AppSizes.minTouchTarget),
                      alignment: AlignmentDirectional.centerStart,
                    ),
                    onPressed: () {
                      ref.read(demoSessionProvider.notifier).signOut();
                      context.go(AppRoutes.home);
                    },
                    child: Text(l10n.logout),
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
