import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'donation_models.dart';

extension CampaignCategoryLabels on CampaignCategory {
  String label(AppLocalizations l10n) => switch (this) {
    CampaignCategory.construction => l10n.donCatConstruction,
    CampaignCategory.maintenance => l10n.donCatMaintenance,
    CampaignCategory.utilities => l10n.donCatUtilities,
    CampaignCategory.quranEducation => l10n.donCatQuran,
    CampaignCategory.needyFamilies => l10n.donCatFamilies,
    CampaignCategory.ramadanFood => l10n.donCatRamadan,
    CampaignCategory.general => l10n.donCatGeneral,
  };

  IconData get icon => switch (this) {
    CampaignCategory.construction => Icons.mosque_rounded,
    CampaignCategory.maintenance => Icons.handyman_rounded,
    CampaignCategory.utilities => Icons.bolt_rounded,
    CampaignCategory.quranEducation => Icons.menu_book_rounded,
    CampaignCategory.needyFamilies => Icons.family_restroom_rounded,
    CampaignCategory.ramadanFood => Icons.restaurant_rounded,
    CampaignCategory.general => Icons.volunteer_activism_rounded,
  };
}

extension CampaignStatusLabels on CampaignStatus {
  String label(AppLocalizations l10n) => switch (this) {
    CampaignStatus.draft => l10n.donCampaignDraft,
    CampaignStatus.active => l10n.donCampaignActive,
    CampaignStatus.completed => l10n.donCampaignCompleted,
    CampaignStatus.archived => l10n.donCampaignArchived,
  };

  StatusType get type => switch (this) {
    CampaignStatus.active => StatusType.success,
    CampaignStatus.completed => StatusType.info,
    _ => StatusType.neutral,
  };
}

extension PaymentMethodLabels on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cash => l10n.donMethodCash,
    PaymentMethod.bankTransfer => l10n.donMethodBank,
    PaymentMethod.mobileMoney => l10n.donMethodMobile,
    PaymentMethod.online => l10n.donMethodOnline,
  };

  IconData get icon => switch (this) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.bankTransfer => Icons.account_balance_outlined,
    PaymentMethod.mobileMoney => Icons.phone_iphone_rounded,
    PaymentMethod.online => Icons.public_rounded,
  };
}

extension ExpenseCategoryLabels on ExpenseCategory {
  String label(AppLocalizations l10n) => switch (this) {
    ExpenseCategory.maintenance => l10n.donExpCatMaintenance,
    ExpenseCategory.electricity => l10n.donExpCatElectricity,
    ExpenseCategory.water => l10n.donExpCatWater,
    ExpenseCategory.cleaning => l10n.donExpCatCleaning,
    ExpenseCategory.salaries => l10n.donExpCatSalaries,
    ExpenseCategory.education => l10n.donExpCatEducation,
    ExpenseCategory.communitySupport => l10n.donExpCatCommunity,
    ExpenseCategory.other => l10n.donExpCatOther,
  };
}

extension AuditActionLabels on AuditAction {
  String label(AppLocalizations l10n) => switch (this) {
    AuditAction.demoSubmitted => l10n.donAuditDemo,
    AuditAction.recorded => l10n.donAuditRecorded,
    AuditAction.confirmed => l10n.donAuditConfirmed,
    AuditAction.voided => l10n.donAuditVoided,
    AuditAction.expenseRecorded => l10n.donAuditExpenseRecorded,
    AuditAction.expenseApproved => l10n.donAuditExpenseApproved,
    AuditAction.expenseRejected => l10n.donAuditExpenseRejected,
  };
}

/// Filter values for donation lists ("demo" and "voided" are shown as
/// their own states, separate from verified statuses).
enum DonationStateFilter {
  all,
  pending,
  confirmed,
  failed,
  refunded,
  demo,
  voided,
}

extension DonationStateFilterLabels on DonationStateFilter {
  String label(AppLocalizations l10n) => switch (this) {
    DonationStateFilter.all => l10n.donFilterAll,
    DonationStateFilter.pending => l10n.donStatusPending,
    DonationStateFilter.confirmed => l10n.donStatusConfirmed,
    DonationStateFilter.failed => l10n.donStatusFailed,
    DonationStateFilter.refunded => l10n.donStatusRefunded,
    DonationStateFilter.demo => l10n.donStatusDemo,
    DonationStateFilter.voided => l10n.donStatusVoided,
  };

  bool matches(Donation d) => switch (this) {
    DonationStateFilter.all => true,
    DonationStateFilter.demo => d.isDemo,
    DonationStateFilter.voided => d.isVoided,
    DonationStateFilter.pending =>
      !d.isDemo && !d.isVoided && d.status == DonationStatus.pending,
    DonationStateFilter.confirmed =>
      !d.isDemo && !d.isVoided && d.status == DonationStatus.confirmed,
    DonationStateFilter.failed =>
      !d.isDemo && !d.isVoided && d.status == DonationStatus.failed,
    DonationStateFilter.refunded =>
      !d.isDemo && !d.isVoided && d.status == DonationStatus.refunded,
  };
}

/// Status chip of a donation: demo and voided win over the payment status.
StatusChip donationStatusChip(Donation d, AppLocalizations l10n) {
  if (d.isDemo) {
    return StatusChip(
      label: l10n.donStatusDemo,
      type: StatusType.gold,
      icon: Icons.science_outlined,
    );
  }
  if (d.isVoided) {
    return StatusChip(label: l10n.donStatusVoided, icon: Icons.block_rounded);
  }
  return switch (d.status) {
    DonationStatus.pending => StatusChip(
      label: l10n.donStatusPending,
      type: StatusType.warning,
      icon: Icons.hourglass_top_rounded,
    ),
    DonationStatus.confirmed => StatusChip(
      label: l10n.donStatusConfirmed,
      type: StatusType.success,
      icon: Icons.verified_outlined,
    ),
    DonationStatus.failed => StatusChip(
      label: l10n.donStatusFailed,
      type: StatusType.error,
      icon: Icons.error_outline_rounded,
    ),
    DonationStatus.refunded => StatusChip(
      label: l10n.donStatusRefunded,
      type: StatusType.info,
      icon: Icons.undo_rounded,
    ),
  };
}

StatusChip expenseStatusChip(MosqueExpense e, AppLocalizations l10n) {
  if (e.isVoided) {
    return StatusChip(label: l10n.donStatusVoided, icon: Icons.block_rounded);
  }
  return switch (e.status) {
    ExpenseStatus.pending => StatusChip(
      label: l10n.donStatusPending,
      type: StatusType.warning,
      icon: Icons.hourglass_top_rounded,
    ),
    ExpenseStatus.approved => StatusChip(
      label: l10n.donExpenseApproved,
      type: StatusType.success,
      icon: Icons.check_circle_outline_rounded,
    ),
    ExpenseStatus.rejected => StatusChip(
      label: l10n.donExpenseRejected,
      type: StatusType.error,
      icon: Icons.cancel_outlined,
    ),
  };
}
