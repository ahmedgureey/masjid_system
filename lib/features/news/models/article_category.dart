import 'package:flutter/foundation.dart';

import '../../../models/localized_text.dart';

/// Article category (mirrors `article_categories`). Names are data
/// (`{"so","ar","en"}`) so administrators can add or rename categories
/// without an app release.
@immutable
class ArticleCategory {
  const ArticleCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.displayOrder,
    this.isActive = true,
  });

  final String id;
  final LocalizedText name;
  final String slug;
  final int displayOrder;
  final bool isActive;
}

/// Saved article of one user (mirrors `article_bookmarks`).
@immutable
class Bookmark {
  const Bookmark({
    required this.userId,
    required this.articleId,
    required this.createdAt,
  });

  final String userId;
  final String articleId;
  final DateTime createdAt;

  Map<String, Object> toJson() => {
    'articleId': articleId,
    'createdAt': createdAt.toIso8601String(),
  };

  static Bookmark? fromJson(String userId, Object? json) {
    if (json is! Map) return null;
    final id = json['articleId'];
    final created = DateTime.tryParse('${json['createdAt']}');
    if (id is! String || created == null) return null;
    return Bookmark(userId: userId, articleId: id, createdAt: created);
  }
}
