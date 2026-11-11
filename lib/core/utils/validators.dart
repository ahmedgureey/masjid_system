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

  /// Required, trimmed text of at least [min] characters, with a custom
  /// [message] (e.g. "Enter your full name").
  static FormFieldValidator<String> minChars(
    AppLocalizations l10n,
    int min,
    String message,
  ) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return l10n.validationRequired;
      return text.length < min ? message : null;
    };
  }

  /// Value must equal [other] (read at validation time), e.g. confirm
  /// password.
  static FormFieldValidator<String> match(
    AppLocalizations l10n,
    String Function() other,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return l10n.validationRequired;
      return value == other() ? null : l10n.validationPasswordMismatch;
    };
  }

  /// Website address: optional `http(s)://`, a domain with a dot, optional
  /// path. Examples: `www.example.com`, `https://example.so/about`.
  static final RegExp _urlPattern = RegExp(
    r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/\S*)?$',
  );

  static FormFieldValidator<String> url(AppLocalizations l10n) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      return _urlPattern.hasMatch(value.trim()) ? null : l10n.validationWebsite;
    };
  }

  /// Whole year between [min] and [max] (inclusive).
  static FormFieldValidator<String> year(
    AppLocalizations l10n, {
    required int min,
    required int max,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      final year = int.tryParse(value.trim());
      return (year == null || year < min || year > max)
          ? l10n.validationYear(min, max)
          : null;
    };
  }

  static FormFieldValidator<String> latitude(AppLocalizations l10n) =>
      _range(l10n, -90, 90, l10n.validationLatitude);

  static FormFieldValidator<String> longitude(AppLocalizations l10n) =>
      _range(l10n, -180, 180, l10n.validationLongitude);

  static FormFieldValidator<String> _range(
    AppLocalizations l10n,
    double min,
    double max,
    String message,
  ) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      final number = double.tryParse(value.trim());
      return (number == null || number < min || number > max) ? message : null;
    };
  }

  /// Applies [validator] only when the field is not empty (optional fields).
  static FormFieldValidator<String> optional(
    FormFieldValidator<String> validator,
  ) {
    return (value) =>
        (value == null || value.trim().isEmpty) ? null : validator(value);
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
