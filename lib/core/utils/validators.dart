import 'package:material_ui/material_ui.dart';

import '../localization/l10n.dart';

/// Reusable form validators with translated messages.
///
/// Usage: `validator: AppValidators.email(context.l10n)`.
/// Combine with [AppValidators.compose].
abstract final class AppValidators {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  /// Digits with optional leading +, spaces or dashes; 7–15 digits.
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9][0-9\s-]{5,18}[0-9]$');

  static FormFieldValidator<String> required(AppLocalizations l10n) {
    return (value) => (value == null || value.trim().isEmpty)
        ? l10n.validationRequired
        : null;
  }

  static FormFieldValidator<String> email(AppLocalizations l10n) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      return _emailPattern.hasMatch(value.trim()) ? null : l10n.validationEmail;
    };
  }

  static FormFieldValidator<String> phone(AppLocalizations l10n) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      final digits = value.replaceAll(RegExp(r'\D'), '');
      final valid =
          _phonePattern.hasMatch(value.trim()) &&
          digits.length >= 7 &&
          digits.length <= 15;
      return valid ? null : l10n.validationPhone;
    };
  }

  static FormFieldValidator<String> minLength(AppLocalizations l10n, int min) {
    return (value) {
      if (value == null || value.isEmpty) return l10n.validationRequired;
      return value.length < min ? l10n.validationPasswordLength(min) : null;
    };
  }

  /// Runs validators in order and returns the first error.
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
