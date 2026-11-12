import '../../../models/localized_text.dart';
import '../models/article.dart';

/// Maps [Article] to and from the JSON stored on the device.
///
/// Key names follow the future `islamic_articles` columns, and the body is
/// the same list-of-blocks shape that column would hold as `jsonb`, so this
/// collection can move to Supabase without the stored documents changing.
///
/// Reading is forgiving on purpose: a row written by a newer build, or one
/// damaged by a half-finished write, costs the user that article at worst,
/// never the ability to open the news screen. [fromJson] returns null for
/// anything unusable and callers drop it.
abstract final class ArticleJson {
  static Map<String, dynamic> toJson(Article a) => {
    'id': a.id,
    'mosque_id': a.mosqueId,
    'slug': a.slug,
    'title': a.title.toJson(),
    'summary': a.summary.toJson(),
    'body': a.body.map(_blockTo).toList(),
    'cover_image_url': a.coverImageUrl,
    'category_id': a.categoryId,
    'author_id': a.authorId,
    'author_name': a.authorName,
    'status': a.status.name,
    'is_featured': a.isFeatured,
    'published_at': a.publishedAt?.toIso8601String(),
    'created_at': a.createdAt.toIso8601String(),
    'updated_at': a.updatedAt?.toIso8601String(),
    'source_references': [
      for (final s in a.sourceReferences) {'title': s.title, 'url': s.url},
    ],
    'share_url': a.shareUrl,
    'is_sample': a.isSample,
  };

  static Article? fromJson(Map<String, dynamic> row) {
    final id = row['id'];
    if (id is! String || id.isEmpty) return null;

    return Article(
      id: id,
      mosqueId: _string(row['mosque_id']) ?? '',
      slug: _string(row['slug']),
      title: _text(row['title']) ?? const LocalizedText({}),
      summary: _text(row['summary']) ?? const LocalizedText({}),
      body: _body(row['body']),
      coverImageUrl: _string(row['cover_image_url']),
      categoryId: _string(row['category_id']) ?? '',
      authorId: _string(row['author_id']),
      authorName: _string(row['author_name']),
      status: _enum(ArticleStatus.values, row['status']) ??
          ArticleStatus.draft,
      isFeatured: row['is_featured'] == true,
      publishedAt: _date(row['published_at']),
      // An article with no readable created_at still has to sort somewhere;
      // the publication time, then the epoch, keeps it last rather than
      // dropping it.
      createdAt: _date(row['created_at']) ??
          _date(row['published_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _date(row['updated_at']),
      sourceReferences: _sources(row['source_references']),
      shareUrl: _string(row['share_url']),
      isSample: row['is_sample'] == true,
    );
  }

  static List<Article> listFrom(Iterable<Map<String, dynamic>> rows) =>
      rows.map(fromJson).whereType<Article>().toList();

  static List<Map<String, dynamic>> listTo(Iterable<Article> articles) =>
      articles.map(toJson).toList();

  // ---------------------------------------------------------------------------
  // Body blocks
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _blockTo(ArticleBlock b) => switch (b) {
    ParagraphBlock(:final text) => {
      'type': 'paragraph',
      'text': text.toJson(),
    },
    HeadingBlock(:final text) => {'type': 'heading', 'text': text.toJson()},
    ImageBlock(:final url, :final caption) => {
      'type': 'image',
      'url': url,
      'caption': caption?.toJson(),
    },
    QuoteBlock(:final text, :final source) => {
      'type': 'quote',
      'text': text.toJson(),
      'source': source,
    },
  };

  static List<ArticleBlock> _body(Object? value) {
    if (value is! List) return const [];
    final blocks = <ArticleBlock>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final row = Map<String, dynamic>.from(entry);
      final text = _text(row['text']);
      switch (row['type']) {
        case 'paragraph':
          if (text != null) blocks.add(ParagraphBlock(text));
        case 'heading':
          if (text != null) blocks.add(HeadingBlock(text));
        case 'image':
          final url = _string(row['url']);
          if (url != null && url.isNotEmpty) {
            blocks.add(ImageBlock(url: url, caption: _text(row['caption'])));
          }
        case 'quote':
          // A quote without its source is never rendered, so storing one
          // back would only produce an invisible block. Drop it instead.
          final source = _string(row['source']);
          if (text != null && source != null && source.trim().isNotEmpty) {
            blocks.add(QuoteBlock(text: text, source: source));
          }
      }
    }
    return blocks;
  }

  static List<SourceReference> _sources(Object? value) {
    if (value is! List) return const [];
    final sources = <SourceReference>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final title = _string(entry['title']);
      if (title == null || title.trim().isEmpty) continue;
      sources.add(SourceReference(title: title, url: _string(entry['url'])));
    }
    return sources;
  }

  // ---------------------------------------------------------------------------
  // Primitives
  // ---------------------------------------------------------------------------

  static String? _string(Object? v) => v is String ? v : null;

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v) : null;

  static LocalizedText? _text(Object? v) =>
      v is Map ? LocalizedText.fromJson(Map<String, dynamic>.from(v)) : null;

  static T? _enum<T extends Enum>(List<T> values, Object? v) {
    if (v is! String) return null;
    for (final value in values) {
      if (value.name == v) return value;
    }
    return null;
  }
}
