import 'package:flutter/foundation.dart';

import 'money.dart';

// ---------------------------------------------------------------------------
// Campaigns (future table `donation_campaigns`)
// ---------------------------------------------------------------------------

enum CampaignCategory {
  construction,
  maintenance,
  utilities,
  quranEducation,
  needyFamilies,
  ramadanFood,
  general,
}

enum CampaignStatus { draft, active, completed, archived }

@immutable
class DonationCampaign {
  const DonationCampaign({
    required this.id,
    required this.mosqueId,
    required this.title,
    required this.description,
    required this.category,
    this.coverImageUrl,
    required this.target,
    this.startDate,
    this.endDate,
    required this.status,
    required this.createdAt,
    this.isSample = false,
  });

  final String id;
  final String mosqueId;
  final String title;
  final String description;
  final CampaignCategory category;
  final String? coverImageUrl;

  /// Fundraising target; its currency is the campaign currency.
  final Money target;
  final DateTime? startDate;
  final DateTime? endDate;
  final CampaignStatus status;
  final DateTime createdAt;

  /// Clearly identified mock data.
  final bool isSample;

  Currency get currency => target.currency;
}

// ---------------------------------------------------------------------------
// Donations (future table `donations` — void, never delete)
// ---------------------------------------------------------------------------

/// Verified payment status. A demo submission is NOT a status: see
/// [Donation.isDemo].
enum DonationStatus { pending, confirmed, failed, refunded }

enum PaymentMethod { cash, bankTransfer, mobileMoney, online }

enum AuditAction {
  demoSubmitted,
  recorded,
  confirmed,
  voided,
  expenseRecorded,
  expenseApproved,
  expenseRejected,
}

/// One entry of the audit trail of a financial record. Today in memory
/// only; the backend will keep an insert-only `audit_logs` table.
@immutable
class AuditEntry {
  const AuditEntry({
    required this.at,
    required this.actor,
    required this.action,
    this.note,
  });

  final DateTime at;
  final String actor;
  final AuditAction action;
  final String? note;
}

@immutable
class Donation {
  const Donation({
    required this.id,
    required this.mosqueId,
    required this.reference,
    required this.campaignId,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
    this.isDemo = false,
    this.isSample = false,
    this.userId,
    this.donorName,
    this.donorContact,
    this.isAnonymous = false,
    this.message,
    this.externalReference,
    this.recordedBy,
    this.voidedAt,
    this.voidReason,
    this.audit = const [],
  });

  final String id;
  final String mosqueId;

  /// Human-readable reference shown on history and receipts.
  final String reference;
  final String campaignId;
  final Money amount;
  final DateTime date;
  final PaymentMethod method;
  final DonationStatus status;

  /// Submitted in demo mode: no money was taken, never counted, no receipt.
  final bool isDemo;

  /// Part of the clearly labelled sample data set.
  final bool isSample;

  /// Owner (signed-in user) — history shows only the user's own records.
  final String? userId;
  final String? donorName;
  final String? donorContact;

  /// Donor identity must never be shown publicly.
  final bool isAnonymous;
  final String? message;

  /// Bank / mobile-money transaction reference entered by staff.
  final String? externalReference;
  final String? recordedBy;
  final DateTime? voidedAt;
  final String? voidReason;
  final List<AuditEntry> audit;

  bool get isVoided => voidedAt != null;

  /// The single rule for "confirmed donations": verified, real (not demo)
  /// and not voided.
  bool get countsAsConfirmed =>
      status == DonationStatus.confirmed && !isDemo && !isVoided;

  /// A receipt exists only for a confirmed real donation.
  bool get hasReceipt => countsAsConfirmed;

  /// Name that may be displayed (null when anonymous or not given).
  String? get displayDonor => isAnonymous ? null : donorName;

  Donation copyWith({
    DonationStatus? status,
    DateTime? voidedAt,
    String? voidReason,
    List<AuditEntry>? audit,
  }) => Donation(
    id: id,
    mosqueId: mosqueId,
    reference: reference,
    campaignId: campaignId,
    amount: amount,
    date: date,
    method: method,
    status: status ?? this.status,
    isDemo: isDemo,
    isSample: isSample,
    userId: userId,
    donorName: donorName,
    donorContact: donorContact,
    isAnonymous: isAnonymous,
    message: message,
    externalReference: externalReference,
    recordedBy: recordedBy,
    voidedAt: voidedAt ?? this.voidedAt,
    voidReason: voidReason ?? this.voidReason,
    audit: audit ?? this.audit,
  );
}

// ---------------------------------------------------------------------------
// Expenses (future table `expenses` — void, never delete)
// ---------------------------------------------------------------------------

enum ExpenseCategory {
  maintenance,
  electricity,
  water,
  cleaning,
  salaries,
  education,
  communitySupport,
  other,
}

enum ExpenseStatus { pending, approved, rejected }

@immutable
class MosqueExpense {
  const MosqueExpense({
    required this.id,
    required this.mosqueId,
    required this.category,
    required this.description,
    required this.reason,
    required this.amount,
    required this.date,
    this.payee,
    this.documentUrl,
    this.projectId,
    required this.recordedBy,
    required this.status,
    this.voidedAt,
    this.voidReason,
    this.audit = const [],
    this.isSample = false,
  });

  final String id;
  final String mosqueId;
  final ExpenseCategory category;
  final String description;

  /// Business reason for the expense.
  final String reason;
  final Money amount;
  final DateTime date;
  final String? payee;
  final String? documentUrl;

  /// Project this expense belongs to (optional; at most one project, so it
  /// is never counted twice).
  final String? projectId;
  final String recordedBy;
  final ExpenseStatus status;
  final DateTime? voidedAt;
  final String? voidReason;
  final List<AuditEntry> audit;
  final bool isSample;

  bool get isVoided => voidedAt != null;

  /// Reporting rule: only approved, non-voided expenses are counted.
  bool get countsInReports => status == ExpenseStatus.approved && !isVoided;

  MosqueExpense copyWith({
    ExpenseStatus? status,
    DateTime? voidedAt,
    String? voidReason,
    List<AuditEntry>? audit,
  }) => MosqueExpense(
    id: id,
    mosqueId: mosqueId,
    category: category,
    description: description,
    reason: reason,
    amount: amount,
    date: date,
    payee: payee,
    documentUrl: documentUrl,
    projectId: projectId,
    recordedBy: recordedBy,
    status: status ?? this.status,
    voidedAt: voidedAt ?? this.voidedAt,
    voidReason: voidReason ?? this.voidReason,
    audit: audit ?? this.audit,
    isSample: isSample,
  );
}
