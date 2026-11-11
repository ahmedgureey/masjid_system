import 'package:flutter/foundation.dart';

import '../../../models/localized_text.dart';

/// Publication state (mirrors `islamic_articles.status`). Only [published]
/// articles with a past `publishedAt` are ever shown to the public.
enum ArticleStatus { draft, published, archived }

/// One block of an article body. A structured list (stored as `jsonb`
/// later) instead of Markdown: no extra dependency, and inline images and
/// sourced quotes are explicit.
@immutable
sealed class ArticleBlock {
  const ArticleBlock();
}

class ParagraphBlock extends ArticleBlock {
  const ParagraphBlock(this.text);
  final LocalizedText text;
}

class HeadingBlock extends ArticleBlock {
  const HeadingBlock(this.text);
  final LocalizedText text;
}

class ImageBlock extends ArticleBlock {
  const ImageBlock({required this.url, this.caption});
  final String url;
  final LocalizedText? caption;
}

/// A quotation. [source] is required: quotes without a verifiable source
/// are not rendered (religious content must be supplied with its source).
class QuoteBlock extends ArticleBlock {
  const QuoteBlock({required this.text, required this.source});
  final LocalizedText text;
  final String source;
}

/// A reference supplied by the author. [url] is shown only when given.
@immutable
class SourceReference {
  const SourceReference({required this.title, this.url});
  final String title;
  final String? url;
}

/// A news item or article (mirrors the future `islamic_articles` table).
@immutable
class Article {
  const Article({
    required this.id,
    required this.mosqueId,
    this.slug,
    required this.title,
    required this.summary,
    required this.body,
    this.coverImageUrl,
    required this.categoryId,
    this.authorId,
    this.authorName,
    required this.status,
    this.isFeatured = false,
    this.publishedAt,
    required this.createdAt,
    this.updatedAt,
    this.sourceReferences = const [],
    this.shareUrl,
    this.isSample = false,
  });

  final String id;
  final String mosqueId;
  final String? slug;
  final LocalizedText title;
  final LocalizedText summary;
  final List<ArticleBlock> body;
  final String? coverImageUrl;
  final String categoryId;
  final String? authorId;

  /// Display name of the author; when null the publishing mosque is shown.
  final String? authorName;
  final ArticleStatus status;
  final bool isFeatured;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<SourceReference> sourceReferences;

  /// Public web address of the article. Null until articles have real
  /// public pages — never generated.
  final String? shareUrl;

  /// Clearly identified mock data.
  final bool isSample;

  /// Public only when explicitly published and the publication time passed
  /// (scheduled articles stay hidden until then).
  bool isPubliclyVisibleAt(DateTime now) =>
      status == ArticleStatus.published &&
      publishedAt != null &&
      !publishedAt!.isAfter(now);

  /// All plain text of the body in [lang] (used for search and reading time).
  String bodyText(String lang) => [
    for (final block in body)
      switch (block) {
        ParagraphBlock(:final text) => text.resolve(lang),
        HeadingBlock(:final text) => text.resolve(lang),
        QuoteBlock(:final text) => text.resolve(lang),
        ImageBlock(:final caption) => caption?.resolve(lang) ?? '',
      },
  ].join('\n');
}
