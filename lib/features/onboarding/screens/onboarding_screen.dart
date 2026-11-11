import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../application/onboarding_controller.dart';
import '../models/onboarding_page.dart';
import '../widgets/onboarding_illustration.dart';
import '../widgets/page_indicator.dart';

/// Three onboarding slides (S-AUTH-03). "Skip" and "Get started" both finish
/// onboarding; it is not shown again on later launches.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  bool get _isLast => _index == onboardingPages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider).complete();
    if (mounted) context.go(AppRoutes.welcome);
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _pageController.jumpToPage(_index + 1);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppTopBar(
        actions: [
          if (!_isLast)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.space2),
              child: AppButton.text(
                label: l10n.onboardingSkip,
                onPressed: _finish,
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space6,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: OnboardingIllustration(
                            icon: page.icon,
                            accentIcon: page.accentIcon,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space6),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  page.title(l10n),
                                  textAlign: TextAlign.center,
                                  style: textTheme.headlineSmall,
                                ),
                                const SizedBox(height: AppSpacing.space3),
                                Text(
                                  page.body(l10n),
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.neutral500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            PageIndicator(count: onboardingPages.length, index: _index),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space6),
              child: AppButton.primary(
                label: _isLast
                    ? l10n.onboardingGetStarted
                    : l10n.onboardingNext,
                size: AppButtonSize.large,
                expand: true,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
