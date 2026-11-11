/// Route paths of the app. Use these constants instead of string literals.
///
/// Routes for the remaining features are added module by module, following
/// `docs/design/navigation-flow.md`.
abstract final class AppRoutes {
  static const String splash = '/';

  // Onboarding (Module 2)
  static const String languageSelection = '/language';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';

  // Authentication (Module 3)
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';

  // Bottom-navigation tabs: HOME ([home]), SETTINGS, PROFILE, ABOUT.
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String about = '/about';

  static const String notifications = '/notifications';

  // Home menu (Masjid Al-Ikhlas). Placeholder screens until each phase.
  static const String mosqueProfile = '/mosque-profile';
  static const String editMosqueProfile = '/mosque-profile/edit';
  static const String prayerSchedule = '/prayer';
  static const String calendar = '/calendar';
  static const String newEvent = '/calendar/events/new';
  static const String eventDetailsPattern = '/calendar/events/:id';
  static const String editEventPattern = '/calendar/events/:id/edit';
  static String eventDetails(String id) =>
      '/calendar/events/${Uri.encodeComponent(id)}';
  static String editEvent(String id) =>
      '/calendar/events/${Uri.encodeComponent(id)}/edit';
  static const String news = '/news';
  static const String savedArticles = '/news/saved';
  static const String articlePattern = '/news/:articleId';
  static String article(String id) => '/news/${Uri.encodeComponent(id)}';
  static const String donations = '/donations';
  static const String donationCampaigns = '/donations/campaigns';
  static const String campaignPattern = '/donations/campaigns/:id';
  static String campaign(String id) =>
      '/donations/campaigns/${Uri.encodeComponent(id)}';
  static const String donate = '/donations/give';
  static String donateTo(String campaignId) =>
      '/donations/give?campaign=${Uri.encodeQueryComponent(campaignId)}';
  static const String donationHistory = '/donations/history';
  static const String receiptPattern = '/donations/receipt/:id';
  static String receipt(String donationId) =>
      '/donations/receipt/${Uri.encodeComponent(donationId)}';

  // Staff (treasurer / admin) — FRONTEND-ONLY guard, see
  // canManageFinanceProvider.
  static const String financeStaff = '/donations/staff';
  static const String recordDonation = '/donations/staff/record';
  static const String staffDonationPattern = '/donations/staff/records/:id';
  static String staffDonation(String id) =>
      '/donations/staff/records/${Uri.encodeComponent(id)}';
  static const String expenses = '/donations/staff/expenses';
  static const String newExpense = '/donations/staff/expenses/new';
  static const String expensePattern = '/donations/staff/expenses/:id';
  static String expense(String id) =>
      '/donations/staff/expenses/${Uri.encodeComponent(id)}';
  static const String financeReports = '/donations/reports';

  /// Donation form pre-set for a project (its linked campaign).
  static String donateToProject(String projectId, String campaignId) =>
      '/donations/give?campaign=${Uri.encodeQueryComponent(campaignId)}'
      '&project=${Uri.encodeQueryComponent(projectId)}';

  // Projects ("Mashaariicda"). Admin routes are FRONTEND-ONLY guarded, see
  // canManageProjectsProvider. `new` is declared before `:id`.
  static const String projects = '/projects';
  static const String newProject = '/projects/new';
  static const String projectPattern = '/projects/:id';
  static const String editProjectPattern = '/projects/:id/edit';
  static const String newProjectUpdatePattern = '/projects/:id/updates/new';
  static const String editProjectUpdatePattern =
      '/projects/:id/updates/:updateId/edit';
  static String project(String id) => '/projects/${Uri.encodeComponent(id)}';
  static String editProject(String id) =>
      '/projects/${Uri.encodeComponent(id)}/edit';
  static String newProjectUpdate(String id) =>
      '/projects/${Uri.encodeComponent(id)}/updates/new';
  static String editProjectUpdate(String id, String updateId) =>
      '/projects/${Uri.encodeComponent(id)}/updates/'
      '${Uri.encodeComponent(updateId)}/edit';
  static const String contact = '/contact';

  /// DEV ONLY — design-system component gallery.
  static const String components = '/components';
}
