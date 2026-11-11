import 'package:flutter/foundation.dart';

import '../models/article.dart';

enum ArticleSort { newest, oldest }

/// Search text + category + sort chosen on the news screen.
@immutable
class ArticleQuery {
  const ArticleQuery({
    this.text = '',
    this.categoryId,
    this.sort = ArticleSort.newest,
  });

  final String text;

  /// Null → all categories.
  final String? categoryId;
  final ArticleSort sort;

  /// True when the user searched or picked a category (results view).
  bool get isFiltering =>
      normalizeSearch(text).isNotEmpty || categoryId != null;

  ArticleQuery copyWith({
    String? text,
    String? Function()? categoryId,
    ArticleSort? sort,
  }) => ArticleQuery(
    text: text ?? this.text,
    categoryId: categoryId != null ? categoryId() : this.categoryId,
    sort: sort ?? this.sort,
  );
}

final RegExp _arabicMarks = RegExp('[ً-ٰٟـ]');
final RegExp _spaces = RegExp(r'\s+');

/// Lower-case, trimmed, single spaces, Arabic diacritics and tatweel
/// removed. Plain string operations only (no user regex), so any input is
/// safe.
String normalizeSearch(String input) => input
    .toLowerCase()
    .replaceAll(_arabicMarks, '')
    .replaceAll(_spaces, ' ')
    .trim();

/// True when every search word appears in the title, summary or body (any
/// language).
bool articleMatchesText(Article article, String text) {
  final terms = normalizeSearch(text).split(' ').where((t) => t.isNotEmpty);
  if (terms.isEmpty) return true;
  final haystack = normalizeSearch(
    [
      ...article.title.values.values,
      ...article.summary.values.values,
      for (final lang in {'so', 'en', 'ar', ...article.title.values.keys})
        article.bodyText(lang),
    ].join(' '),
  );
  return terms.every(haystack.contains);
}

DateTime _date(Article a) => a.publishedAt ?? a.createdAt;

/// Articles sorted by publication date.
List<Article> sortArticles(Iterable<Article> articles, ArticleSort sort) {
  final list = articles.toList()
    ..sort(
      (a, b) => sort == ArticleSort.newest
          ? _date(b).compareTo(_date(a))
          : _date(a).compareTo(_date(b)),
    );
  return list;
}

/// Pure list logic of the news screen.
List<Article> applyArticleQuery(Iterable<Article> articles, ArticleQuery q) =>
    sortArticles(
      articles.where(
        (a) =>
            (q.categoryId == null || a.categoryId == q.categoryId) &&
            articleMatchesText(a, q.text),
      ),
      q.sort,
    );

/// Up to [limit] articles related to [article]: same category first (newest
/// first), then the newest others.
List<Article> relatedArticles(
  Article article,
  Iterable<Article> all, {
  int limit = 3,
}) {
  final others = all.where((a) => a.id != article.id);
  return [
    ...sortArticles(
      others.where((a) => a.categoryId == article.categoryId),
      ArticleSort.newest,
    ),
    ...sortArticles(
      others.where((a) => a.categoryId != article.categoryId),
      ArticleSort.newest,
    ),
  ].take(limit).toList();
}

/// Estimated reading time at 200 words per minute, at least one minute.
int readingMinutes(Article article, String lang) {
  final words = '${article.title.resolve(lang)} ${article.bodyText(lang)}'
      .split(_spaces)
      .where((w) => w.isNotEmpty)
      .length;
  return (words / 200).ceil().clamp(1, 999);
}

/// Whether [text] should be laid out right-to-left: the first strong
/// letter is Arabic-script.
bool isRtlText(String text) {
  for (final rune in text.runes) {
    if ((rune >= 0x0600 && rune <= 0x06FF) ||
        (rune >= 0x0750 && rune <= 0x077F) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF)) {
      return true;
    }
    final isLatinLetter =
        (rune >= 0x41 && rune <= 0x5A) ||
        (rune >= 0x61 && rune <= 0x7A) ||
        (rune >= 0xC0 && rune <= 0x24F);
    if (isLatinLetter) return false;
  }
  return false;
}

/// Whether [text] contains a Latin letter (used to lay out Latin content
/// left-to-right inside the Arabic UI).
bool hasLatinLetter(String text) => RegExp('[A-Za-zÀ-ɏ]').hasMatch(text);
