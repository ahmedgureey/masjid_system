import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../data/articles_repository.dart';
import '../data/bookmarks_repository.dart';
import '../models/article.dart';
import '../models/article_category.dart';
import '../widgets/article_cards.dart';
import '../widgets/scrollable_state.dart';

/// "Maqaallada la keydiyay" — bookmarks of the signed-in user, stored on
/// this device only.
class SavedArticlesScreen extends ConsumerWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final signedIn = ref.watch(bookmarkUserIdProvider) != null;
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final articlesAsync = ref.watch(articlesProvider);

    Widget body() {
      if (!signedIn) {
        return EmptyState(
          icon: Icons.lock_outline_rounded,
          title: l10n.newsSaved,
          message: l10n.newsSavedSignedOut,
          actionLabel: l10n.newsSignIn,
          onAction: () => context.push(AppRoutes.login),
        );
      }
      if (bookmarksAsync.isLoading || articlesAsync.isLoading) {
        return const AppLoadingIndicator();
      }
      if (bookmarksAsync.hasError || articlesAsync.hasError) {
        return ErrorState(
          onRetry: () {
            ref.invalidate(bookmarksProvider);
            ref.invalidate(articlesProvider);
          },
        );
      }
      final bookmarks = bookmarksAsync.value ?? const [];
      if (bookmarks.isEmpty) {
        return EmptyState(
          icon: Icons.bookmark_border_rounded,
          title: l10n.newsSavedEmptyTitle,
          message: l10n.newsSavedEmptyMessage,
        );
      }
      return _SavedList(bookmarks: bookmarks);
    }

    return Scaffold(
      appBar: AppTopBar(title: l10n.newsSaved),
      body: SafeArea(
        top: false,
        child: switch (body()) {
          final _SavedList list => list,
          final state => ScrollableStateView(child: state),
        },
      ),
    );
  }
}

class _SavedList extends ConsumerWidget {
  const _SavedList({required this.bookmarks});

  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final lang = ref.watch(localeProvider).languageCode;
    final articles = {
      for (final a in ref.watch(articlesProvider).value ?? const <Article>[])
        a.id: a,
    };
    final categories = {
      for (final c
          in ref.watch(articleCategoriesProvider).value ??
              const <ArticleCategory>[])
        c.id: c,
    };

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        Text(
          l10n.newsSavedLocalNote,
          style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
        ),
        const SizedBox(height: AppSpacing.space3),
        for (final b in bookmarks)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.space3),
            child: switch (articles[b.articleId]) {
              final article? => ArticleCard(
                key: ValueKey('saved-${article.id}'),
                article: article,
                category: categories[article.categoryId],
                lang: lang,
                onTap: () =>
                    context.pushIfCurrent(AppRoutes.article(article.id)),
              ),
              // Unpublished/archived since it was saved.
              null => AppCard(
                key: ValueKey('saved-missing-${b.articleId}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.neutral500,
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(child: Text(l10n.newsUnavailable)),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () => ref
                            .read(bookmarksProvider.notifier)
                            .toggle(
                              b.articleId,
                              now:
                                  ref.read(clockProvider).value ??
                                  DateTime.now(),
                            ),
                        child: Text(l10n.newsRemoveBookmark),
                      ),
                    ),
                  ],
                ),
              ),
            },
          ),
      ],
    );
  }
}
