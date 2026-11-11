import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/component_gallery/presentation/component_gallery_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import 'app_routes.dart';
import 'not_found_screen.dart';

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
