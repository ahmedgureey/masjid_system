import '../../donations/application/donation_validation.dart';
import '../../donations/application/finance_calculations.dart';
import '../../donations/models/donation_models.dart';
import '../../donations/models/money.dart';
import '../models/project_models.dart';

/// Pure project rules (unit tested).
abstract final class ProjectLogic {
  /// Funding progress from CONFIRMED donations of the linked campaign, in
  /// the project currency (other currencies are never converted or added).
  /// A zero target gives 0 % (no division by zero); remaining is never
  /// below zero. Reuses the Donations module's single confirmed-total rule.
  static CampaignProgress funding(
    MosqueProject project,
    Iterable<Donation> donations,
  ) {
    final target = project.effectiveFundingTarget;
    final campaignId = project.fundingCampaignId;
    final raised = campaignId == null
        ? Money.zero(target.currency)
        : FinanceCalculations.confirmedTotal(
            donations,
            target.currency,
            campaignId: campaignId,
          );
    final pending = campaignId == null
        ? Money.zero(target.currency)
        : FinanceCalculations.pendingTotal(
            donations,
            target.currency,
            campaignId: campaignId,
          );
    final remaining = target.minor - raised.minor;
    return CampaignProgress(
      raised: raised,
      target: target,
      remaining: Money(remaining < 0 ? 0 : remaining, target.currency),
      pending: pending,
      fraction: target.minor <= 0
          ? 0.0
          : (raised.minor / target.minor).clamp(0.0, 1.0),
    );
  }

  /// Approved, non-voided expenses recorded against [projectId] (each
  /// expense belongs to at most one project, so it is counted once).
  static Money approvedExpenses(
    String projectId,
    Iterable<MosqueExpense> expenses,
    Currency currency,
  ) => FinanceCalculations.expensesTotal(
    expenses.where((e) => e.projectId == projectId),
    currency,
  );

  /// Campaigns that may fund project [projectId] (null = new project):
  /// active, in [currency], and not linked to ANOTHER project — a campaign
  /// funds at most one project, so its donations are never counted twice.
  static List<DonationCampaign> availableCampaigns({
    required String? projectId,
    required Currency currency,
    required Iterable<DonationCampaign> campaigns,
    required Iterable<MosqueProject> projects,
  }) {
    final linkedElsewhere = {
      for (final p in projects)
        if (p.id != projectId && p.fundingCampaignId != null)
          p.fundingCampaignId!,
    };
    return [
      for (final c in campaigns)
        if (c.status == CampaignStatus.active &&
            c.currency == currency &&
            !linkedElsewhere.contains(c.id))
          c,
    ];
  }

  /// Whether donations to [project] can be opened: the project is not
  /// completed / cancelled AND its linked campaign exists and is active.
  static bool canAcceptDonations(
    MosqueProject project,
    Iterable<DonationCampaign> campaigns,
  ) {
    if (project.status == ProjectStatus.completed ||
        project.status == ProjectStatus.cancelled) {
      return false;
    }
    final id = project.fundingCampaignId;
    if (id == null) return false;
    return campaigns.any(
      (c) => c.id == id && c.status == CampaignStatus.active,
    );
  }

  static List<ProjectMilestone> completedMilestones(MosqueProject p) =>
      p.milestones.where((m) => m.isCompleted).toList();

  static List<ProjectMilestone> upcomingMilestones(MosqueProject p) =>
      p.milestones.where((m) => !m.isCompleted).toList()..sort(
        (a, b) => (a.dueDate ?? DateTime(9999)).compareTo(
          b.dueDate ?? DateTime(9999),
        ),
      );

  /// Updates a viewer may see, newest first. Drafts only for managers.
  static List<ProjectUpdate> visibleUpdates(
    Iterable<ProjectUpdate> updates,
    String projectId, {
    required bool canManage,
  }) =>
      updates
          .where(
            (u) => u.projectId == projectId && (canManage || u.isPublished),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  /// Search (name, case-insensitive) + category + status filter.
  static List<MosqueProject> filter(
    Iterable<MosqueProject> projects, {
    String query = '',
    String? categoryId,
    ProjectStatus? status,
  }) {
    final q = query.trim().toLowerCase();
    return projects
        .where(
          (p) =>
              (q.isEmpty || p.title.toLowerCase().contains(q)) &&
              (categoryId == null || p.categoryId == categoryId) &&
              (status == null || p.status == status),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

enum ProjectFieldError {
  required,
  invalidAmount,
  negative,
  tooManyDecimals,
  endBeforeStart,
  percentRange,
}

/// Pure form validation.
abstract final class ProjectValidation {
  static final RegExp _amount = RegExp(r'^\d+(\.\d+)?$');

  static ProjectFieldError? requiredText(String? v) =>
      (v == null || v.trim().isEmpty) ? ProjectFieldError.required : null;

  /// Non-negative amount (zero allowed, e.g. a volunteer project).
  static ProjectFieldError? budget(String? v, Currency currency) {
    final raw = (v ?? '').trim();
    if (raw.isEmpty) return ProjectFieldError.required;
    if (raw.startsWith('-')) return ProjectFieldError.negative;
    // Same comma rule as donations: only real thousands separators.
    final text = normalizeAmountText(raw);
    if (text == null || !_amount.hasMatch(text)) {
      return ProjectFieldError.invalidAmount;
    }
    final fraction = text.contains('.') ? text.split('.')[1] : '';
    if (fraction.length > currency.decimals) {
      return ProjectFieldError.tooManyDecimals;
    }
    return null;
  }

  static Money? parseAmount(String v, Currency currency) {
    if (budget(v, currency) != null) return null;
    final text = normalizeAmountText(v)!;
    final parts = text.split('.');
    // `budget` checks the shape, not the magnitude: a number too large for an
    // int still reaches here, so parse defensively like DonationValidation
    // does and report it as unparseable rather than throwing.
    final major = int.tryParse(parts[0]);
    if (major == null) return null;
    final fraction = parts.length > 1
        ? int.tryParse(parts[1].padRight(currency.decimals, '0'))
        : 0;
    if (fraction == null) return null;
    return Money(major * currency.minorPerMajor + fraction, currency);
  }

  static ProjectFieldError? dates(DateTime? start, DateTime? end) {
    if (start == null || end == null) return null;
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return e.isBefore(s) ? ProjectFieldError.endBeforeStart : null;
  }

  /// Optional whole percentage 0–100.
  static ProjectFieldError? percent(String? v) {
    final text = (v ?? '').trim();
    if (text.isEmpty) return null;
    final n = int.tryParse(text);
    if (n == null || n < 0 || n > 100) return ProjectFieldError.percentRange;
    return null;
  }
}
