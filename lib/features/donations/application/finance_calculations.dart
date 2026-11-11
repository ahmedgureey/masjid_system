import 'package:flutter/foundation.dart';

import '../models/donation_models.dart';
import '../models/money.dart';

/// Pure financial rules (UI-independent, unit tested). See the definitions
/// shown on the report screen:
///
/// - Confirmed donations = sum of [Donation.countsAsConfirmed] records
///   (verified, not demo, not voided) — pending, failed and refunded are
///   excluded.
/// - Expenses = sum of [MosqueExpense.countsInReports] (approved, not voided).
/// - Net for a period = confirmed donations − expenses of that period, per
///   currency. It is NOT the mosque's cash balance (no opening balance).
/// - Campaign progress = confirmed campaign donations ÷ target, capped at
///   100 %; remaining never below zero.
abstract final class FinanceCalculations {
  static bool _inRange(DateTime d, DateTime? from, DateTime? to) =>
      (from == null || !d.isBefore(from)) && (to == null || d.isBefore(to));

  /// Confirmed total in [currency] (other currencies are ignored, never
  /// converted). [to] is exclusive.
  static Money confirmedTotal(
    Iterable<Donation> donations,
    Currency currency, {
    String? campaignId,
    DateTime? from,
    DateTime? to,
  }) {
    var minor = 0;
    for (final d in donations) {
      if (d.countsAsConfirmed &&
          d.amount.currency == currency &&
          (campaignId == null || d.campaignId == campaignId) &&
          _inRange(d.date, from, to)) {
        minor += d.amount.minor;
      }
    }
    return Money(minor, currency);
  }

  /// Pending (not yet verified, real) donations of a campaign — shown
  /// separately, never added to the confirmed amount.
  static Money pendingTotal(
    Iterable<Donation> donations,
    Currency currency, {
    String? campaignId,
  }) {
    var minor = 0;
    for (final d in donations) {
      if (d.status == DonationStatus.pending &&
          !d.isDemo &&
          !d.isVoided &&
          d.amount.currency == currency &&
          (campaignId == null || d.campaignId == campaignId)) {
        minor += d.amount.minor;
      }
    }
    return Money(minor, currency);
  }

  static CampaignProgress campaignProgress(
    DonationCampaign campaign,
    Iterable<Donation> donations,
  ) {
    final raised = confirmedTotal(
      donations,
      campaign.currency,
      campaignId: campaign.id,
    );
    final target = campaign.target;
    final remainingMinor = target.minor - raised.minor;
    final fraction = target.minor <= 0
        ? 0.0
        : (raised.minor / target.minor).clamp(0.0, 1.0);
    return CampaignProgress(
      raised: raised,
      target: target,
      remaining: Money(
        remainingMinor < 0 ? 0 : remainingMinor,
        target.currency,
      ),
      pending: pendingTotal(
        donations,
        campaign.currency,
        campaignId: campaign.id,
      ),
      fraction: fraction,
    );
  }

  /// Report for [period]: one [CurrencyReport] per currency that has any
  /// eligible record in the period.
  static FinanceReport report({
    required ReportPeriod period,
    required Iterable<Donation> donations,
    required Iterable<MosqueExpense> expenses,
  }) {
    final byCurrency = <Currency, CurrencyReport>{};
    for (final currency in Currency.values) {
      final confirmed = donations.where(
        (d) =>
            d.countsAsConfirmed &&
            d.amount.currency == currency &&
            _inRange(d.date, period.start, period.end),
      );
      final counted = expenses.where(
        (e) =>
            e.countsInReports &&
            e.amount.currency == currency &&
            _inRange(e.date, period.start, period.end),
      );
      if (confirmed.isEmpty && counted.isEmpty) continue;

      final byCampaign = <String, Money>{};
      final byMethod = <PaymentMethod, Money>{};
      var donationsMinor = 0;
      for (final d in confirmed) {
        donationsMinor += d.amount.minor;
        byCampaign[d.campaignId] =
            (byCampaign[d.campaignId] ?? Money.zero(currency)) + d.amount;
        byMethod[d.method] =
            (byMethod[d.method] ?? Money.zero(currency)) + d.amount;
      }
      var expensesMinor = 0;
      for (final e in counted) {
        expensesMinor += e.amount.minor;
      }
      byCurrency[currency] = CurrencyReport(
        currency: currency,
        confirmedDonations: Money(donationsMinor, currency),
        expenses: Money(expensesMinor, currency),
        byCampaign: byCampaign,
        byMethod: byMethod,
        donationCount: confirmed.length,
        expenseCount: counted.length,
      );
    }
    return FinanceReport(period: period, byCurrency: byCurrency);
  }

  /// Total of counted expenses in [currency] (used by the expenses list).
  static Money expensesTotal(
    Iterable<MosqueExpense> expenses,
    Currency currency,
  ) {
    var minor = 0;
    for (final e in expenses) {
      if (e.countsInReports && e.amount.currency == currency) {
        minor += e.amount.minor;
      }
    }
    return Money(minor, currency);
  }
}

@immutable
class CampaignProgress {
  const CampaignProgress({
    required this.raised,
    required this.target,
    required this.remaining,
    required this.pending,
    required this.fraction,
  });

  final Money raised;
  final Money target;
  final Money remaining;
  final Money pending;

  /// 0.0 – 1.0 (capped).
  final double fraction;

  int get percent => (fraction * 100).floor();
}

enum ReportGranularity { day, month, year }

/// A reporting period [start, end).
@immutable
class ReportPeriod {
  ReportPeriod(this.granularity, DateTime anchor)
    : start = switch (granularity) {
        ReportGranularity.day => DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
        ),
        ReportGranularity.month => DateTime(anchor.year, anchor.month),
        ReportGranularity.year => DateTime(anchor.year),
      };

  final ReportGranularity granularity;
  final DateTime start;

  DateTime get end => switch (granularity) {
    ReportGranularity.day => DateTime(start.year, start.month, start.day + 1),
    ReportGranularity.month => DateTime(start.year, start.month + 1),
    ReportGranularity.year => DateTime(start.year + 1),
  };

  /// The previous (-1) or next (+1) period.
  ReportPeriod shift(int delta) =>
      ReportPeriod(granularity, switch (granularity) {
        ReportGranularity.day => DateTime(
          start.year,
          start.month,
          start.day + delta,
        ),
        ReportGranularity.month => DateTime(start.year, start.month + delta),
        ReportGranularity.year => DateTime(start.year + delta),
      });

  @override
  bool operator ==(Object other) =>
      other is ReportPeriod &&
      other.granularity == granularity &&
      other.start == start;

  @override
  int get hashCode => Object.hash(granularity, start);
}

@immutable
class CurrencyReport {
  const CurrencyReport({
    required this.currency,
    required this.confirmedDonations,
    required this.expenses,
    required this.byCampaign,
    required this.byMethod,
    required this.donationCount,
    required this.expenseCount,
  });

  final Currency currency;
  final Money confirmedDonations;
  final Money expenses;
  final Map<String, Money> byCampaign;
  final Map<PaymentMethod, Money> byMethod;
  final int donationCount;
  final int expenseCount;

  /// Confirmed donations − counted expenses (may be negative).
  Money get net => confirmedDonations - expenses;
}

@immutable
class FinanceReport {
  const FinanceReport({required this.period, required this.byCurrency});

  final ReportPeriod period;
  final Map<Currency, CurrencyReport> byCurrency;

  bool get isEmpty => byCurrency.isEmpty;
}
