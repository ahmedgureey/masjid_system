import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/localized_text.dart';
import '../../../services/local_collection_store.dart';
import '../../mosque/data/mosque_repository.dart';
import '../application/news_permissions.dart';
import '../models/article.dart';
import '../models/article_category.dart';
import 'article_json.dart';

/// Source of articles and categories.
///
/// Today: [LocalArticlesRepository] (in-memory mock).
/// Supabase phase: queries on `islamic_articles` / `article_categories`
/// filtered by `mosque_id`, with Row Level Security allowing the public to
/// read only published rows whose `published_at` has passed.
abstract interface class ArticlesRepository {
  /// Publicly visible articles of [mosqueId] (never drafts, archived or
  /// scheduled articles, never another mosque's).
  Future<List<Article>> getPublishedArticles({required String mosqueId});

  /// Every article of [mosqueId], drafts, scheduled and archived ones
  /// included. For administrators only — the public list stays
  /// [getPublishedArticles].
  Future<List<Article>> getAllArticles({required String mosqueId});

  /// Inserts or updates [article] (matched by id) and returns the stored
  /// copy.
  Future<Article> saveArticle(Article article);

  /// Removes the article with [id]. Removing one that is already gone is
  /// not an error: two taps on a delete button should not surface a failure.
  Future<void> deleteArticle(String id);

  /// Active categories in display order.
  Future<List<ArticleCategory>> getCategories();
}

/// Articles held on the device.
///
/// With a [store], the sample articles are written once on the very first
/// run and are ordinary rows from then on: the user can edit them, delete
/// them and add their own, and all of it survives closing the app. Deleting
/// every sample does not bring it back — the store seeds on "never written",
/// not on "empty".
///
/// Without a [store] it is purely in-memory, which is what the widget tests
/// want: they pass [articles] and assert on what they passed.
///
/// The samples are clearly marked "TUSAALE" (example) and [Article.isSample].
/// They are NOT real news of the mosque and contain no Qur'an verses, hadith,
/// rulings or quotations. Sample dates are relative to [seedDate].
class LocalArticlesRepository implements ArticlesRepository {
  LocalArticlesRepository({
    required this.seedDate,
    DateTime Function()? now,
    this.store,
    this.latency = const Duration(milliseconds: 500),
    List<Article>? articles,
    List<ArticleCategory>? categories,
  }) : _now = now ?? DateTime.now,
       // Copied: the caller's list must not be mutated by saves and deletes.
       _articles = articles == null ? null : List<Article>.of(articles),
       _categories = categories ?? defaultCategories;

  final DateTime Function() _now;
  final Duration latency;

  /// What the sample dates are built around.
  final DateTime seedDate;

  /// Null in tests that work purely in memory.
  final LocalCollectionStore? store;

  static const String collection = 'articles';

  /// Null until first loaded, so a store-backed repository does not read the
  /// device in its constructor.
  List<Article>? _articles;
  final List<ArticleCategory> _categories;

  /// The working list, loaded from the store on first use.
  Future<List<Article>> _loaded() async {
    final cached = _articles;
    if (cached != null) return cached;

    final store = this.store;
    final loaded = store == null
        ? sampleArticles(seedDate)
        : ArticleJson.listFrom(
            await store.readOrSeed(
              collection,
              () => ArticleJson.listTo(sampleArticles(seedDate)),
            ),
          );
    return _articles = loaded;
  }

  /// Writes the working list back. A no-op without a store.
  Future<void> _flush() async {
    final store = this.store;
    if (store == null) return;
    await store.write(collection, ArticleJson.listTo(_articles ?? const []));
  }

  @override
  Future<List<Article>> getPublishedArticles({required String mosqueId}) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final now = _now();
    return [
      for (final a in await _loaded())
        if (a.mosqueId == mosqueId && a.isPubliclyVisibleAt(now)) a,
    ];
  }

  @override
  Future<List<Article>> getAllArticles({required String mosqueId}) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return [
      for (final a in await _loaded())
        if (a.mosqueId == mosqueId) a,
    ];
  }

  @override
  Future<Article> saveArticle(Article article) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final articles = await _loaded();
    final index = articles.indexWhere((a) => a.id == article.id);
    if (index >= 0) {
      articles[index] = article;
    } else {
      articles.add(article);
    }
    await _flush();
    return article;
  }

  @override
  Future<void> deleteArticle(String id) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final articles = await _loaded();
    articles.removeWhere((a) => a.id == id);
    await _flush();
  }

  @override
  Future<List<ArticleCategory>> getCategories() async {
    final list = _categories.where((c) => c.isActive).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return list;
  }

  /// Category configuration (not sample content): the categories agreed for
  /// the mosque. Editable by administrators once the backend exists.
  static const List<ArticleCategory> defaultCategories = [
    ArticleCategory(
      id: 'mosque-news',
      slug: 'mosque-news',
      displayOrder: 1,
      name: LocalizedText({
        'so': 'Wararka Masaajidka',
        'en': 'Mosque news',
        'ar': 'أخبار المسجد',
      }),
    ),
    ArticleCategory(
      id: 'announcements',
      slug: 'announcements',
      displayOrder: 2,
      name: LocalizedText({
        'so': 'Ogeysiisyada',
        'en': 'Announcements',
        'ar': 'الإعلانات',
      }),
    ),
    ArticleCategory(
      id: 'islamic-articles',
      slug: 'islamic-articles',
      displayOrder: 3,
      name: LocalizedText({
        'so': 'Maqaallada Islaamiga ah',
        'en': 'Islamic articles',
        'ar': 'مقالات إسلامية',
      }),
    ),
    ArticleCategory(
      id: 'quran-sunnah',
      slug: 'quran-sunnah',
      displayOrder: 4,
      name: LocalizedText({
        'so': "Qur'aanka iyo Sunnada",
        'en': 'Quran and Sunnah',
        'ar': 'القرآن والسنة',
      }),
    ),
    ArticleCategory(
      id: 'education',
      slug: 'education',
      displayOrder: 5,
      name: LocalizedText({
        'so': 'Waxbarashada iyo Duruusta',
        'en': 'Education and lessons',
        'ar': 'التعليم والدروس',
      }),
    ),
    ArticleCategory(
      id: 'youth-family',
      slug: 'youth-family',
      displayOrder: 6,
      name: LocalizedText({
        'so': 'Dhallinyarada iyo Qoyska',
        'en': 'Youth and family',
        'ar': 'الشباب والأسرة',
      }),
    ),
    ArticleCategory(
      id: 'projects',
      slug: 'projects',
      displayOrder: 7,
      name: LocalizedText({
        'so': 'Mashaariicda Masaajidka',
        'en': 'Mosque projects',
        'ar': 'مشاريع المسجد',
      }),
    ),
    ArticleCategory(
      id: 'community',
      slug: 'community',
      displayOrder: 8,
      name: LocalizedText({
        'so': 'Bulshada',
        'en': 'Community',
        'ar': 'المجتمع',
      }),
    ),
  ];

  static const String sampleMosqueId = 'al-ikhlas';

  static const LocalizedText _note = LocalizedText({
    'so':
        'Qoraalkan waa tusaale (mock) loogu talagalay tijaabinta naqshadda '
        'app-ka. Ma aha war dhab ah oo masaajidka, kumana jiraan xukun '
        'diimeed, aayad, xadiis ama xigasho.',
    'en':
        'This text is a sample (mock) used to test the app design. It is not '
        'real news of the mosque and contains no religious ruling, verse, '
        'hadith or quotation.',
    'ar':
        'هذا النص مثال تجريبي لاختبار تصميم التطبيق، وليس خبرًا حقيقيًا '
        'للمسجد، ولا يتضمن حكمًا شرعيًا أو آية أو حديثًا أو اقتباسًا.',
  });

  /// Clearly identified sample articles around [seed]: eight public ones,
  /// plus a draft, an archived, a scheduled and another mosque's article
  /// that must never appear in the public feed.
  static List<Article> sampleArticles(DateTime seed) {
    DateTime daysAgo(int d, [int hour = 9]) =>
        DateTime(seed.year, seed.month, seed.day - d, hour);

    Article sample(
      String id,
      String categoryId,
      String title,
      String summary,
      int age, {
      bool featured = false,
      ArticleStatus status = ArticleStatus.published,
      String mosqueId = sampleMosqueId,
      DateTime? publishedAt,
      DateTime? updatedAt,
      List<ArticleBlock>? body,
      List<SourceReference> references = const [],
      LocalizedText? localizedTitle,
      LocalizedText? localizedSummary,
    }) => Article(
      id: id,
      mosqueId: mosqueId,
      slug: id,
      title: localizedTitle ?? LocalizedText.all('TUSAALE: $title'),
      summary: localizedSummary ?? LocalizedText.all(summary),
      body: body ?? const [ParagraphBlock(_note)],
      categoryId: categoryId,
      status: status,
      isFeatured: featured,
      publishedAt: status == ArticleStatus.draft
          ? null
          : publishedAt ?? daysAgo(age),
      createdAt: daysAgo(age + 1),
      updatedAt: updatedAt,
      sourceReferences: references,
      isSample: true,
    );

    final longBody = <ArticleBlock>[
      const ParagraphBlock(_note),
      for (var i = 1; i <= 6; i++) ...[
        HeadingBlock(LocalizedText.all('Qaybta $i (tusaale)')),
        ParagraphBlock(
          LocalizedText.all(
            'Tani waa sadar meel-hayn ah (placeholder) oo loogu talagalay '
                    'tijaabinta qoraal dheer, kala-goynta sadarrada iyo scroll-ka. ' *
                6,
          ),
        ),
      ],
    ];

    return [
      sample(
        'sample-evening-classes',
        'mosque-news',
        'Barnaamijka casharrada fiidkii',
        'Tusaale war ah oo ku saabsan jadwal cusub oo casharrada fiidkii.',
        1,
        featured: true,
        updatedAt: daysAgo(0, 8),
        references: const [
          SourceReference(title: 'Tusaale: warbixinta guddiga masaajidka'),
        ],
      ),
      sample(
        'sample-cleaning',
        'announcements',
        'Ogeysiis — maalinta nadiifinta',
        'Tusaale ogeysiis ah oo ku saabsan maalin mutadawaciin ah.',
        2,
      ),
      sample(
        'sample-classroom',
        'education',
        'Diyaarinta qolka waxbarashada',
        'Tusaale maqaal ah oo ku saabsan qalabka qolka waxbarashada.',
        3,
        featured: true,
      ),
      sample(
        'sample-parents',
        'youth-family',
        'Kulanka waalidiinta iyo dhallinyarada',
        'Tusaale war ah oo ku saabsan kulan waalidiin.',
        5,
      ),
      sample(
        'sample-renovation',
        'projects',
        'Mashruuca dayactirka musallaha',
        'Tusaale warbixin ah oo ku saabsan horumarka mashruuc dayactir.',
        8,
        featured: true,
      ),
      sample(
        'sample-community',
        'community',
        'Iskaashiga bulshada',
        'Tusaale maqaal ah oo ku saabsan mutadawacnimada bulshada.',
        12,
      ),
      sample(
        'sample-long',
        'islamic-articles',
        'Maqaal dheer oo tijaabo ah',
        'Qoraal dheer oo meel-hayn ah oo loogu talagalay tijaabinta akhriska.',
        20,
        body: longBody,
      ),
      sample(
        'sample-arabic',
        'announcements',
        '',
        '',
        25,
        localizedTitle: const LocalizedText({
          'ar': 'تجريبي: إعلان باللغة العربية',
          'so': 'TUSAALE: Ogeysiis Carabi ah',
          'en': 'SAMPLE: Arabic announcement',
        }),
        localizedSummary: const LocalizedText({
          'ar': 'إعلان تجريبي لاختبار اتجاه النص من اليمين إلى اليسار.',
          'so': 'Tusaale lagu tijaabinayo qoraalka midig-ilaa-bidix.',
          'en': 'A sample used to test right-to-left text.',
        }),
        body: const [
          ParagraphBlock(
            LocalizedText({
              'ar':
                  'هذه فقرة تجريبية باللغة العربية لاختبار اتجاه النص. '
                  'ليست خبرًا حقيقيًا.',
            }),
          ),
          ParagraphBlock(_note),
        ],
      ),
      // Must never be shown publicly:
      sample(
        'sample-draft',
        'mosque-news',
        'Qabyo (draft)',
        'Qabyo aan la daabicin.',
        0,
        status: ArticleStatus.draft,
      ),
      sample(
        'sample-archived',
        'mosque-news',
        'War la kaydiyay (archived)',
        'War hore oo la kaydiyay.',
        40,
        status: ArticleStatus.archived,
      ),
      sample(
        'sample-scheduled',
        'announcements',
        'Ogeysiis la qorsheeyay',
        'Ogeysiis la daabici doono mustaqbalka.',
        0,
        publishedAt: DateTime(seed.year, seed.month, seed.day + 3, 9),
      ),
      sample(
        'sample-other-mosque',
        'mosque-news',
        'War masaajid kale',
        'War masaajid kale leeyahay.',
        1,
        mosqueId: 'other-mosque',
      ),
    ];
  }
}

final articlesRepositoryProvider = Provider<ArticlesRepository>(
  (ref) => LocalArticlesRepository(
    seedDate: DateTime.now(),
    store: ref.watch(localCollectionStoreProvider),
  ),
);

/// Articles of the current mosque: the published ones for visitors, and
/// every article — drafts and scheduled included — for an administrator, so
/// they can find what they have written. The Projects feature behaves the
/// same way.
final articlesProvider =
    AsyncNotifierProvider<ArticlesController, List<Article>>(
      ArticlesController.new,
    );

class ArticlesController extends AsyncNotifier<List<Article>> {
  @override
  Future<List<Article>> build() async {
    final mosque = await ref.watch(mosqueProvider.future);
    final repository = ref.watch(articlesRepositoryProvider);
    return ref.watch(canManageNewsProvider)
        ? repository.getAllArticles(mosqueId: mosque.id)
        : repository.getPublishedArticles(mosqueId: mosque.id);
  }

  /// Saves through the repository; throws on failure (state unchanged).
  Future<Article> save(Article article) async {
    final saved = await ref
        .read(articlesRepositoryProvider)
        .saveArticle(article);
    final current = [...?state.value];
    final index = current.indexWhere((a) => a.id == saved.id);
    if (index >= 0) {
      current[index] = saved;
    } else {
      current.add(saved);
    }
    state = AsyncData(current);
    return saved;
  }

  /// Deletes through the repository; throws on failure (state unchanged).
  Future<void> delete(String id) async {
    await ref.read(articlesRepositoryProvider).deleteArticle(id);
    state = AsyncData([...?state.value]..removeWhere((a) => a.id == id));
  }
}

final articleCategoriesProvider = FutureProvider<List<ArticleCategory>>(
  (ref) => ref.watch(articlesRepositoryProvider).getCategories(),
);
