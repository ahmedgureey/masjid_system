import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/local_storage_service.dart';
import '../../authentication/application/demo_session_provider.dart';
import '../models/article_category.dart';

/// Saved articles of a user.
///
/// Today: [LocalBookmarksRepository] — stored on THIS DEVICE only
/// (shared_preferences), not synchronised across devices.
/// Supabase phase: an `article_bookmarks` table (unique user_id +
/// article_id, RLS `user_id = auth.uid()`).
abstract interface class BookmarksRepository {
  Future<List<Bookmark>> getBookmarks(String userId);
  Future<void> add(Bookmark bookmark);
  Future<void> remove(String userId, String articleId);
}

class LocalBookmarksRepository implements BookmarksRepository {
  LocalBookmarksRepository(this._prefs);

  final SharedPreferences _prefs;

  static String _key(String userId) => 'bookmarks.$userId';

  @override
  Future<List<Bookmark>> getBookmarks(String userId) async {
    final raw = _prefs.getString(_key(userId));
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return list.map((e) => Bookmark.fromJson(userId, e)).nonNulls.toList();
    } on FormatException {
      return const []; // corrupt data is ignored, never crashes the app
    }
  }

  Future<void> _write(String userId, List<Bookmark> list) => _prefs.setString(
    _key(userId),
    jsonEncode([for (final b in list) b.toJson()]),
  );

  @override
  Future<void> add(Bookmark bookmark) async {
    final list = await getBookmarks(bookmark.userId);
    if (list.any((b) => b.articleId == bookmark.articleId)) return;
    await _write(bookmark.userId, [...list, bookmark]);
  }

  @override
  Future<void> remove(String userId, String articleId) async {
    final list = await getBookmarks(userId);
    await _write(userId, [
      for (final b in list)
        if (b.articleId != articleId) b,
    ]);
  }
}

final bookmarksRepositoryProvider = Provider<BookmarksRepository>(
  (ref) => LocalBookmarksRepository(ref.watch(sharedPreferencesProvider)),
);

/// Current user id for bookmarks. DEMO: the demo session has no id, so its
/// display name is used; replaced by `auth.uid()` with Supabase.
final bookmarkUserIdProvider = Provider<String?>(
  (ref) => ref.watch(demoSessionProvider)?.userId,
);

/// Bookmarks of the signed-in user, newest first; empty when signed out.
final bookmarksProvider =
    AsyncNotifierProvider<BookmarksController, List<Bookmark>>(
      BookmarksController.new,
    );

class BookmarksController extends AsyncNotifier<List<Bookmark>> {
  @override
  Future<List<Bookmark>> build() async {
    final userId = ref.watch(bookmarkUserIdProvider);
    if (userId == null) return const [];
    final list = await ref
        .read(bookmarksRepositoryProvider)
        .getBookmarks(userId);
    return [...list]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  bool isBookmarked(String articleId) =>
      state.value?.any((b) => b.articleId == articleId) ?? false;

  /// Adds or removes [articleId]. Returns the new state (true = saved).
  /// Throws [StateError] when nobody is signed in.
  Future<bool> toggle(String articleId, {required DateTime now}) async {
    final userId = ref.read(bookmarkUserIdProvider);
    if (userId == null) throw StateError('Sign in to bookmark articles.');
    final repo = ref.read(bookmarksRepositoryProvider);
    final current = [...?state.value];
    if (current.any((b) => b.articleId == articleId)) {
      await repo.remove(userId, articleId);
      state = AsyncData([
        for (final b in current)
          if (b.articleId != articleId) b,
      ]);
      return false;
    }
    final bookmark = Bookmark(
      userId: userId,
      articleId: articleId,
      createdAt: now,
    );
    await repo.add(bookmark);
    state = AsyncData([bookmark, ...current]);
    return true;
  }
}
