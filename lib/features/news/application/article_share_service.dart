import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/article.dart';

/// Text shared for [article]: title and summary, plus the public URL only
/// when the article really has one (URLs are never invented).
String articleShareText(Article article, String lang) {
  final parts = [
    article.title.resolve(lang),
    article.summary.resolve(lang),
    ?article.shareUrl,
  ].where((p) => p.trim().isNotEmpty);
  return parts.join('\n\n');
}

enum ShareOutcome { shared, dismissed, unavailable }

/// Sharing behind an interface so tests (and other platforms) can replace
/// the system share sheet.
abstract interface class ArticleShareService {
  Future<ShareOutcome> share({required String subject, required String text});
}

/// System share sheet through `share_plus`.
class SystemArticleShareService implements ArticleShareService {
  const SystemArticleShareService();

  @override
  Future<ShareOutcome> share({
    required String subject,
    required String text,
  }) async {
    final result = await SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
    return switch (result.status) {
      ShareResultStatus.success => ShareOutcome.shared,
      ShareResultStatus.dismissed => ShareOutcome.dismissed,
      ShareResultStatus.unavailable => ShareOutcome.unavailable,
    };
  }
}

final articleShareServiceProvider = Provider<ArticleShareService>(
  (ref) => const SystemArticleShareService(),
);
