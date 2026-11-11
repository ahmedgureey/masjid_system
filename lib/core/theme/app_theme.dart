import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_semantic_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Global theme configuration built from the Masjid Design System.
///
/// Light theme = the original MVP theme (unchanged values). Dark theme uses
/// the dark tokens of `docs/design/color-palette.md` §5.
abstract final class AppTheme {
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.green50,
    onPrimaryContainer: AppColors.green800,
    secondary: AppColors.gold,
    onSecondary: AppColors.darkText,
    secondaryContainer: AppColors.gold50,
    onSecondaryContainer: AppColors.gold800,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.error,
    surface: AppColors.white,
    onSurface: AppColors.darkText,
    onSurfaceVariant: AppColors.neutral500,
    surfaceContainerLowest: AppColors.white,
    surfaceContainerLow: AppColors.neutral25,
    surfaceContainer: AppColors.neutral50,
    surfaceContainerHigh: AppColors.neutral100,
    surfaceContainerHighest: AppColors.neutral100,
    outline: AppColors.neutral400,
    outlineVariant: AppColors.neutral200,
    shadow: AppColors.neutral900,
    scrim: AppColors.neutral900,
    inverseSurface: AppColors.neutral800,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.green200,
    surfaceTint: Colors.transparent,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkBg,
    primaryContainer: AppColors.darkSurfaceRaised,
    onPrimaryContainer: AppColors.darkPrimary,
    secondary: AppColors.darkGold,
    onSecondary: AppColors.darkBg,
    secondaryContainer: AppColors.darkGoldContainer,
    onSecondaryContainer: AppColors.darkGold,
    error: AppColors.darkError,
    onError: AppColors.darkBg,
    errorContainer: Color(0xFF3A1D1B),
    onErrorContainer: AppColors.darkError,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkModeText,
    onSurfaceVariant: AppColors.darkTextMuted,
    surfaceContainerLowest: AppColors.darkBg,
    surfaceContainerLow: AppColors.darkSurface,
    surfaceContainer: AppColors.darkSurface,
    surfaceContainerHigh: AppColors.darkSurfaceRaised,
    surfaceContainerHighest: AppColors.darkSurfaceRaised,
    outline: AppColors.darkBorder,
    outlineVariant: AppColors.darkDivider,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.darkModeText,
    onInverseSurface: AppColors.darkBg,
    inversePrimary: AppColors.primary,
    surfaceTint: Colors.transparent,
  );

  /// Light theme for English and Somali (Inter).
  static final ThemeData light = _build(arabic: false, dark: false);

  /// Light theme for Arabic (Noto Sans Arabic, larger sizes, taller lines).
  static final ThemeData lightArabic = _build(arabic: true, dark: false);

  static final ThemeData dark = _build(arabic: false, dark: true);
  static final ThemeData darkArabic = _build(arabic: true, dark: true);

  /// Light theme matching the app language.
  static ThemeData forLocale(Locale locale) =>
      locale.languageCode == 'ar' ? lightArabic : light;

  /// Dark theme matching the app language.
  static ThemeData darkForLocale(Locale locale) =>
      locale.languageCode == 'ar' ? darkArabic : dark;

  static ThemeData _build({required bool arabic, required bool dark}) {
    final scheme = dark ? _darkColorScheme : _lightColorScheme;
    final baseText = arabic
        ? AppTypography.arabicTextTheme
        : AppTypography.textTheme;
    // Typography hard-codes the light text colour; recolour for dark.
    final text = dark
        ? baseText.apply(
            bodyColor: AppColors.darkModeText,
            displayColor: AppColors.darkModeText,
          )
        : baseText;

    // Colours that differ between light (original values) and dark.
    final pageBg = dark ? AppColors.darkBg : AppColors.lightBackground;
    final surface = dark ? AppColors.darkSurface : AppColors.white;
    final onSurface = dark ? AppColors.darkModeText : AppColors.darkText;
    final muted = dark ? AppColors.darkTextMuted : AppColors.neutral500;
    final primary = dark ? AppColors.darkPrimary : AppColors.primary;
    final onPrimary = dark ? AppColors.darkBg : AppColors.white;
    final tinted = dark ? AppColors.darkSurfaceRaised : AppColors.green50;
    final border = dark ? AppColors.darkBorder : AppColors.neutral400;
    final subtleBorder = dark ? AppColors.darkDivider : AppColors.neutral200;
    final divider = dark ? AppColors.darkDivider : AppColors.neutral100;
    final disabledBg = dark
        ? AppColors.darkSurfaceRaised
        : AppColors.neutral100;
    final listIcon = dark ? AppColors.darkTextMuted : AppColors.neutral600;

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    const buttonMinSize = Size(64, AppSizes.buttonHeightMedium);
    const buttonPadding = EdgeInsets.symmetric(horizontal: AppSpacing.space5);

    OutlineInputBorder inputBorder(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: pageBg,
      fontFamily: arabic
          ? AppTypography.arabicFontFamily
          : AppTypography.latinFontFamily,
      fontFamilyFallback: arabic
          ? AppTypography.arabicFontFallback
          : AppTypography.fontFallback,
      textTheme: text,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [dark ? AppSemanticColors.dark : AppSemanticColors.light],

      // App bars blend with the page background (design: neutral-25).
      appBarTheme: AppBarTheme(
        backgroundColor: pageBg,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleMedium,
      ),

      // Primary button = FilledButton (green, white label 6.51:1).
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: muted,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          side: BorderSide(color: primary, width: 1.5),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(48, AppSizes.minTouchTarget),
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 3,
      ),

      // Labels sit above fields in the design; the field itself is outlined.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: 14,
        ),
        hintStyle: text.bodyLarge?.copyWith(color: muted),
        helperStyle: text.bodySmall?.copyWith(color: muted),
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        border: inputBorder(border, 1),
        enabledBorder: inputBorder(border, 1),
        focusedBorder: inputBorder(primary, 2),
        errorBorder: inputBorder(scheme.error, 2),
        focusedErrorBorder: inputBorder(scheme.error, 2),
        disabledBorder: inputBorder(subtleBorder, 1),
      ),

      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: subtleBorder),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: tinted,
        labelStyle: text.labelMedium,
        side: BorderSide(color: subtleBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      // Selected segment: green-50 background + green text (design §2).
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(text.labelMedium),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? tinted : surface,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? primary : onSurface,
          ),
          side: WidgetStatePropertyAll(BorderSide(color: border)),
        ),
      ),

      // Active tab uses green (gold on white fails contrast).
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.bottomNavHeight,
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: tinted,
        elevation: 2,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected) ? primary : muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? text.labelMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                )
              : text.labelMedium?.copyWith(color: muted),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: subtleBorder,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: dark
            ? AppColors.darkSurfaceRaised
            : AppColors.neutral800,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: dark ? AppColors.darkModeText : AppColors.white,
        ),
        actionTextColor: AppColors.gold300,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),

      listTileTheme: ListTileThemeData(
        iconColor: listIcon,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodyMedium?.copyWith(color: muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: tinted,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: dark ? AppColors.green700 : AppColors.green100,
        selectionHandleColor: primary,
      ),
    );
  }
}
