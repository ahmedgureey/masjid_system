import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_semantic_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Global theme configuration built from the Masjid Design System.
///
/// Only the light theme exists in the MVP; dark tokens are documented in
/// `docs/design/color-palette.md` §5 and will be added in v1.1.
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

  static final ThemeData light = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    const scheme = _lightColorScheme;
    final text = AppTypography.textTheme;

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
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: AppTypography.latinFontFamily,
      fontFamilyFallback: AppTypography.fontFallback,
      textTheme: text,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: const [AppSemanticColors.light],

      // App bars blend with the page background (design: neutral-25).
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleMedium,
      ),

      // Primary button = FilledButton (green, white label 6.51:1).
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.neutral100,
          disabledForegroundColor: AppColors.neutral500,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(48, AppSizes.minTouchTarget),
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 3,
      ),

      // Labels sit above fields in the design; the field itself is outlined.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: 14,
        ),
        hintStyle: text.bodyLarge?.copyWith(color: AppColors.neutral500),
        helperStyle: text.bodySmall?.copyWith(color: AppColors.neutral500),
        errorStyle: text.bodySmall?.copyWith(color: AppColors.error),
        border: inputBorder(AppColors.neutral400, 1),
        enabledBorder: inputBorder(AppColors.neutral400, 1),
        focusedBorder: inputBorder(AppColors.primary, 2),
        errorBorder: inputBorder(AppColors.error, 2),
        focusedErrorBorder: inputBorder(AppColors.error, 2),
        disabledBorder: inputBorder(AppColors.neutral200, 1),
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.neutral200),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.green50,
        labelStyle: text.labelMedium,
        side: const BorderSide(color: AppColors.neutral200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      // Active tab uses green (gold on white fails contrast).
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.bottomNavHeight,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.green50,
        elevation: 2,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.neutral500,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? text.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                )
              : text.labelMedium?.copyWith(color: AppColors.neutral500),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.neutral200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral800,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.white),
        actionTextColor: AppColors.gold300,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.neutral100,
        thickness: 1,
        space: 1,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: AppColors.neutral600,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: AppColors.neutral500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.green50,
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.green100,
        selectionHandleColor: AppColors.primary,
      ),
    );
  }
}
