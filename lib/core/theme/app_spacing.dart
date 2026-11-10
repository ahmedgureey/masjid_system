/// Spacing tokens (4 dp base, 8 dp grid). See `docs/design/design-system.md` §3.
abstract final class AppSpacing {
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;

  /// Default screen side margin on compact phones and default card padding.
  static const double space4 = 16;

  /// Screen side margin on phones ≥ 400 dp wide.
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
}

/// Corner radius tokens. See `docs/design/design-system.md` §4.
abstract final class AppRadius {
  /// Chips, badges, input fields.
  static const double sm = 8;

  /// Buttons, list cards, snackbars.
  static const double md = 12;

  /// Main cards, dialogs.
  static const double lg = 16;

  /// Hero cards, bottom sheets (top corners).
  static const double xl = 24;

  /// Pills, avatars.
  static const double full = 999;
}

/// Minimum interactive sizes (accessibility).
abstract final class AppSizes {
  static const double minTouchTarget = 48;
  static const double buttonHeightLarge = 52;
  static const double buttonHeightMedium = 44;
  static const double inputHeight = 52;
  static const double bottomNavHeight = 64;
}
