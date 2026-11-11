import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

enum AppTopBarVariant {
  /// Blends with the page background (default).
  standard,

  /// Over gradients/photos: transparent with white icons.
  transparent,

  /// Green bar with white title — optional staff-area cue (DD-04).
  primary,
}

/// App bar wrapper with the design-system variants.
/// Back button is added automatically when the route can pop, and mirrors in
/// RTL. Title alignment follows the platform (start on Android, centered on
/// iOS).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.variant = AppTopBarVariant.standard,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final AppTopBarVariant variant;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final (background, foreground, overlay) = switch (variant) {
      AppTopBarVariant.standard => (
        AppColors.lightBackground,
        AppColors.darkText,
        SystemUiOverlayStyle.dark,
      ),
      AppTopBarVariant.transparent => (
        Colors.transparent,
        AppColors.white,
        SystemUiOverlayStyle.light,
      ),
      AppTopBarVariant.primary => (
        AppColors.primary,
        AppColors.white,
        SystemUiOverlayStyle.light,
      ),
    };

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: background,
      foregroundColor: foreground,
      systemOverlayStyle: overlay,
      elevation: 0,
      scrolledUnderElevation: variant == AppTopBarVariant.transparent ? 0 : 2,
      bottom: bottom,
      titleTextStyle: Theme.of(context).textTheme.titleMedium
          ?.copyWith(color: foreground),
    );
  }
}
