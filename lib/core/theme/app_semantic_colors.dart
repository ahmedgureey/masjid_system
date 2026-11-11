import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Design tokens that Material's [ColorScheme] has no slot for: gold accent
/// variants, status colors, brand gradients and the surface / text colors
/// used by custom widgets.
///
/// Read with `Theme.of(context).extension<AppSemanticColors>()!` or the
/// [AppSemanticColorsX.semanticColors] shortcut. [light] keeps the original
/// light-mode values exactly; [dark] follows docs/design/color-palette.md §5.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.gold,
    required this.onGold,
    required this.goldText,
    required this.goldOnDark,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.heroGradient,
    required this.splashGradient,
    required this.cardBackground,
    required this.cardBorder,
    required this.tintedBackground,
    required this.goldBackground,
    required this.brandText,
    required this.mutedText,
    required this.pageBackground,
  });

  /// Gold fill (badges, progress, next-prayer marker).
  final Color gold;

  /// Text/icons on a gold fill — always dark (6.98:1).
  final Color onGold;

  /// Gold-tinted text on the page / card background.
  final Color goldText;

  /// Gold text on dark green surfaces (gold-300, 5.69:1 on green-800).
  final Color goldOnDark;

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;

  /// Hero cards (next prayer, finance balance).
  final LinearGradient heroGradient;

  /// Splash and onboarding backgrounds.
  final LinearGradient splashGradient;

  /// Standard / outlined card fill and its border.
  final Color cardBackground;
  final Color cardBorder;

  /// Light-green fill (tinted cards, icon circles, info pills).
  final Color tintedBackground;

  /// Light-gold fill (gold cards).
  final Color goldBackground;

  /// Brand-green text (titles on cards, mosque name).
  final Color brandText;

  /// Secondary / muted text.
  final Color mutedText;

  /// Plain white page behind the home dashboard.
  final Color pageBackground;

  static const AppSemanticColors light = AppSemanticColors(
    gold: AppColors.gold400,
    onGold: AppColors.darkText,
    goldText: AppColors.gold800,
    goldOnDark: AppColors.gold300,
    success: AppColors.success,
    successContainer: AppColors.successContainer,
    warning: AppColors.warning,
    warningContainer: AppColors.warningContainer,
    info: AppColors.info,
    infoContainer: AppColors.infoContainer,
    heroGradient: LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: [AppColors.green700, AppColors.green800],
    ),
    splashGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.green800, AppColors.green900],
    ),
    cardBackground: AppColors.white,
    cardBorder: AppColors.neutral200,
    tintedBackground: AppColors.green50,
    goldBackground: AppColors.gold50,
    brandText: AppColors.green800,
    mutedText: AppColors.neutral500,
    pageBackground: AppColors.white,
  );

  static const AppSemanticColors dark = AppSemanticColors(
    gold: AppColors.darkGold,
    onGold: AppColors.darkBg,
    goldText: AppColors.darkGold,
    goldOnDark: AppColors.gold300,
    success: AppColors.darkPrimary,
    successContainer: AppColors.darkSurfaceRaised,
    warning: AppColors.darkWarning,
    warningContainer: AppColors.darkGoldContainer,
    info: AppColors.darkInfo,
    infoContainer: AppColors.darkSurfaceRaised,
    heroGradient: LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: [AppColors.green700, AppColors.green800],
    ),
    splashGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.green800, AppColors.green900],
    ),
    cardBackground: AppColors.darkSurface,
    cardBorder: AppColors.darkDivider,
    tintedBackground: AppColors.darkSurfaceRaised,
    goldBackground: AppColors.darkGoldContainer,
    brandText: AppColors.darkPrimary,
    mutedText: AppColors.darkTextMuted,
    pageBackground: AppColors.darkBg,
  );

  @override
  AppSemanticColors copyWith({
    Color? gold,
    Color? onGold,
    Color? goldText,
    Color? goldOnDark,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    LinearGradient? heroGradient,
    LinearGradient? splashGradient,
    Color? cardBackground,
    Color? cardBorder,
    Color? tintedBackground,
    Color? goldBackground,
    Color? brandText,
    Color? mutedText,
    Color? pageBackground,
  }) {
    return AppSemanticColors(
      gold: gold ?? this.gold,
      onGold: onGold ?? this.onGold,
      goldText: goldText ?? this.goldText,
      goldOnDark: goldOnDark ?? this.goldOnDark,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      heroGradient: heroGradient ?? this.heroGradient,
      splashGradient: splashGradient ?? this.splashGradient,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      tintedBackground: tintedBackground ?? this.tintedBackground,
      goldBackground: goldBackground ?? this.goldBackground,
      brandText: brandText ?? this.brandText,
      mutedText: mutedText ?? this.mutedText,
      pageBackground: pageBackground ?? this.pageBackground,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppSemanticColors(
      gold: c(gold, other.gold),
      onGold: c(onGold, other.onGold),
      goldText: c(goldText, other.goldText),
      goldOnDark: c(goldOnDark, other.goldOnDark),
      success: c(success, other.success),
      successContainer: c(successContainer, other.successContainer),
      warning: c(warning, other.warning),
      warningContainer: c(warningContainer, other.warningContainer),
      info: c(info, other.info),
      infoContainer: c(infoContainer, other.infoContainer),
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      splashGradient: LinearGradient.lerp(
        splashGradient,
        other.splashGradient,
        t,
      )!,
      cardBackground: c(cardBackground, other.cardBackground),
      cardBorder: c(cardBorder, other.cardBorder),
      tintedBackground: c(tintedBackground, other.tintedBackground),
      goldBackground: c(goldBackground, other.goldBackground),
      brandText: c(brandText, other.brandText),
      mutedText: c(mutedText, other.mutedText),
      pageBackground: c(pageBackground, other.pageBackground),
    );
  }
}

/// Shortcut: `context.semanticColors.gold`.
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
