import '../models/money.dart';

enum AmountError { required, invalid, notPositive, tooManyDecimals, tooLarge }

final RegExp _thousands = RegExp(r'^\d{1,3}(,\d{3})+(\.\d*)?$');

/// Normalises typed amount text: removes spaces and removes commas ONLY
/// when they are real thousands separators ("1,250.50" → "1250.50").
/// Returns null when a comma is used any other way ("1,5", "12,50") — it
/// may be a decimal comma, and silently dropping it would make the amount
/// 10× or 100× larger.
String? normalizeAmountText(String text) {
  final t = text.trim().replaceAll(' ', '');
  if (!t.contains(',')) return t;
  final unsigned = t.startsWith('-') ? t.substring(1) : t;
  if (!_thousands.hasMatch(unsigned)) return null;
  return t.replaceAll(',', '');
}

/// Pure amount parsing / validation (unit tested).
abstract final class DonationValidation {
  /// Upper limit for a single entry (guards against typos).
  static const int maxMajor = 1000000;

  static final RegExp _pattern = RegExp(r'^\d+(\.\d+)?$');

  /// Parses user text ("20", "20.5", "1,250.75") into [Money]; null when
  /// invalid (including a comma that is not a thousands separator).
  static Money? parse(String text, Currency currency) {
    final cleaned = normalizeAmountText(text);
    if (cleaned == null || !_pattern.hasMatch(cleaned)) return null;
    final parts = cleaned.split('.');
    final fraction = parts.length > 1 ? parts[1] : '';
    if (fraction.length > currency.decimals) return null;
    final major = int.tryParse(parts[0]);
    if (major == null) return null;
    final minor =
        major * currency.minorPerMajor +
        (fraction.isEmpty
            ? 0
            : int.parse(fraction.padRight(currency.decimals, '0')));
    return Money(minor, currency);
  }

  static AmountError? amount(String? text, Currency currency) {
    final value = (text ?? '').trim();
    if (value.isEmpty) return AmountError.required;
    if (value.startsWith('-')) return AmountError.notPositive;
    final cleaned = normalizeAmountText(value);
    if (cleaned == null || !_pattern.hasMatch(cleaned)) {
      return AmountError.invalid;
    }
    final fraction = cleaned.contains('.') ? cleaned.split('.')[1] : '';
    if (fraction.length > currency.decimals) {
      return AmountError.tooManyDecimals;
    }
    final money = parse(value, currency);
    if (money == null) return AmountError.invalid;
    if (money.minor <= 0) return AmountError.notPositive;
    if (money.minor > maxMajor * currency.minorPerMajor) {
      return AmountError.tooLarge;
    }
    return null;
  }
}
