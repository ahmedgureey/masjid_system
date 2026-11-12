import '../models/donation_models.dart';
import '../models/money.dart';

/// Maps campaigns, donations and expenses to and from the JSON stored on the
/// device.
///
/// Money is written as integer minor units plus a currency code, exactly as
/// [Money] holds it — writing a formatted string, or a double, would lose
/// the precision the model exists to protect. Audit entries are written in
/// full: a financial record without its trail is worth less than no record.
///
/// Reading is forgiving. A row written by a newer build, or one damaged by a
/// half-finished write, costs that one record at worst rather than the whole
/// screen. The `…From` methods return null for anything unusable and callers
/// drop it — except that a money amount is never guessed at, because a
/// donation with an invented amount is worse than a missing one.
abstract final class DonationJson {
  // ---------------------------------------------------------------------------
  // Campaign
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> campaignTo(DonationCampaign c) => {
    'id': c.id,
    'mosque_id': c.mosqueId,
    'title': c.title,
    'description': c.description,
    'category': c.category.name,
    'cover_image_url': c.coverImageUrl,
    'target': moneyTo(c.target),
    'start_date': c.startDate?.toIso8601String(),
    'end_date': c.endDate?.toIso8601String(),
    'status': c.status.name,
    'created_at': c.createdAt.toIso8601String(),
    'is_sample': c.isSample,
  };

  static DonationCampaign? campaignFrom(Map<String, dynamic> row) {
    final id = row['id'];
    final target = moneyFrom(row['target']);
    if (id is! String || id.isEmpty || target == null) return null;

    return DonationCampaign(
      id: id,
      mosqueId: _string(row['mosque_id']) ?? '',
      title: _string(row['title']) ?? '',
      description: _string(row['description']) ?? '',
      category: _enum(CampaignCategory.values, row['category']) ??
          CampaignCategory.values.last,
      coverImageUrl: _string(row['cover_image_url']),
      target: target,
      startDate: _date(row['start_date']),
      endDate: _date(row['end_date']),
      status: _enum(CampaignStatus.values, row['status']) ??
          CampaignStatus.draft,
      createdAt:
          _date(row['created_at']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      isSample: row['is_sample'] == true,
    );
  }

  static List<DonationCampaign> campaignsFrom(
    Iterable<Map<String, dynamic>> rows,
  ) => rows.map(campaignFrom).whereType<DonationCampaign>().toList();

  static List<Map<String, dynamic>> campaignsTo(
    Iterable<DonationCampaign> items,
  ) => items.map(campaignTo).toList();

  // ---------------------------------------------------------------------------
  // Donation
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> donationTo(Donation d) => {
    'id': d.id,
    'mosque_id': d.mosqueId,
    'reference': d.reference,
    'campaign_id': d.campaignId,
    'amount': moneyTo(d.amount),
    'date': d.date.toIso8601String(),
    'method': d.method.name,
    'status': d.status.name,
    'is_demo': d.isDemo,
    'is_sample': d.isSample,
    'user_id': d.userId,
    'donor_name': d.donorName,
    'donor_contact': d.donorContact,
    'is_anonymous': d.isAnonymous,
    'message': d.message,
    'external_reference': d.externalReference,
    'recorded_by': d.recordedBy,
    'voided_at': d.voidedAt?.toIso8601String(),
    'void_reason': d.voidReason,
    'audit': _auditTo(d.audit),
  };

  static Donation? donationFrom(Map<String, dynamic> row) {
    final id = row['id'];
    final amount = moneyFrom(row['amount']);
    if (id is! String || id.isEmpty || amount == null) return null;

    return Donation(
      id: id,
      mosqueId: _string(row['mosque_id']) ?? '',
      reference: _string(row['reference']) ?? '',
      campaignId: _string(row['campaign_id']) ?? '',
      amount: amount,
      date: _date(row['date']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      method: _enum(PaymentMethod.values, row['method']) ??
          PaymentMethod.cash,
      // An unreadable status must not become "confirmed": that would add
      // money to the mosque's totals that nobody verified.
      status: _enum(DonationStatus.values, row['status']) ??
          DonationStatus.pending,
      isDemo: row['is_demo'] == true,
      isSample: row['is_sample'] == true,
      userId: _string(row['user_id']),
      donorName: _string(row['donor_name']),
      donorContact: _string(row['donor_contact']),
      isAnonymous: row['is_anonymous'] == true,
      message: _string(row['message']),
      externalReference: _string(row['external_reference']),
      recordedBy: _string(row['recorded_by']),
      voidedAt: _date(row['voided_at']),
      voidReason: _string(row['void_reason']),
      audit: _auditFrom(row['audit']),
    );
  }

  static List<Donation> donationsFrom(Iterable<Map<String, dynamic>> rows) =>
      rows.map(donationFrom).whereType<Donation>().toList();

  static List<Map<String, dynamic>> donationsTo(Iterable<Donation> items) =>
      items.map(donationTo).toList();

  // ---------------------------------------------------------------------------
  // Expense
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> expenseTo(MosqueExpense e) => {
    'id': e.id,
    'mosque_id': e.mosqueId,
    'category': e.category.name,
    'description': e.description,
    'reason': e.reason,
    'amount': moneyTo(e.amount),
    'date': e.date.toIso8601String(),
    'payee': e.payee,
    'document_url': e.documentUrl,
    'project_id': e.projectId,
    'recorded_by': e.recordedBy,
    'status': e.status.name,
    'voided_at': e.voidedAt?.toIso8601String(),
    'void_reason': e.voidReason,
    'audit': _auditTo(e.audit),
    'is_sample': e.isSample,
  };

  static MosqueExpense? expenseFrom(Map<String, dynamic> row) {
    final id = row['id'];
    final amount = moneyFrom(row['amount']);
    if (id is! String || id.isEmpty || amount == null) return null;

    return MosqueExpense(
      id: id,
      mosqueId: _string(row['mosque_id']) ?? '',
      category: _enum(ExpenseCategory.values, row['category']) ??
          ExpenseCategory.values.last,
      description: _string(row['description']) ?? '',
      reason: _string(row['reason']) ?? '',
      amount: amount,
      date: _date(row['date']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      payee: _string(row['payee']),
      documentUrl: _string(row['document_url']),
      projectId: _string(row['project_id']),
      recordedBy: _string(row['recorded_by']) ?? '',
      // As with a donation, an unreadable status must not become the one
      // that counts in the reports.
      status: _enum(ExpenseStatus.values, row['status']) ??
          ExpenseStatus.pending,
      voidedAt: _date(row['voided_at']),
      voidReason: _string(row['void_reason']),
      audit: _auditFrom(row['audit']),
      isSample: row['is_sample'] == true,
    );
  }

  static List<MosqueExpense> expensesFrom(
    Iterable<Map<String, dynamic>> rows,
  ) => rows.map(expenseFrom).whereType<MosqueExpense>().toList();

  static List<Map<String, dynamic>> expensesTo(
    Iterable<MosqueExpense> items,
  ) => items.map(expenseTo).toList();

  // ---------------------------------------------------------------------------
  // Parts
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> moneyTo(Money m) => {
    'minor': m.minor,
    'currency': m.currency.code,
  };

  static Money? moneyFrom(Object? value) {
    if (value is! Map) return null;
    final minor = value['minor'];
    if (minor is! num) return null;
    final code = value['currency'];
    for (final currency in Currency.values) {
      if (currency.code == code) return Money(minor.toInt(), currency);
    }
    return null;
  }

  static List<Map<String, dynamic>> _auditTo(Iterable<AuditEntry> audit) => [
    for (final a in audit)
      {
        'at': a.at.toIso8601String(),
        'actor': a.actor,
        'action': a.action.name,
        'note': a.note,
      },
  ];

  static List<AuditEntry> _auditFrom(Object? value) {
    if (value is! List) return const [];
    final out = <AuditEntry>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final at = _date(entry['at']);
      final action = _enum(AuditAction.values, entry['action']);
      // An entry with no time or no action says nothing; a trail with a
      // mystery line in it is worse than one line shorter.
      if (at == null || action == null) continue;
      out.add(
        AuditEntry(
          at: at,
          actor: _string(entry['actor']) ?? '',
          action: action,
          note: _string(entry['note']),
        ),
      );
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // Primitives
  // ---------------------------------------------------------------------------

  static String? _string(Object? v) => v is String ? v : null;

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v) : null;

  static T? _enum<T extends Enum>(List<T> values, Object? v) {
    if (v is! String) return null;
    for (final value in values) {
      if (value.name == v) return value;
    }
    return null;
  }
}
