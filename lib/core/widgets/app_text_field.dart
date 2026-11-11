import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../localization/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Text input with the label **above** the field (always visible — better
/// for long Somali labels and older users).
/// Spec: `docs/design/reusable-components.md` §2.
///
/// Set [isPassword] for an obscured field with a show/hide toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.prefixIcon,
    this.prefixText,
    this.suffix,
    this.focusNode,
    this.textDirection,
    this.isPassword = false,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
  });

  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffix;
  final FocusNode? focusNode;

  /// Force a direction, e.g. [TextDirection.ltr] for phone numbers and
  /// amounts inside Arabic layouts.
  final TextDirection? textDirection;
  final bool isPassword;

  /// Shows a red `*` after the label.
  final bool isRequired;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final VoidCallback? onTap;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final Widget? suffixIcon = widget.isPassword
        ? IconButton(
            tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
            icon: Icon(
              _obscured
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(() => _obscured = !_obscured),
          )
        : widget.suffix;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text.rich(
            TextSpan(
              text: widget.label,
              children: [
                if (widget.isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error),
                  ),
              ],
            ),
            style: textTheme.bodyMedium?.copyWith(
              color: widget.enabled ? AppColors.darkText : AppColors.neutral500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          focusNode: widget.focusNode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          textDirection: widget.textDirection,
          obscureText: _obscured,
          enableSuggestions: !widget.isPassword,
          autocorrect: !widget.isPassword,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          style: textTheme.bodyLarge,
          // Validate on blur/submit rather than on every keystroke.
          autovalidateMode: AutovalidateMode.onUnfocus,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            helperMaxLines: 2,
            errorMaxLines: 3,
            // prefixText is rendered as an always-visible prefix (Material's
            // own prefixText hides while the field is empty), e.g. "$".
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.neutral500)
                : (widget.prefixText != null
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: AppSpacing.space4,
                            end: AppSpacing.space2,
                          ),
                          child: Text(
                            widget.prefixText!,
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.neutral600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null),
            prefixIconConstraints:
                widget.prefixText != null && widget.prefixIcon == null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
