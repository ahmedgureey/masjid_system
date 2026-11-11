import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../application/article_query.dart';
import '../models/article.dart';
import '../models/article_category.dart';
import 'article_cover.dart';

/// "Arb 11 Nof 2026"-style date of an article.
String articleDate(Article article, String lang) {
  final d = article.publishedAt ?? article.createdAt;
  return '${AppDateFormatter.shortDate(d, locale: lang)} ${d.year}';
}

/// "Arb 11 Nof 2026 · 3 daqiiqo akhris".
String articleMeta(Article article, String lang, AppLocalizations l10n) =>
    '${articleDate(article, lang)} · '
    '${l10n.newsReadingTime(readingMinutes(article, lang))}';

/// Text with its own direction (Arabic content inside a Somali UI).
class DirectionalText extends StatelessWidget {
  const DirectionalText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final rtl = isRtlText(text);
    return Text(
      text,
      // Each text follows its own script: Arabic RTL, Latin LTR (also
      // inside the Arabic UI), otherwise the ambient direction.
      textDirection: rtl
          ? TextDirection.rtl
          : (hasLatinLetter(text) ? TextDirection.ltr : null),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: rtl ? style?.copyWith(fontFamily: 'NotoSansArabic') : style,
    );
  }
}

/// Compact list card: thumbnail, category, title, summary, date and
/// reading time.
class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.category,
    required this.lang,
    required this.onTap,
  });

  final Article article;
  final ArticleCategory? category;
  final String lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final title = article.title.resolve(lang);

    return AppCard(
      onTap: onTap,
      semanticLabel: title,
      padding: const EdgeInsets.all(AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 88,
              height: 88,
              child: ArticleCover(
                imageUrl: article.coverImageUrl,
                categorySlug: category?.slug ?? '',
                iconSize: 30,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category != null)
                  Text(
                    category!.name.resolve(lang),
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                DirectionalText(
                  title,
                  maxLines: 2,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                DirectionalText(
                  article.summary.resolve(lang),
                  maxLines: 2,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  articleMeta(article, lang, l10n),
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Large featured card with the cover image and a gold "Featured" badge.
class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({
    super.key,
    required this.article,
    required this.category,
    required this.lang,
    required this.onTap,
  });

  final Article article;
  final ArticleCategory? category;
  final String lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final semantic = context.semanticColors;
    final title = article.title.resolve(lang);

    return Semantics(
      button: true,
      label: title,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Material(
          color: AppColors.green800,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ArticleCover(
                        imageUrl: article.coverImageUrl,
                        categorySlug: category?.slug ?? '',
                        iconSize: 64,
                      ),
                      PositionedDirectional(
                        top: AppSpacing.space3,
                        start: AppSpacing.space3,
                        child: StatusChip(
                          label: l10n.newsFeatured,
                          type: StatusType.gold,
                          icon: Icons.star_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category != null)
                        Text(
                          category!.name.resolve(lang),
                          style: textTheme.labelMedium?.copyWith(
                            color: semantic.goldOnDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.space1),
                      DirectionalText(
                        title,
                        maxLines: 3,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space1),
                      DirectionalText(
                        article.summary.resolve(lang),
                        maxLines: 2,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.green100,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        articleMeta(article, lang, l10n),
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.green100,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
