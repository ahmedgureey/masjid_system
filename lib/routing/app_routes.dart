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

  // Authentication (Module 3 — placeholders until then)
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';

  /// DEV ONLY — design-system component gallery.
  static const String components = '/components';
}
