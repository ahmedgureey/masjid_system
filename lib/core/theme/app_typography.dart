import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Typography of the Masjid Design System.
///
/// Source of truth: `docs/design/typography.md`.
/// - Inter: UI font for English and Somali.
/// - Noto Sans Arabic: UI font for Arabic, and fallback for Arabic characters
///   inside Latin text.
/// - Amiri: Bismillah, Qur'anic quotes and decorative Arabic only.
abstract final class AppTypography {
  static const String latinFontFamily = 'Inter';
  static const String arabicFontFamily = 'NotoSansArabic';
  static const String quranicFontFamily = 'Amiri';

  static const List<String> fontFallback = [arabicFontFamily];
  static const List<String> arabicFontFallback = [latinFontFamily];

  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  /// Builds a [TextStyle] from the design tokens: size and line height in
  /// logical pixels (sp/pt), as written in the design docs.
  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight, {
    double letterSpacing = 0,
    bool arabic = false,
  }) {
    return TextStyle(
      fontFamily: arabic ? arabicFontFamily : latinFontFamily,
      fontFamilyFallback: arabic ? arabicFontFallback : fontFallback,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      // Letter spacing breaks Arabic letter joining — always 0 in Arabic.
      letterSpacing: arabic ? 0 : letterSpacing,
      color: AppColors.darkText,
    );
  }

  /// Latin (English / Somali) text theme: Material 3 roles mapped to the
  /// design-system type scale.
  static final TextTheme textTheme = TextTheme(
    // display 32/40 Bold
    displaySmall: _style(32, 40, FontWeight.w700, letterSpacing: -0.5),
    // headline 24/32 Bold — screen titles
    headlineSmall: _style(24, 32, FontWeight.w700, letterSpacing: -0.25),
    // title-lg 20/28 SemiBold — section headers, dialog titles
    titleLarge: _style(20, 28, FontWeight.w600),
    // title-md 18/26 SemiBold — card titles, app bar title
    titleMedium: _style(18, 26, FontWeight.w600),
    // title-sm 16/24 SemiBold — list item titles
    titleSmall: _style(16, 24, FontWeight.w600),
    // body-lg 16/24 Regular
    bodyLarge: _style(16, 24, FontWeight.w400),
    // body-md 14/20 Regular
    bodyMedium: _style(14, 20, FontWeight.w400, letterSpacing: 0.1),
    // caption 12/16 Medium
    bodySmall: _style(12, 16, FontWeight.w500, letterSpacing: 0.2),
    // label-lg 16/24 SemiBold — buttons
    labelLarge: _style(16, 24, FontWeight.w600, letterSpacing: 0.1),
    // label-md 14/20 Medium — chips, tabs, nav labels
    labelMedium: _style(14, 20, FontWeight.w500, letterSpacing: 0.1),
    // overline 11/16 SemiBold
    labelSmall: _style(11, 16, FontWeight.w600, letterSpacing: 0.8),
  );

  /// Arabic text theme (Noto Sans Arabic): +2 sp and ~1.6× line height so
  /// diacritics are not clipped. See `docs/design/typography.md` §3.
  static final TextTheme arabicTextTheme = TextTheme(
    displaySmall: _style(34, 54, FontWeight.w700, arabic: true),
    headlineSmall: _style(26, 42, FontWeight.w700, arabic: true),
    titleLarge: _style(22, 36, FontWeight.w600, arabic: true),
    titleMedium: _style(20, 32, FontWeight.w600, arabic: true),
    titleSmall: _style(18, 28, FontWeight.w600, arabic: true),
    bodyLarge: _style(18, 29, FontWeight.w400, arabic: true),
    bodyMedium: _style(16, 26, FontWeight.w400, arabic: true),
    bodySmall: _style(14, 22, FontWeight.w500, arabic: true),
    labelLarge: _style(18, 28, FontWeight.w600, arabic: true),
    labelMedium: _style(16, 24, FontWeight.w500, arabic: true),
    // No uppercase "overline" in Arabic — caption weight 600 instead.
    labelSmall: _style(14, 22, FontWeight.w600, arabic: true),
  );

  /// Next-prayer countdown: 40/48 SemiBold, tabular figures.
  static final TextStyle countdown = _style(
    40,
    48,
    FontWeight.w600,
    letterSpacing: -0.5,
  ).copyWith(fontFeatures: tabularFigures);

  /// Money amounts, times and statistics (tabular figures).
  static final TextStyle figure = _style(
    16,
    24,
    FontWeight.w600,
  ).copyWith(fontFeatures: tabularFigures);

  /// Decorative Arabic text such as the Bismillah (Amiri). Always RTL.
  static const TextStyle quranic = TextStyle(
    fontFamily: quranicFontFamily,
    fontSize: 22,
    height: 2.0,
    color: AppColors.darkText,
  );

  static const String quranVerseFontFamily = 'AmiriQuran';

  /// Qur'anic verses (Amiri Quran): full harakāt and Qur'anic marks, tall
  /// line height so diacritics are never clipped. Always RTL.
  static const TextStyle quranVerse = TextStyle(
    fontFamily: quranVerseFontFamily,
    fontFamilyFallback: [quranicFontFamily, arabicFontFamily],
    fontSize: 26,
    height: 2.0,
    color: AppColors.darkText,
  );
}
