import 'package:material_ui/material_ui.dart';

/// Color tokens of the Masjid Design System.
///
/// Source of truth: `docs/design/color-palette.md`.
/// Screens should read colors from `Theme.of(context).colorScheme` or
/// [AppSemanticColors] where possible; these raw tokens are used to build the
/// theme and for the rare cases that need a specific tonal step.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Official brand colors
  // ---------------------------------------------------------------------------

  /// Primary Green — app bars, primary buttons, active states.
  static const Color primary = green600;

  /// White — surfaces (cards, sheets, inputs).
  static const Color white = Color(0xFFFFFFFF);

  /// Gold — accent only. Never use as text/icon color on white (2.10:1).
  static const Color gold = gold400;

  /// Dark Text — primary text and icons on light surfaces.
  static const Color darkText = neutral800;

  /// Light Background — page background behind cards.
  static const Color lightBackground = neutral25;

  // ---------------------------------------------------------------------------
  // Green scale (primary)
  // ---------------------------------------------------------------------------
  static const Color green50 = Color(0xFFE8F3EC);
  static const Color green100 = Color(0xFFC9E4D3);
  static const Color green200 = Color(0xFF9FCFB2);
  static const Color green300 = Color(0xFF6DB58C);
  static const Color green400 = Color(0xFF3F9A6A);
  static const Color green500 = Color(0xFF23804F);
  static const Color green600 = Color(0xFF176B45);
  static const Color green700 = Color(0xFF125A39);
  static const Color green800 = Color(0xFF0F4D31);
  static const Color green900 = Color(0xFF0A3622);

  // ---------------------------------------------------------------------------
  // Gold scale (accent)
  // ---------------------------------------------------------------------------
  static const Color gold50 = Color(0xFFFBF5E1);
  static const Color gold100 = Color(0xFFF5E8B8);
  static const Color gold200 = Color(0xFFEDD88A);
  static const Color gold300 = Color(0xFFE2C25B);
  static const Color gold400 = Color(0xFFD4AF37);
  static const Color gold500 = Color(0xFFB8952A);
  static const Color gold600 = Color(0xFF9A7B20);
  static const Color gold700 = Color(0xFF8A6D1A);
  static const Color gold800 = Color(0xFF7A5F12);
  static const Color gold900 = Color(0xFF5C470C);

  // ---------------------------------------------------------------------------
  // Neutrals (green-tinted greys)
  // ---------------------------------------------------------------------------
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral25 = Color(0xFFF7F9F7);
  static const Color neutral50 = Color(0xFFF1F4F2);
  static const Color neutral100 = Color(0xFFE6EBE8);
  static const Color neutral200 = Color(0xFFD9E1DC);
  static const Color neutral400 = Color(0xFF7B8B82);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);

  // ---------------------------------------------------------------------------
  // Semantic (status) colors — used only for status, never for decoration.
  // ---------------------------------------------------------------------------
  static const Color success = green600;
  static const Color successContainer = green50;
  static const Color error = Color(0xFFB42318);
  static const Color errorContainer = Color(0xFFFEF3F2);
  static const Color warning = Color(0xFFB54708);
  static const Color warningContainer = Color(0xFFFFFAEB);
  static const Color info = Color(0xFF1D5FA8);
  static const Color infoContainer = Color(0xFFEFF6FF);

  // ---------------------------------------------------------------------------
  // Dark mode palette (docs/design/color-palette.md §5). The primary green
  // is lightened because #176B45 is too dark on a near-black surface.
  // ---------------------------------------------------------------------------
  static const Color darkBg = Color(0xFF0F1A14);
  static const Color darkSurface = Color(0xFF16241C);
  static const Color darkSurfaceRaised = Color(0xFF1E3026);
  static const Color darkModeText = Color(0xFFE8EEEA);
  static const Color darkTextMuted = Color(0xFF9CA3AF);
  static const Color darkPrimary = Color(0xFF4CC38A);
  static const Color darkGold = Color(0xFFE2C25B);
  static const Color darkBorder = Color(0xFF7B8B82);
  static const Color darkDivider = Color(0xFF2A3B31);
  static const Color darkGoldContainer = Color(0xFF2E2A17);
  static const Color darkError = Color(0xFFF97066);
  static const Color darkWarning = Color(0xFFF5B544);
  static const Color darkInfo = Color(0xFF7CB4F0);
}
