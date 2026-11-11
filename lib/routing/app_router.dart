import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/component_gallery/presentation/component_gallery_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/screens/language_selection_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';
import 'not_found_screen.dart';
import 'placeholder_screen.dart';

/// The app's single [GoRouter] instance, exposed through Riverpod so that
/// later phases can make redirects depend on app state (session, mosque).
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelection,
        name: 'language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      // Placeholders until Module 3 (Authentication UI).
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) =>
            PlaceholderScreen(title: (l10n) => l10n.authLogin),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) =>
            PlaceholderScreen(title: (l10n) => l10n.authCreateAccount),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.components,
        name: 'components',
        builder: (context, state) => const ComponentGalleryScreen(),
      ),
    ],
    errorBuilder: (context, state) => NotFoundScreen(location: state.uri),
  );
  ref.onDispose(router.dispose);
  return router;
});
