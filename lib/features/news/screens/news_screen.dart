import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../application/article_query.dart';
import '../application/news_permissions.dart';
import '../data/articles_repository.dart';
import '../models/article.dart';
import '../models/article_category.dart';
import '../widgets/article_cards.dart';
import '../widgets/scrollable_state.dart';

/// "Wararka & Maqaallada": search, category chips, featured article, latest
/// and recommended sections, or a sorted result list while filtering.
class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final _search = TextEditingController();
  ArticleQuery _query = const ArticleQuery();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(articleCategoriesProvider)
      ..invalidate(articlesProvider);
    await ref.read(articlesProvider.future);
  }

  void _clearAll() {
    _search.clear();
    FocusScope.of(context).unfocus();
    setState(() => _query = ArticleQuery(sort: _query.sort));
  }

  void _open(Article a) => context.pushIfCurrent(AppRoutes.article(a.id));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final articlesAsync = ref.watch(articlesProvider);
    final canManage = ref.watch(canManageNewsProvider);

    return Scaffold(
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              key: const Key('newsAddButton'),
              onPressed: () => context.pushIfCurrent(AppRoutes.newArticle),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.newsAdd),
            )
          : null,
      appBar: AppTopBar(
        title: l10n.newsTitle,
        actions: [
          IconButton(
            key: const Key('newsSavedButton'),
            tooltip: l10n.newsSaved,
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () => context.pushIfCurrent(AppRoutes.savedArticles),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: articlesAsync.when(
          skipLoadingOnRefresh: true,
          loading: () => const AppLoadingIndicator(),
          error: (_, _) =>
              ScrollableStateView(child: ErrorState(onRetry: _refresh)),
          data: (articles) => RefreshIndicator(
            onRefresh: _refresh,
            child: _content(context, articles),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, List<Article> articles) {
    final l10n = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    final categories =
        ref.watch(articleCategoriesProvider).value ?? const <ArticleCategory>[];
    final byId = {for (final c in categories) c.id: c};

    final now = DateTime.now();

    Widget card(Article a) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Only an administrator ever sees these, and only they need to
          // tell an unpublished article apart from a live one.
          if (!a.isPubliclyVisibleAt(now)) ...[
            StatusChip(
              key: ValueKey('articleStatus-${a.id}'),
              label: switch (a.status) {
                ArticleStatus.draft => l10n.newsStatusDraft,
                ArticleStatus.archived => l10n.newsStatusArchived,
                ArticleStatus.published => l10n.newsStatusScheduled,
              },
              type: a.status == ArticleStatus.published
                  ? StatusType.info
                  : StatusType.warning,
              icon: a.status == ArticleStatus.published
                  ? Icons.schedule_rounded
                  : Icons.edit_note_rounded,
            ),
            const SizedBox(height: AppSpacing.space2),
          ],
          ArticleCard(
            key: ValueKey('article-${a.id}'),
            article: a,
            category: byId[a.categoryId],
            lang: lang,
            onTap: () => _open(a),
          ),
        ],
      ),
    );

    final children = <Widget>[
      _SearchField(
        controller: _search,
        onChanged: (text) =>
            setState(() => _query = _query.copyWith(text: text)),
        onClear: () {
          _search.clear();
          setState(() => _query = _query.copyWith(text: ''));
        },
      ),
      const SizedBox(height: AppSpacing.space3),
      _CategoryChips(
        categories: categories,
        selected: _query.categoryId,
        lang: lang,
        onSelected: (id) =>
            setState(() => _query = _query.copyWith(categoryId: () => id)),
      ),
      if (articles.any((a) => a.isSample)) ...[
        const SizedBox(height: AppSpacing.space3),
        AppCard(
          key: const Key('newsMockNotice'),
          variant: AppCardVariant.gold,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.science_outlined, color: AppColors.gold800),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Text(
                  '${l10n.newsMockTitle}\n${l10n.newsMockMessage}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.gold800),
                ),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.space4),
    ];

    if (articles.isEmpty) {
      children.add(
        EmptyState(
          icon: Icons.newspaper_rounded,
          title: l10n.newsEmptyTitle,
          message: l10n.newsEmptyMessage,
        ),
      );
    } else if (_query.isFiltering) {
      final results = applyArticleQuery(articles, _query);
      children
        ..add(
          _ResultsHeader(
            count: results.length,
            sort: _query.sort,
            onSort: (s) => setState(() => _query = _query.copyWith(sort: s)),
            onClear: _clearAll,
          ),
        )
        ..add(const SizedBox(height: AppSpacing.space2));
      if (results.isEmpty) {
        children.add(
          EmptyState(
            icon: Icons.search_off_rounded,
            title: l10n.newsNoResultsTitle,
            message: l10n.newsNoResultsMessage,
            actionLabel: l10n.newsClearFilters,
            onAction: _clearAll,
          ),
        );
      } else {
        children.addAll(results.map(card));
      }
    } else {
      final newest = sortArticles(articles, ArticleSort.newest);
      final hero =
          newest.where((a) => a.isFeatured).firstOrNull ?? newest.first;
      final latest = newest.where((a) => a != hero).take(3).toList();
      final recommended = newest
          .where((a) => a.isFeatured && a != hero && !latest.contains(a))
          .toList();
      children
        ..add(
          FeaturedArticleCard(
            key: ValueKey('featured-${hero.id}'),
            article: hero,
            category: byId[hero.categoryId],
            lang: lang,
            onTap: () => _open(hero),
          ),
        )
        ..add(const SizedBox(height: AppSpacing.space5));
      if (latest.isNotEmpty) {
        children
          ..add(SectionHeader(title: l10n.newsLatest))
          ..addAll(latest.map(card));
      }
      if (recommended.isNotEmpty) {
        children
          ..add(const SizedBox(height: AppSpacing.space2))
          ..add(SectionHeader(title: l10n.newsRecommended))
          ..addAll(recommended.map(card));
      }
      children
        ..add(const SizedBox(height: AppSpacing.space2))
        ..add(SectionHeader(title: l10n.newsAllArticles))
        ..add(
          // Own line: long labels / large text never overflow.
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _SortButton(
              sort: _query.sort,
              onSort: (s) => setState(() => _query = _query.copyWith(sort: s)),
            ),
          ),
        )
        ..addAll(sortArticles(articles, _query.sort).map(card));
    }

    return ListView(
      key: const Key('newsList'),
      physics: const AlwaysScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: children,
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      key: const Key('newsSearchField'),
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: l10n.newsSearchHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                key: const Key('newsSearchClear'),
                tooltip: l10n.newsClearSearch,
                icon: const Icon(Icons.close_rounded),
                onPressed: onClear,
              ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.lang,
    required this.onSelected,
  });

  final List<ArticleCategory> categories;
  final String? selected;
  final String lang;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget chip(Key key, String label, String? id) => Padding(
      padding: const EdgeInsetsDirectional.only(end: AppSpacing.space2),
      child: ChoiceChip(
        key: key,
        label: Text(label),
        selected: selected == id,
        onSelected: (_) => onSelected(id),
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(const Key('category-all'), l10n.newsAllCategories, null),
          for (final c in categories)
            chip(ValueKey('category-${c.id}'), c.name.resolve(lang), c.id),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.sort, required this.onSort});

  final ArticleSort sort;
  final ValueChanged<ArticleSort> onSort;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(ArticleSort s) =>
        s == ArticleSort.newest ? l10n.newsSortNewest : l10n.newsSortOldest;
    return PopupMenuButton<ArticleSort>(
      key: const Key('newsSortButton'),
      initialValue: sort,
      onSelected: onSort,
      tooltip: label(sort),
      itemBuilder: (_) => [
        for (final s in ArticleSort.values)
          PopupMenuItem(
            key: ValueKey('sort-${s.name}'),
            value: s,
            child: Text(label(s)),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space2,
          vertical: AppSpacing.space3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: AppSpacing.space1),
            Flexible(
              child: Text(
                label(sort),
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.count,
    required this.sort,
    required this.onSort,
    required this.onClear,
  });

  final int count;
  final ArticleSort sort;
  final ValueChanged<ArticleSort> onSort;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpacing.space2,
      children: [
        Text(
          l10n.newsResultsCount(count),
          key: const Key('newsResultsCount'),
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _SortButton(sort: sort, onSort: onSort),
            TextButton(
              key: const Key('newsClearFilters'),
              onPressed: onClear,
              child: Text(l10n.newsClearFilters),
            ),
          ],
        ),
      ],
    );
  }
}
