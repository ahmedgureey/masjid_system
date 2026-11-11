import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../routing/app_routes.dart';
import '../application/article_share_service.dart';
import '../data/bookmarks_repository.dart';
import '../models/article.dart';

/// Bookmark toggle. Signed-out users get a message with a sign-in action
/// instead of a fake saved state.
class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.articleId, this.color});

  final String articleId;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final saved =
        ref
            .watch(bookmarksProvider)
            .value
            ?.any((b) => b.articleId == articleId) ??
        false;

    return IconButton(
      key: ValueKey('bookmark-$articleId'),
      tooltip: saved ? l10n.newsRemoveBookmark : l10n.newsBookmark,
      color: color,
      icon: Icon(
        saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
      ),
      onPressed: () => _toggle(context, ref),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (ref.read(bookmarkUserIdProvider) == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.newsBookmarkLoginRequired),
          action: SnackBarAction(
            label: l10n.newsSignIn,
            onPressed: () => context.push(AppRoutes.login),
          ),
        ),
      );
      return;
    }
    final now = ref.read(clockProvider).value ?? DateTime.now();
    try {
      final saved = await ref
          .read(bookmarksProvider.notifier)
          .toggle(articleId, now: now);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            saved ? l10n.newsBookmarkAdded : l10n.newsBookmarkRemoved,
          ),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(l10n.newsBookmarkError),
        ),
      );
    }
  }
}

/// Opens the system share sheet with the title, summary and (only when it
/// exists) the article's public URL.
class ShareArticleButton extends ConsumerWidget {
  const ShareArticleButton({
    super.key,
    required this.article,
    required this.lang,
  });

  final Article article;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return IconButton(
      key: const Key('articleShareButton'),
      tooltip: l10n.newsShare,
      icon: const Icon(Icons.share_outlined),
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          final outcome = await ref
              .read(articleShareServiceProvider)
              .share(
                subject: article.title.resolve(lang),
                text: articleShareText(article, lang),
              );
          if (outcome == ShareOutcome.unavailable) {
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.newsShareError)),
            );
          }
        } catch (_) {
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(l10n.newsShareError),
            ),
          );
        }
      },
    );
  }
}
