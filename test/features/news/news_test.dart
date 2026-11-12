import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/widgets/widgets.dart';
import 'package:masjid_management/features/news/application/article_query.dart';
import 'package:masjid_management/features/news/application/article_share_service.dart';
import 'package:masjid_management/features/news/data/articles_repository.dart';
import 'package:masjid_management/features/news/data/bookmarks_repository.dart';
import 'package:masjid_management/features/news/models/article.dart';
import 'package:masjid_management/features/news/models/article_category.dart';
import 'package:masjid_management/features/news/screens/article_details_screen.dart';
import 'package:masjid_management/features/news/screens/news_screen.dart';
import 'package:masjid_management/features/news/screens/saved_articles_screen.dart';
import 'package:masjid_management/features/news/widgets/article_cards.dart';
import 'package:masjid_management/models/localized_text.dart';
import 'package:masjid_management/routing/app_router.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_app.dart';

// Visible samples (newest first, relative to testNow): evening-classes (1d,
// featured) · cleaning (2d) · classroom (3d, featured) · parents (5d) ·
// renovation (8d, featured) · community (12d) · long (20d) · arabic (25d).
// Hidden: draft, archived, scheduled (+3d), other mosque.
const _evening = 'TUSAALE: Barnaamijka casharrada fiidkii';

LocalArticlesRepository _repo({List<Article>? articles}) =>
    LocalArticlesRepository(
      seedDate: testNow,
      now: () => testNow,
      latency: Duration.zero,
      articles: articles,
    );

/// Wraps a repository to count calls, delay, or fail the first calls.
class _FakeRepo implements ArticlesRepository {
  _FakeRepo({this.failures = 0, this.delay = Duration.zero});

  final LocalArticlesRepository inner = _repo();
  int failures;
  final Duration delay;
  int calls = 0;

  @override
  Future<List<Article>> getPublishedArticles({required String mosqueId}) async {
    calls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failures > 0) {
      failures--;
      throw Exception('network');
    }
    return inner.getPublishedArticles(mosqueId: mosqueId);
  }

  @override
  Future<List<Article>> getAllArticles({required String mosqueId}) async {
    calls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failures > 0) {
      failures--;
      throw Exception('network');
    }
    return inner.getAllArticles(mosqueId: mosqueId);
  }

  @override
  Future<Article> saveArticle(Article article) => inner.saveArticle(article);

  @override
  Future<void> deleteArticle(String id) => inner.deleteArticle(id);

  @override
  Future<List<ArticleCategory>> getCategories() => inner.getCategories();
}

class _FakeShare implements ArticleShareService {
  _FakeShare([this.outcome = ShareOutcome.shared]);

  final ShareOutcome outcome;
  String? subject;
  String? text;

  @override
  Future<ShareOutcome> share({
    required String subject,
    required String text,
  }) async {
    this.subject = subject;
    this.text = text;
    return outcome;
  }
}

Future<SharedPreferences> _openNews(
  WidgetTester tester, {
  String locale = 'so',
  Size size = const Size(400, 2400),
  double scale = 1.0,
  String? userId,
  ArticlesRepository? repo,
  ArticleShareService? share,
  Map<String, Object> prefs = const {},
}) async {
  final instance = await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale, ...prefs},
    surfaceSize: size,
    textScale: scale,
    overrides: [
      articlesRepositoryProvider.overrideWithValue(repo ?? _repo()),
      bookmarkUserIdProvider.overrideWithValue(userId),
      articleShareServiceProvider.overrideWithValue(share ?? _FakeShare()),
    ],
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.news);
  expect(find.byType(NewsScreen), findsOneWidget);
  return instance;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

String _resultsCount(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('newsResultsCount'))).data!;

void main() {
  final samples = LocalArticlesRepository.sampleArticles(testNow);
  final visible = samples
      .where((a) => a.isPubliclyVisibleAt(testNow))
      .where((a) => a.mosqueId == LocalArticlesRepository.sampleMosqueId);
  Article byId(String id) => samples.firstWhere((a) => a.id == id);

  group('Visibility (multi-mosque, publication state)', () {
    test('only published, past, same-mosque articles are returned', () async {
      final list = await _repo().getPublishedArticles(mosqueId: 'al-ikhlas');
      final ids = list.map((a) => a.id).toSet();
      expect(ids.length, 8);
      expect(ids, isNot(contains('sample-draft')));
      expect(ids, isNot(contains('sample-archived')));
      expect(ids, isNot(contains('sample-scheduled')));
      expect(ids, isNot(contains('sample-other-mosque')));
      expect(list.every((a) => a.isSample), isTrue);
    });

    test('scheduled article appears after its publication time', () async {
      final later = LocalArticlesRepository(
        seedDate: testNow,
        now: () => testNow.add(const Duration(days: 4)),
        latency: Duration.zero,
      );
      final ids = (await later.getPublishedArticles(mosqueId: 'al-ikhlas'))
          .map((a) => a.id);
      expect(ids, contains('sample-scheduled'));
    });

    test('another mosque sees only its own articles', () async {
      final list = await _repo().getPublishedArticles(mosqueId: 'other-mosque');
      expect(list.map((a) => a.id), ['sample-other-mosque']);
    });

    test('inactive categories are hidden and order is kept', () async {
      final repo = LocalArticlesRepository(
        seedDate: testNow,
        latency: Duration.zero,
        categories: const [
          ArticleCategory(
            id: 'b',
            name: LocalizedText({'so': 'B'}),
            slug: 'b',
            displayOrder: 2,
          ),
          ArticleCategory(
            id: 'a',
            name: LocalizedText({'so': 'A'}),
            slug: 'a',
            displayOrder: 1,
          ),
          ArticleCategory(
            id: 'c',
            name: LocalizedText({'so': 'C'}),
            slug: 'c',
            displayOrder: 0,
            isActive: false,
          ),
        ],
      );
      expect((await repo.getCategories()).map((c) => c.id), ['a', 'b']);
    });
  });

  group('Search, filters and helpers (pure)', () {
    List<String> ids(ArticleQuery q) =>
        applyArticleQuery(visible, q).map((a) => a.id).toList();

    test('search is case-insensitive and covers title, summary and body', () {
      expect(ids(const ArticleQuery(text: 'BARNAAMIJKA casharrada')), [
        'sample-evening-classes',
      ]);
      // Word only in the long article's body.
      expect(ids(const ArticleQuery(text: 'placeholder')), ['sample-long']);
      // Summary.
      expect(ids(const ArticleQuery(text: 'mutadawacnimada')), [
        'sample-community',
      ]);
    });

    test('Arabic search ignores diacritics', () {
      expect(ids(const ArticleQuery(text: 'إعلان')), ['sample-arabic']);
      expect(ids(const ArticleQuery(text: 'إِعْلَان')), ['sample-arabic']);
    });

    test('empty, whitespace and special input never crash', () {
      expect(ids(const ArticleQuery(text: '')).length, 8);
      expect(ids(const ArticleQuery(text: '   ')).length, 8);
      expect(() => ids(const ArticleQuery(text: r'(*[\\?+')), returnsNormally);
      expect(ids(const ArticleQuery(text: 'zzzzqqq')), isEmpty);
      expect(const ArticleQuery(text: '  ').isFiltering, isFalse);
    });

    test('category filter and sorting', () {
      expect(ids(const ArticleQuery(categoryId: 'announcements')), [
        'sample-cleaning',
        'sample-arabic',
      ]);
      expect(
        ids(
          const ArticleQuery(
            categoryId: 'announcements',
            sort: ArticleSort.oldest,
          ),
        ),
        ['sample-arabic', 'sample-cleaning'],
      );
      expect(ids(const ArticleQuery(categoryId: 'quran-sunnah')), isEmpty);
    });

    test('related articles: same category first, never itself', () {
      final related = relatedArticles(byId('sample-cleaning'), visible);
      expect(related.first.id, 'sample-arabic');
      expect(related.map((a) => a.id), isNot(contains('sample-cleaning')));
      expect(related.length, 3);
    });

    test('reading time', () {
      expect(readingMinutes(byId('sample-cleaning'), 'so'), 1);
      expect(readingMinutes(byId('sample-long'), 'so'), greaterThan(1));
    });

    test('text direction detection', () {
      expect(isRtlText('هذه فقرة'), isTrue);
      expect(isRtlText('  123 هذه'), isTrue);
      expect(isRtlText('Masjid مسجد'), isFalse);
      expect(isRtlText(''), isFalse);
    });

    test('share text never contains an invented URL', () {
      final article = byId('sample-evening-classes');
      final text = articleShareText(article, 'so');
      expect(text, contains(_evening));
      expect(text, isNot(contains('http')));
      final withUrl = Article(
        id: 'x',
        mosqueId: 'm',
        title: const LocalizedText({'so': 'T'}),
        summary: const LocalizedText({'so': 'S'}),
        body: const [],
        categoryId: 'c',
        status: ArticleStatus.published,
        createdAt: testNow,
        shareUrl: 'https://example.org/a',
      );
      expect(
        articleShareText(withUrl, 'so'),
        'T\n\nS\n\nhttps://example.org/a',
      );
    });
  });

  group('Bookmarks repository (device-local)', () {
    test('add, remove, per-user separation, corrupt data', () async {
      SharedPreferences.setMockInitialValues({'bookmarks.bad': '{oops'});
      final prefs = await SharedPreferences.getInstance();
      final repo = LocalBookmarksRepository(prefs);
      await repo.add(
        Bookmark(userId: 'u1', articleId: 'a', createdAt: testNow),
      );
      await repo.add(
        Bookmark(userId: 'u1', articleId: 'a', createdAt: testNow),
      );
      await repo.add(
        Bookmark(userId: 'u2', articleId: 'b', createdAt: testNow),
      );
      expect((await repo.getBookmarks('u1')).map((b) => b.articleId), ['a']);
      expect((await repo.getBookmarks('u2')).map((b) => b.articleId), ['b']);
      await repo.remove('u1', 'a');
      expect(await repo.getBookmarks('u1'), isEmpty);
      expect(await repo.getBookmarks('bad'), isEmpty);
    });
  });

  group('NewsScreen', () {
    testWidgets('renders featured, sections, chips and mock notice', (
      tester,
    ) async {
      await _openNews(tester);
      expect(find.text('Wararka & Maqaallada'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('featured-sample-evening-classes')),
        findsOneWidget,
      );
      expect(find.text('La soo xulay'), findsOneWidget);
      expect(find.text('Wararkii ugu dambeeyay'), findsOneWidget);
      expect(find.text('La soo jeediyay'), findsOneWidget);
      expect(find.text('Dhammaan maqaallada'), findsOneWidget);
      expect(find.byKey(const Key('newsMockNotice')), findsOneWidget);
      expect(find.byKey(const Key('category-announcements')), findsOneWidget);
      expect(find.text('TUSAALE: Qabyo (draft)'), findsNothing);
      expect(find.text('TUSAALE: War masaajid kale'), findsNothing);
      expect(find.textContaining('daqiiqo akhris'), findsWidgets);
    });

    testWidgets('category filter shows matching articles', (tester) async {
      await _openNews(tester);
      await _tap(tester, find.byKey(const ValueKey('category-projects')));
      expect(_resultsCount(tester), '1 natiijo');
      expect(
        find.byKey(const ValueKey('article-sample-renovation')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('featured-sample-evening-classes')),
        findsNothing,
      );

      await _tap(tester, find.byKey(const Key('category-all')));
      expect(
        find.byKey(const ValueKey('featured-sample-evening-classes')),
        findsOneWidget,
      );
    });

    testWidgets('search, clear search and no-results message', (tester) async {
      await _openNews(tester);
      await tester.enterText(
        find.byKey(const Key('newsSearchField')),
        'PLACEHOLDER',
      );
      await tester.pumpAndSettle();
      expect(_resultsCount(tester), '1 natiijo');
      expect(find.byKey(const ValueKey('article-sample-long')), findsOneWidget);

      await tester.tap(find.byKey(const Key('newsSearchClear')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('newsResultsCount')), findsNothing);

      await tester.enterText(
        find.byKey(const Key('newsSearchField')),
        'zzzqqq',
      );
      await tester.pumpAndSettle();
      expect(find.text('Maqaal lama helin'), findsOneWidget);
      await _tap(tester, find.widgetWithText(AppButton, 'Tirtir shaandhada'));
      expect(find.text('Maqaal lama helin'), findsNothing);
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('newsSearchField')))
            .controller!
            .text,
        isEmpty,
      );
    });

    testWidgets('sort newest / oldest', (tester) async {
      await _openNews(tester);
      await _tap(tester, find.byKey(const ValueKey('category-announcements')));
      double y(String id) =>
          tester.getTopLeft(find.byKey(ValueKey('article-$id'))).dy;
      expect(y('sample-cleaning'), lessThan(y('sample-arabic')));

      await _tap(tester, find.byKey(const Key('newsSortButton')));
      await _tap(tester, find.text('Ugu da’sanaa').last);
      expect(y('sample-arabic'), lessThan(y('sample-cleaning')));
    });

    testWidgets('shows a loading indicator while fetching', (tester) async {
      final repo = _FakeRepo(delay: const Duration(seconds: 2));
      await pumpFullApp(
        tester,
        prefs: {localeCodeKey: 'so'},
        overrides: [articlesRepositoryProvider.overrideWithValue(repo)],
      );
      await passSplash(tester);
      ProviderScope.containerOf(tester.element(find.byType(MasjidApp)))
          .read(appRouterProvider)
          .go(AppRoutes.news);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(AppLoadingIndicator), findsNothing);
      expect(
        find.byKey(const ValueKey('featured-sample-evening-classes')),
        findsOneWidget,
      );
    });

    testWidgets('error state with working retry', (tester) async {
      // Riverpod retries failed providers automatically, so keep failing
      // until the user taps retry.
      final repo = _FakeRepo(failures: 1000);
      await _openNews(tester, repo: repo);
      expect(find.byType(ErrorState), findsOneWidget);
      repo.failures = 0;
      await _tap(
        tester,
        find.descendant(
          of: find.byType(ErrorState),
          matching: find.byType(AppButton),
        ),
      );
      expect(find.byType(ErrorState), findsNothing);
      expect(
        find.byKey(const ValueKey('featured-sample-evening-classes')),
        findsOneWidget,
      );
    });

    testWidgets('empty state when nothing is published', (tester) async {
      await _openNews(tester, repo: _repo(articles: const []));
      expect(find.text('Weli maqaal lama daabicin'), findsOneWidget);
      expect(find.byKey(const Key('newsMockNotice')), findsNothing);
    });

    testWidgets('pull to refresh reloads articles', (tester) async {
      final repo = _FakeRepo();
      // Phone-sized viewport: the pull distance needed scales with its height.
      await _openNews(tester, repo: repo, size: const Size(400, 800));
      final before = repo.calls;
      await tester.fling(
        find.byKey(const Key('newsList')),
        const Offset(0, 500),
        1500,
      );
      await tester.pumpAndSettle();
      expect(repo.calls, greaterThan(before));
    });
  });

  group('ArticleDetailsScreen', () {
    testWidgets('opens from the featured card with all details', (
      tester,
    ) async {
      await _openNews(tester);
      await _tap(
        tester,
        find.byKey(const ValueKey('featured-sample-evening-classes')),
      );
      expect(find.byType(ArticleDetailsScreen), findsOneWidget);
      expect(
        tester
            .widget<DirectionalText>(find.byKey(const Key('articleTitle')))
            .text,
        _evening,
      );
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget); // publisher
      expect(find.textContaining('La daabacay'), findsOneWidget);
      expect(find.textContaining('La cusbooneysiiyay'), findsOneWidget);
      expect(find.text('Tixraacyada'), findsOneWidget);
      expect(
        find.text('• Tusaale: warbixinta guddiga masaajidka'),
        findsOneWidget,
      );
      expect(find.text('Maqaallo la xiriira'), findsOneWidget);

      // Related article opens another details page; back returns.
      final related = find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('related-'),
      );
      await _tap(tester, related.first);
      expect(find.byType(ArticleDetailsScreen), findsNWidgets(1));
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<DirectionalText>(find.byKey(const Key('articleTitle')))
            .text,
        _evening,
      );
    });

    testWidgets('drafts and unknown ids are not reachable', (tester) async {
      await _openNews(tester);
      await goTo(tester, AppRoutes.article('sample-draft'));
      expect(find.text('Maqaalkan lama helin.'), findsOneWidget);
      await goTo(tester, AppRoutes.article('nope'));
      expect(find.text('Maqaalkan lama helin.'), findsOneWidget);
    });

    testWidgets('share sends title and summary only (no fake URL)', (
      tester,
    ) async {
      final share = _FakeShare();
      await _openNews(tester, share: share);
      await goTo(tester, AppRoutes.article('sample-evening-classes'));
      await tester.tap(find.byKey(const Key('articleShareButton')));
      await tester.pumpAndSettle();
      expect(share.subject, _evening);
      expect(share.text, contains(_evening));
      expect(share.text, isNot(contains('http')));
    });

    testWidgets('unavailable share shows a message', (tester) async {
      await _openNews(tester, share: _FakeShare(ShareOutcome.unavailable));
      await goTo(tester, AppRoutes.article('sample-cleaning'));
      await tester.tap(find.byKey(const Key('articleShareButton')));
      await tester.pump();
      expect(find.text('Wadaagistu hadda ma shaqaynayso.'), findsOneWidget);
    });

    testWidgets('Arabic paragraph is right-to-left inside a Somali UI', (
      tester,
    ) async {
      await _openNews(tester);
      await goTo(tester, AppRoutes.article('sample-arabic'));
      final paragraph = find.textContaining('هذه فقرة تجريبية');
      expect(paragraph, findsOneWidget);
      expect(tester.widget<Text>(paragraph).textDirection, TextDirection.rtl);
      expect(find.text('TUSAALE: Ogeysiis Carabi ah'), findsOneWidget);
    });

    testWidgets('Arabic UI shows Arabic title', (tester) async {
      await _openNews(tester, locale: 'ar');
      await goTo(tester, AppRoutes.article('sample-arabic'));
      expect(find.text('تجريبي: إعلان باللغة العربية'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('long article scrolls to the end without errors', (
      tester,
    ) async {
      await _openNews(tester, size: const Size(360, 640));
      await goTo(tester, AppRoutes.article('sample-long'));
      await tester.scrollUntilVisible(
        find.text('Maqaallo la xiriira'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Qaybta 6 (tusaale)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('quote without a source is not rendered', (tester) async {
      final article = Article(
        id: 'q',
        mosqueId: 'al-ikhlas',
        title: LocalizedText.all('Quote test'),
        summary: LocalizedText.all('S'),
        body: const [
          QuoteBlock(
            text: LocalizedText({'so': 'Unsourced quote'}),
            source: ' ',
          ),
          QuoteBlock(
            text: LocalizedText({'so': 'Sourced quote'}),
            source: 'Src',
          ),
        ],
        categoryId: 'community',
        status: ArticleStatus.published,
        publishedAt: testNow,
        createdAt: testNow,
      );
      await _openNews(tester, repo: _repo(articles: [article]));
      await goTo(tester, AppRoutes.article('q'));
      expect(find.text('Unsourced quote'), findsNothing);
      expect(find.text('Sourced quote'), findsOneWidget);
      expect(find.text('— Src'), findsOneWidget);
    });
  });

  group('Bookmarks UI', () {
    testWidgets('signed out: bookmark asks to sign in', (tester) async {
      await _openNews(tester);
      await goTo(tester, AppRoutes.article('sample-cleaning'));
      await tester.tap(find.byKey(const ValueKey('bookmark-sample-cleaning')));
      await tester.pump();
      expect(find.text('Gal si aad maqaallada u keydiso.'), findsOneWidget);
      expect(find.byTooltip('Keydi maqaalka'), findsOneWidget); // not saved
    });

    testWidgets('signed in: bookmark, see in saved list, unbookmark', (
      tester,
    ) async {
      final prefs = await _openNews(tester, userId: 'tester');
      await _tap(
        tester,
        find.byKey(const ValueKey('article-sample-cleaning')).first,
      );
      await tester.tap(find.byKey(const ValueKey('bookmark-sample-cleaning')));
      await tester.pumpAndSettle();
      expect(
        find.text('Waxaa lagu keydiyey qalabkan oo kaliya.'),
        findsOneWidget,
      );
      expect(find.byTooltip('Ka saar kuwa la keydiyay'), findsOneWidget);
      expect(prefs.getString('bookmarks.tester'), contains('sample-cleaning'));

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('newsSavedButton')));
      await tester.pumpAndSettle();
      expect(find.byType(SavedArticlesScreen), findsOneWidget);
      expect(
        find.byKey(const ValueKey('saved-sample-cleaning')),
        findsOneWidget,
      );
      expect(find.textContaining('qalabkan oo kaliya'), findsWidgets);

      await _tap(tester, find.byKey(const ValueKey('saved-sample-cleaning')));
      await tester.tap(find.byKey(const ValueKey('bookmark-sample-cleaning')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Maqaal la keydiyay ma jiro'), findsOneWidget);
      expect(
        prefs.getString('bookmarks.tester'),
        isNot(contains('sample-cleaning')),
      );
    });

    testWidgets('saved screen when signed out offers sign in', (tester) async {
      await _openNews(tester);
      await goTo(tester, AppRoutes.savedArticles);
      expect(
        find.text('Gal si aad u aragto maqaalladaada la keydiyay.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(AppButton, 'Gal'), findsOneWidget);
    });

    testWidgets('saved article that is no longer published', (tester) async {
      await _openNews(
        tester,
        userId: 'tester',
        prefs: {
          'bookmarks.tester': jsonEncode([
            {
              'articleId': 'sample-archived',
              'createdAt': testNow.toIso8601String(),
            },
          ]),
        },
      );
      await goTo(tester, AppRoutes.savedArticles);
      expect(find.text('Maqaalkan hadda lama heli karo.'), findsOneWidget);
      await tester.tap(find.text('Ka saar kuwa la keydiyay'));
      await tester.pumpAndSettle();
      expect(find.text('Maqaal la keydiyay ma jiro'), findsOneWidget);
    });
  });

  group('Layout', () {
    const cases = <String, (Size, double, String)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so'),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar'),
      'large 440x956 English': (Size(440, 956), 1.0, 'en'),
    };
    for (final MapEntry(key: name, value: (size, scale, locale))
        in cases.entries) {
      testWidgets('news, details and saved have no overflow on $name', (
        tester,
      ) async {
        await _openNews(
          tester,
          locale: locale,
          size: size,
          scale: scale,
          userId: 'tester',
        );
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('article-sample-arabic')),
          400,
          scrollable: find.byType(Scrollable).first,
        );
        expect(tester.takeException(), isNull);
        await goTo(tester, AppRoutes.article('sample-long'));
        expect(tester.takeException(), isNull);
        await goTo(tester, AppRoutes.savedArticles);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
