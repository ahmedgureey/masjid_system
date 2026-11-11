import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Supported currencies (ISO 4217). Amounts are never converted between
/// currencies: totals are always kept per currency.
enum Currency {
  usd('USD', r'$'),
  sos('SOS', 'SOS ');

  const Currency(this.code, this.symbol);

  final String code;
  final String symbol;

  /// Both currencies have two minor-unit digits (ISO 4217).
  int get decimals => 2;
  int get minorPerMajor => 100;
}

/// An amount of money in integer minor units (cents) — never a `double`,
/// so sums are exact.
@immutable
class Money implements Comparable<Money> {
  const Money(this.minor, this.currency);

  const Money.zero(this.currency) : minor = 0;

  /// [major] whole units, e.g. `Money.major(20, Currency.usd)` = $20.00.
  const Money.major(int major, this.currency) : minor = major * 100;

  final int minor;
  final Currency currency;

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;

  Money operator +(Money other) {
    _checkSameCurrency(other);
    return Money(minor + other.minor, currency);
  }

  Money operator -(Money other) {
    _checkSameCurrency(other);
    return Money(minor - other.minor, currency);
  }

  void _checkSameCurrency(Money other) {
    if (other.currency != currency) {
      throw ArgumentError(
        'Cannot mix ${currency.code} and '
        '${other.currency.code} without a conversion.',
      );
    }
  }

  /// "$1,250.00" / "SOS 50,000.00" / "-$12.50". Western digits in every
  /// language (design decision DD-03).
  String format() {
    final formatter = NumberFormat.currency(
      locale: 'en',
      symbol: currency.symbol,
      decimalDigits: currency.decimals,
    );
    final text = formatter.format(minor.abs() / currency.minorPerMajor);
    return minor < 0 ? '-$text' : text;
  }

  @override
  int compareTo(Money other) {
    _checkSameCurrency(other);
    return minor.compareTo(other.minor);
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => format();
}

/// [money] formatted and wrapped in a left-to-right isolate (LRI … PDI), so
/// it keeps "$50.00" order when embedded in an Arabic (RTL) sentence.
String ltrAmount(Money money) =>
    '${String.fromCharCode(0x2066)}${money.format()}'
    '${String.fromCharCode(0x2069)}';
