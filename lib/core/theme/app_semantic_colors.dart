import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Design tokens that Material's [ColorScheme] has no slot for: gold accent
/// variants, status colors and brand gradients.
///
/// Read with `Theme.of(context).extension<AppSemanticColors>()!` or the
/// [AppSemanticColorsX.semanticColors] shortcut. A dark variant is added when
/// dark mode ships (v1.1).
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
  });

  /// Gold fill (badges, progress, next-prayer marker).
  final Color gold;

  /// Text/icons on a gold fill — always dark (6.98:1).
  final Color onGold;

  /// Gold-tinted text on white (gold-800, 6.05:1).
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
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      gold: Color.lerp(gold, other.gold, t)!,
      onGold: Color.lerp(onGold, other.onGold, t)!,
      goldText: Color.lerp(goldText, other.goldText, t)!,
      goldOnDark: Color.lerp(goldOnDark, other.goldOnDark, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      splashGradient: LinearGradient.lerp(
        splashGradient,
        other.splashGradient,
        t,
      )!,
    );
  }
}

/// Shortcut: `context.semanticColors.gold`.
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
