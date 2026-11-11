import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/component_gallery/presentation/component_gallery_screen.dart';
import '../features/events/application/event_permissions.dart';
import '../features/events/screens/calendar_screen.dart';
import '../features/events/screens/edit_event_screen.dart';
import '../features/events/screens/event_details_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/mosque/application/mosque_permissions.dart';
import '../features/mosque/screens/edit_mosque_profile_screen.dart';
import '../features/mosque/screens/mosque_profile_screen.dart';
import '../features/onboarding/screens/language_selection_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/prayer_times/screens/prayer_times_screen.dart';
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
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Home menu targets — placeholders until their phase is built.
      GoRoute(
        path: AppRoutes.mosqueProfile,
        builder: (context, state) => const MosqueProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editMosqueProfile,
        // FRONTEND-ONLY guard (see canEditMosqueProfileProvider). Real
        // permission checks belong to the backend (Supabase RLS).
        redirect: (context, state) => ref.read(canEditMosqueProfileProvider)
            ? null
            : AppRoutes.mosqueProfile,
        builder: (context, state) => const EditMosqueProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.prayerSchedule,
        builder: (context, state) => const PrayerTimesScreen(),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => const CalendarScreen(),
      ),
      // FRONTEND-ONLY guard (see canManageEventsProvider). Real permission
      // checks belong to the backend (Supabase RLS). `new` is declared
      // before `:id` so it is not read as an event id.
      GoRoute(
        path: AppRoutes.newEvent,
        redirect: (context, state) =>
            ref.read(canManageEventsProvider) ? null : AppRoutes.calendar,
        builder: (context, state) => const EditEventScreen(),
      ),
      GoRoute(
        path: AppRoutes.eventDetailsPattern,
        builder: (context, state) =>
            EventDetailsScreen(eventId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.editEventPattern,
        redirect: (context, state) => ref.read(canManageEventsProvider)
            ? null
            : AppRoutes.eventDetails(state.pathParameters['id']!),
        builder: (context, state) =>
            EditEventScreen(eventId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.news,
        builder: (context, state) =>
            PlaceholderScreen(title: (l10n) => l10n.homeMenuNews),
      ),
      GoRoute(
        path: AppRoutes.donations,
        builder: (context, state) =>
            PlaceholderScreen(title: (l10n) => l10n.homeMenuDonations),
      ),
      GoRoute(
        path: AppRoutes.contact,
        builder: (context, state) =>
            PlaceholderScreen(title: (l10n) => l10n.homeMenuContact),
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
