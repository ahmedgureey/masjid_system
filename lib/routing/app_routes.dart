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
  static const String donations = '/donations';
  static const String contact = '/contact';

  /// DEV ONLY — design-system component gallery.
  static const String components = '/components';
}
