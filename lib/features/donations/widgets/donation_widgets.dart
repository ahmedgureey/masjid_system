import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../application/finance_calculations.dart';
import '../models/donation_labels.dart';
import '../models/donation_models.dart';
import '../models/money.dart';

/// Coloured notice card (demo warnings, rules, staff notices).
class DonationNotice extends StatelessWidget {
  const DonationNotice({
    super.key,
    required this.icon,
    required this.text,
    this.title,
    this.variant = AppCardVariant.gold,
  });

  final IconData icon;
  final String? title;
  final String text;
  final AppCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = switch (variant) {
      AppCardVariant.gold => AppColors.gold800,
      AppCardVariant.tinted => AppColors.green800,
      _ => AppColors.neutral700,
    };
    return AppCard(
      variant: variant,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: textTheme.titleSmall?.copyWith(color: color),
                  ),
                Text(text, style: textTheme.bodySmall?.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Campaign image, or a branded placeholder with the category icon.
class CampaignCover extends StatelessWidget {
  const CampaignCover({super.key, required this.campaign, this.iconSize = 48});

  final DonationCampaign campaign;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.green600, AppColors.green800],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const IslamicPattern(),
          Center(
            child: Icon(
              campaign.category.icon,
              size: iconSize,
              color: AppColors.gold300,
            ),
          ),
        ],
      ),
    );
    final url = campaign.coverImageUrl;
    if (url == null) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

/// Progress bar with confirmed amount, target, percentage and remaining;
/// pending amounts are shown separately and never added.
class CampaignProgressView extends StatelessWidget {
  const CampaignProgressView({super.key, required this.progress});

  final CampaignProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    return Semantics(
      label: l10n.donProgressSemantics(
        progress.raised.format(),
        progress.target.format(),
        progress.percent,
      ),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.space2,
            children: [
              Text(
                progress.raised.format(),
                key: const Key('campaignRaised'),
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${progress.percent}%',
                key: const Key('campaignPercent'),
                style: textTheme.titleSmall?.copyWith(
                  color: semantic.goldText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space1),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress.fraction,
              minHeight: 8,
              backgroundColor: AppColors.green50,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.space1),
          Text(
            '${l10n.donRaisedOf(ltrAmount(progress.target))} · '
            '${l10n.donRemaining(ltrAmount(progress.remaining))}',
            style: textTheme.bodySmall?.copyWith(color: AppColors.neutral600),
          ),
          if (!progress.pending.isZero)
            Text(
              l10n.donPendingNotCounted(ltrAmount(progress.pending)),
              key: const Key('campaignPending'),
              style: textTheme.bodySmall?.copyWith(color: AppColors.warning),
            ),
        ],
      ),
    );
  }
}

/// Campaign card for lists.
class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.campaign,
    required this.progress,
    required this.onTap,
  });

  final DonationCampaign campaign;
  final CampaignProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      onTap: onTap,
      semanticLabel: campaign.title,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: SizedBox(
              height: 110,
              child: CampaignCover(campaign: campaign),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  children: [
                    StatusChip(
                      label: campaign.category.label(l10n),
                      icon: campaign.category.icon,
                    ),
                    StatusChip(
                      label: campaign.status.label(l10n),
                      type: campaign.status.type,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  campaign.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  campaign.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                CampaignProgressView(progress: progress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Label / value row used on detail and receipt screens.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueKey,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: AppSpacing.space2),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
            ),
          ),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            flex: 3,
            child: Text(
              value,
              key: valueKey,
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One donation in a list (history and staff records).
class DonationTile extends StatelessWidget {
  const DonationTile({
    super.key,
    required this.donation,
    required this.campaignTitle,
    required this.lang,
    this.onTap,
    this.trailing,
  });

  final Donation donation;
  final String campaignTitle;
  final String lang;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final d = donation;
    return AppCard(
      onTap: onTap,
      semanticLabel: '${d.reference} ${d.amount.format()}',
      padding: const EdgeInsets.all(AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.green50,
              shape: BoxShape.circle,
            ),
            child: Icon(d.method.icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      d.amount.format(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: d.isVoided
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    donationStatusChip(d, l10n),
                  ],
                ),
                Text(
                  campaignTitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
                Text(
                  '${d.reference} · '
                  '${AppDateFormatter.shortDate(d.date, locale: lang)} '
                  '${d.date.year} · ${d.method.label(l10n)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Reusable receipt (PDF / share can render this layout later). Only a
/// confirmed real donation is "verified"; sample data is labelled.
class DonationReceiptCard extends StatelessWidget {
  const DonationReceiptCard({
    super.key,
    required this.donation,
    required this.campaignTitle,
    required this.mosqueName,
    required this.lang,
    this.mosqueContact,
  });

  final Donation donation;
  final String campaignTitle;
  final String mosqueName;
  final String? mosqueContact;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final d = donation;
    return AppCard(
      key: const Key('receiptCard'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (d.isSample) ...[
            Container(
              key: const Key('receiptSampleBanner'),
              padding: const EdgeInsets.all(AppSpacing.space2),
              decoration: BoxDecoration(
                color: AppColors.gold50,
                border: Border.all(color: AppColors.gold400),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                l10n.donReceiptSample,
                textAlign: TextAlign.center,
                style: textTheme.labelLarge?.copyWith(color: AppColors.gold800),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
          ],
          const Icon(Icons.mosque_rounded, color: AppColors.primary, size: 36),
          Text(
            mosqueName,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.green800,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (mosqueContact != null)
            Text(
              mosqueContact!,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            l10n.donReceiptTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall,
          ),
          const Divider(height: AppSpacing.space6),
          DetailRow(
            label: l10n.donReference,
            value: d.reference,
            valueKey: const Key('receiptReference'),
          ),
          DetailRow(
            label: l10n.donDate,
            value: AppDateFormatter.fullDate(d.date, locale: lang),
          ),
          DetailRow(
            label: l10n.donAmount,
            value: '${d.amount.format()} (${d.amount.currency.code})',
          ),
          DetailRow(label: l10n.donCampaign, value: campaignTitle),
          DetailRow(label: l10n.donMethod, value: d.method.label(l10n)),
          DetailRow(
            label: l10n.donDonor,
            value: d.displayDonor ?? l10n.donAnonymousDonor,
          ),
          DetailRow(
            label: l10n.donPaymentStatus,
            value: d.hasReceipt
                ? l10n.donStatusConfirmed
                : l10n.donReceiptNotVerified,
            valueKey: const Key('receiptStatus'),
          ),
          const Divider(height: AppSpacing.space6),
          Text(
            l10n.donReceiptThanks,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.green800),
          ),
        ],
      ),
    );
  }
}
