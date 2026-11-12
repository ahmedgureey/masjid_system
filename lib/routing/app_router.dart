import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/about/screens/about_screen.dart';
import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/component_gallery/presentation/component_gallery_screen.dart';
import '../features/donations/application/finance_services.dart';
import '../features/donations/screens/campaign_screens.dart';
import '../features/donations/screens/donate_screen.dart';
import '../features/donations/screens/donations_screen.dart';
import '../features/donations/screens/expense_screens.dart';
import '../features/donations/screens/finance_report_screen.dart';
import '../features/donations/screens/history_receipt_screens.dart';
import '../features/donations/screens/staff_screens.dart';
import '../features/events/application/event_permissions.dart';
import '../features/events/screens/calendar_screen.dart';
import '../features/events/screens/edit_event_screen.dart';
import '../features/events/screens/event_details_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/mosque/application/mosque_permissions.dart';
import '../features/mosque/screens/edit_mosque_profile_screen.dart';
import '../features/mosque/screens/mosque_profile_screen.dart';
import '../features/news/application/news_permissions.dart';
import '../features/news/screens/article_details_screen.dart';
import '../features/news/screens/edit_article_screen.dart';
import '../features/news/screens/news_screen.dart';
import '../features/news/screens/saved_articles_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/onboarding/screens/language_selection_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/prayer_times/screens/prayer_times_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/projects/data/projects_repository.dart';
import '../features/projects/screens/project_details_screen.dart';
import '../features/projects/screens/project_form_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';
import 'not_found_screen.dart';
import 'placeholder_screen.dart';

/// The app's single [GoRouter] instance, exposed through Riverpod so that
/// later phases can make redirects depend on app state (session, mosque).
final appRouterProvider = Provider<GoRouter>((ref) {
  // FRONTEND-ONLY: hides staff finance screens; not a security boundary.
  String? financeGuard(BuildContext context, GoRouterState state) =>
      ref.read(canManageFinanceProvider) ? null : AppRoutes.donations;

  // FRONTEND-ONLY: hides project admin screens; not a security boundary.
  String? projectsGuard(BuildContext context, GoRouterState state) =>
      ref.read(canManageProjectsProvider) ? null : AppRoutes.projects;

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
      // Bottom navigation: HOME · SETTINGS · PROFILE · ABOUT. Each tab keeps
      // its own state. The Home dashboard is the unchanged HomeScreen.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.about,
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
      // Home menu targets — placeholders until their phase is built.
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
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
        builder: (context, state) => const NewsScreen(),
      ),
      // `saved` and `new` are declared before `:articleId` so they are not
      // read as ids.
      GoRoute(
        path: AppRoutes.savedArticles,
        builder: (context, state) => const SavedArticlesScreen(),
      ),
      GoRoute(
        path: AppRoutes.newArticle,
        redirect: (context, state) =>
            ref.read(canManageNewsProvider) ? null : AppRoutes.news,
        builder: (context, state) => const EditArticleScreen(),
      ),
      GoRoute(
        path: AppRoutes.articlePattern,
        builder: (context, state) =>
            ArticleDetailsScreen(articleId: state.pathParameters['articleId']!),
      ),
      GoRoute(
        path: AppRoutes.editArticlePattern,
        redirect: (context, state) => ref.read(canManageNewsProvider)
            ? null
            : AppRoutes.article(state.pathParameters['articleId']!),
        builder: (context, state) =>
            EditArticleScreen(articleId: state.pathParameters['articleId']!),
      ),
      // Donations (demo data; no payment is processed).
      GoRoute(
        path: AppRoutes.donations,
        builder: (context, state) => const DonationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.donationCampaigns,
        builder: (context, state) => const CampaignsScreen(),
      ),
      GoRoute(
        path: AppRoutes.campaignPattern,
        builder: (context, state) =>
            CampaignDetailsScreen(campaignId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.donate,
        builder: (context, state) => DonateScreen(
          campaignId: state.uri.queryParameters['campaign'],
          projectId: state.uri.queryParameters['project'],
        ),
      ),
      GoRoute(
        path: AppRoutes.donationHistory,
        builder: (context, state) => const DonationHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.receiptPattern,
        builder: (context, state) =>
            ReceiptScreen(donationId: state.pathParameters['id']!),
      ),
      // Staff screens — FRONTEND-ONLY guard (see canManageFinanceProvider).
      // Real permission checks belong to the backend (Supabase RLS).
      // `record` / `new` are declared before the `:id` routes.
      GoRoute(
        path: AppRoutes.financeStaff,
        redirect: financeGuard,
        builder: (context, state) => const StaffDonationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.recordDonation,
        redirect: financeGuard,
        builder: (context, state) => const RecordDonationScreen(),
      ),
      GoRoute(
        path: AppRoutes.staffDonationPattern,
        redirect: financeGuard,
        builder: (context, state) =>
            StaffDonationDetailsScreen(donationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.expenses,
        redirect: financeGuard,
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: AppRoutes.newExpense,
        redirect: financeGuard,
        builder: (context, state) => const ExpenseFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.expensePattern,
        redirect: financeGuard,
        builder: (context, state) =>
            ExpenseDetailsScreen(expenseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.financeReports,
        redirect: financeGuard,
        builder: (context, state) => const FinanceReportScreen(),
      ),
      // Projects ("Mashaariicda"). Admin routes: FRONTEND-ONLY guard (see
      // canManageProjectsProvider); real checks belong to the backend.
      GoRoute(
        path: AppRoutes.projects,
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: AppRoutes.newProject,
        redirect: projectsGuard,
        builder: (context, state) => const ProjectFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.projectPattern,
        builder: (context, state) =>
            ProjectDetailsScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.editProjectPattern,
        redirect: projectsGuard,
        builder: (context, state) =>
            ProjectFormScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.newProjectUpdatePattern,
        redirect: projectsGuard,
        builder: (context, state) =>
            ProjectUpdateFormScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.editProjectUpdatePattern,
        redirect: projectsGuard,
        builder: (context, state) => ProjectUpdateFormScreen(
          projectId: state.pathParameters['id']!,
          updateId: state.pathParameters['updateId'],
        ),
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
