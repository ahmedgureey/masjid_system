import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/article_query.dart';
import '../data/articles_repository.dart';
import '../models/article.dart';
import '../models/article_category.dart';
import '../widgets/article_actions.dart';
import '../widgets/article_body.dart';
import '../widgets/article_cards.dart';
import '../widgets/article_cover.dart';
import '../widgets/scrollable_state.dart';

/// Full article: cover, title, author/mosque, dates, reading time, body,
/// references, bookmark/share actions and related articles. Only articles
/// in the public feed can be opened (drafts are never reachable).
class ArticleDetailsScreen extends ConsumerWidget {
  const ArticleDetailsScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final articlesAsync = ref.watch(articlesProvider);
    final article = articlesAsync.value
        ?.where((a) => a.id == articleId)
        .firstOrNull;

    return Scaffold(
      appBar: AppTopBar(
        actions: [
          if (article != null) ...[
            BookmarkButton(articleId: article.id),
            ShareArticleButton(article: article, lang: lang),
          ],
        ],
      ),
      body: SafeArea(
        top: false,
        child: articlesAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, _) => ScrollableStateView(
            child: ErrorState(onRetry: () => ref.invalidate(articlesProvider)),
          ),
          data: (articles) => article == null
              ? ScrollableStateView(
                  child: EmptyState(
                    icon: Icons.article_outlined,
                    title: l10n.newsNotFound,
                  ),
                )
              : _Details(article: article, all: articles, lang: lang),
        ),
      ),
    );
  }
}

class _Details extends ConsumerWidget {
  const _Details({
    required this.article,
    required this.all,
    required this.lang,
  });

  final Article article;
  final List<Article> all;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final categories =
        ref.watch(articleCategoriesProvider).value ?? const <ArticleCategory>[];
    final byId = {for (final c in categories) c.id: c};
    final category = byId[article.categoryId];
    final mosqueName = ref.watch(mosqueProvider).value?.name.resolve(lang);
    final author = article.authorName ?? mosqueName;
    final related = relatedArticles(article, all);
    final published = article.publishedAt;
    final updated = article.updatedAt;

    Widget meta(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.space1),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.neutral500),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(color: AppColors.neutral600),
            ),
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Center(
        child: ConstrainedBox(
          // Comfortable line length on large screens.
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ArticleCover(
                    imageUrl: article.coverImageUrl,
                    categorySlug: category?.slug ?? '',
                    iconSize: 72,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              if (category != null)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: StatusChip(
                    label: category.name.resolve(lang),
                    icon: categoryIcon(category.slug),
                    type: StatusType.success,
                  ),
                ),
              const SizedBox(height: AppSpacing.space2),
              DirectionalText(
                article.title.resolve(lang),
                key: const Key('articleTitle'),
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.green800,
                ),
              ),
              const SizedBox(height: AppSpacing.space2),
              if (author != null) meta(Icons.person_outline_rounded, author),
              if (published != null)
                meta(
                  Icons.calendar_today_outlined,
                  l10n.newsPublished(
                    AppDateFormatter.fullDate(published, locale: lang),
                  ),
                ),
              if (updated != null)
                meta(
                  Icons.update_rounded,
                  l10n.newsUpdated(
                    AppDateFormatter.fullDate(updated, locale: lang),
                  ),
                ),
              meta(
                Icons.timer_outlined,
                l10n.newsReadingTime(readingMinutes(article, lang)),
              ),
              if (article.isSample) ...[
                const SizedBox(height: AppSpacing.space3),
                AppCard(
                  variant: AppCardVariant.gold,
                  child: Text(
                    l10n.newsMockTitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.gold800,
                    ),
                  ),
                ),
              ],
              const Divider(height: AppSpacing.space8),
              ArticleBody(blocks: article.body, lang: lang),
              if (article.sourceReferences.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space2),
                AppCard(
                  key: const Key('articleReferences'),
                  variant: AppCardVariant.tinted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.newsReferences, style: textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.space2),
                      for (final r in article.sourceReferences)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.space2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DirectionalText(
                                '• ${r.title}',
                                style: textTheme.bodyMedium,
                              ),
                              if (r.url != null)
                                // Shown as selectable text (no link opening
                                // dependency in this phase).
                                SelectableText(
                                  r.url!,
                                  textDirection: TextDirection.ltr,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.info,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (related.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space5),
                SectionHeader(title: l10n.newsRelated),
                for (final a in related)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                    child: ArticleCard(
                      key: ValueKey('related-${a.id}'),
                      article: a,
                      category: byId[a.categoryId],
                      lang: lang,
                      onTap: () =>
                          context.pushIfCurrent(AppRoutes.article(a.id)),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
