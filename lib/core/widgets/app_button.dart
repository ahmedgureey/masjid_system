import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum AppButtonVariant {
  /// Main action of a screen (green).
  primary,

  /// Second action (green outline).
  secondary,

  /// Special emphasis, max one per screen (gold with dark text).
  accent,

  /// Low emphasis (green text).
  text,

  /// Void, delete, reject (red).
  destructive,
}

enum AppButtonSize { small, medium, large }

/// The app's button. Spec: `docs/design/reusable-components.md` §1.
///
/// - `onPressed: null` → disabled.
/// - `isLoading: true` → spinner, label kept, taps ignored.
/// - `expand: true` → full width (forms, auth screens).
/// Labels wrap to multiple lines instead of being clipped (long Somali text).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.accent({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AppButtonVariant.accent;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AppButtonVariant.text;

  const AppButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AppButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  double get _height => switch (size) {
    AppButtonSize.small => 36,
    AppButtonSize.medium => AppSizes.buttonHeightMedium,
    AppButtonSize.large => AppSizes.buttonHeightLarge,
  };

  double get _horizontalPadding => switch (size) {
    AppButtonSize.small => AppSpacing.space3,
    AppButtonSize.medium => AppSpacing.space5,
    AppButtonSize.large => AppSpacing.space6,
  };

  Color get _foreground => switch (variant) {
    AppButtonVariant.primary || AppButtonVariant.destructive => AppColors.white,
    AppButtonVariant.accent => AppColors.darkText,
    AppButtonVariant.secondary || AppButtonVariant.text => AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = size == AppButtonSize.small
        ? textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)
        : textTheme.labelLarge;

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, _height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: AppSpacing.space2,
        ),
      ),
      textStyle: WidgetStatePropertyAll(textStyle),
    );

    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
      spinnerColor: _foreground,
      iconSize: size == AppButtonSize.small ? 18 : 20,
    );

    // While loading the button keeps its colors but ignores taps.
    final effectiveOnPressed = onPressed == null
        ? null
        : (isLoading ? () {} : onPressed);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.accent => FilledButton(
        onPressed: effectiveOnPressed,
        style: style.merge(
          FilledButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.darkText,
            overlayColor: AppColors.gold500,
          ),
        ),
        child: child,
      ),
      AppButtonVariant.destructive => FilledButton(
        onPressed: effectiveOnPressed,
        style: style.merge(
          FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
          ),
        ),
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: isLoading ? label : null,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.spinnerColor,
    required this.iconSize,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color spinnerColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final Widget? leading = isLoading
        ? SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: spinnerColor,
            ),
          )
        : (icon != null ? Icon(icon, size: iconSize) : null);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading,
          const SizedBox(width: AppSpacing.space2),
        ],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
  }
}
