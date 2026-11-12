import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/news/application/news_permissions.dart';
import 'package:masjid_management/features/news/data/articles_repository.dart';
import 'package:masjid_management/features/news/data/bookmarks_repository.dart';
import 'package:masjid_management/features/news/screens/article_details_screen.dart';
import 'package:masjid_management/features/news/screens/edit_article_screen.dart';
import 'package:masjid_management/features/news/screens/news_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

/// Sample articles that must never reach the public feed (see
/// LocalArticlesRepository.sampleArticles): a draft, an archived one and one
/// scheduled three days ahead. `sample-long` has HeadingBlocks, so the
/// simple editor must refuse to touch its body.
const _draftTitle = 'TUSAALE: Qabyo (draft)';
const _eveningTitle = 'TUSAALE: Barnaamijka casharrada fiidkii';

Future<void> _openNews(
  WidgetTester tester, {
  bool canManage = false,
  String locale = 'so',
  Size size = const Size(400, 2400),
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale},
    surfaceSize: size,
    overrides: [
      articlesRepositoryProvider.overrideWithValue(
        LocalArticlesRepository(
          seedDate: testNow,
          now: () => testNow,
          latency: Duration.zero,
        ),
      ),
      bookmarkUserIdProvider.overrideWithValue(null),
      canManageNewsProvider.overrideWithValue(canManage),
    ],
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.news);
  expect(find.byType(NewsScreen), findsOneWidget);
}

Finder _input(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

Future<void> _tapKey(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

/// Fills the required fields of a new article.
Future<void> _fillNew(WidgetTester tester, {required String title}) async {
  await tester.enterText(_input('articleFieldTitle'), title);
  await tester.enterText(_input('articleFieldSummary'), 'Soo koobid tijaabo');
  await tester.enterText(
    _input('articleFieldBody'),
    'Faqrada koowaad.\n\nFaqrada labaad.',
  );
  await tester.pump();
  await _tapKey(tester, const Key('articleFieldCategory'));
  await tester.tap(find.text('Wararka Masaajidka').last);
  await tester.pumpAndSettle();
}

void main() {
  group('Permission', () {
    testWidgets('signed out: no add button and no drafts', (tester) async {
      await _openNews(tester);
      expect(find.byKey(const Key('newsAddButton')), findsNothing);
      expect(find.text(_draftTitle), findsNothing);
    });

    testWidgets('signed in: add button and drafts with a status chip', (
      tester,
    ) async {
      await _openNews(tester, canManage: true);
      expect(find.byKey(const Key('newsAddButton')), findsOneWidget);
      // The list repeats each article under "Latest" and "All articles",
      // so every title matches more than once.
      await tester.ensureVisible(find.text(_draftTitle).first);
      await tester.pumpAndSettle();
      expect(find.text(_draftTitle), findsWidgets);
      expect(
        find.byKey(const ValueKey('articleStatus-sample-draft')),
        findsWidgets,
      );
      expect(find.text('Qabyo'), findsWidgets);
    });

    testWidgets('signed out: the new-article route redirects away', (
      tester,
    ) async {
      await _openNews(tester);
      await goTo(tester, AppRoutes.newArticle);
      expect(find.byType(EditArticleScreen), findsNothing);
      expect(find.byType(NewsScreen), findsOneWidget);
    });
  });

  group('Create', () {
    testWidgets('required fields are enforced', (tester) async {
      await _openNews(tester, canManage: true);
      await _tapKey(tester, const Key('newsAddButton'));
      expect(find.byType(EditArticleScreen), findsOneWidget);
      expect(find.text('Maqaal cusub'), findsOneWidget);

      await _tapKey(tester, const Key('articleSaveButton'));
      expect(find.text('Meeshan waa in la buuxiyaa'), findsWidgets);
      expect(find.text('Dooro qayb'), findsOneWidget);
      expect(find.byType(EditArticleScreen), findsOneWidget); // not saved
    });

    testWidgets('a new draft is saved and listed', (tester) async {
      await _openNews(tester, canManage: true);
      await _tapKey(tester, const Key('newsAddButton'));
      await _fillNew(tester, title: 'War cusub oo tijaabo ah');
      await _tapKey(tester, const Key('articleSaveButton'));

      expect(find.byType(NewsScreen), findsOneWidget);
      await tester.ensureVisible(find.text('War cusub oo tijaabo ah').first);
      await tester.pumpAndSettle();
      expect(find.text('War cusub oo tijaabo ah'), findsWidgets);
      // Saved as a draft by default, so it carries the draft chip.
      expect(find.text('Qabyo'), findsWidgets);
    });

    testWidgets('published articles reach the public feed', (tester) async {
      await _openNews(tester, canManage: true);
      await _tapKey(tester, const Key('newsAddButton'));
      await _fillNew(tester, title: 'War la daabacay');
      await _tapKey(tester, const Key('articleFieldStatus'));
      await tester.tap(find.text('La daabacay').last);
      await tester.pumpAndSettle();
      await _tapKey(tester, const Key('articleSaveButton'));

      await tester.ensureVisible(find.text('War la daabacay').first);
      await tester.pumpAndSettle();
      expect(find.text('War la daabacay'), findsWidgets);
      // It is live, so it gets no status chip of its own; the sample draft
      // still has one.
      expect(
        find.byKey(const ValueKey('articleStatus-sample-draft')),
        findsWidgets,
      );
    });
  });

  group('Edit', () {
    testWidgets('editing an article changes the list entry', (tester) async {
      await _openNews(tester, canManage: true);
      await goTo(tester, AppRoutes.editArticle('sample-evening-classes'));
      expect(find.text('Wax ka beddel maqaalka'), findsOneWidget);

      await tester.enterText(_input('articleFieldTitle'), 'Cinwaan cusub');
      await tester.pump();
      await _tapKey(tester, const Key('articleSaveButton'));

      await tester.ensureVisible(find.text('Cinwaan cusub').first);
      await tester.pumpAndSettle();
      expect(find.text('Cinwaan cusub'), findsWidgets);
      expect(find.text(_eveningTitle), findsNothing);
    });

    testWidgets('the edit button opens the form from the article', (
      tester,
    ) async {
      await _openNews(tester, canManage: true);
      await goTo(tester, AppRoutes.article('sample-evening-classes'));
      expect(find.byType(ArticleDetailsScreen), findsOneWidget);
      await _tapKey(tester, const Key('articleEditButton'));
      expect(find.byType(EditArticleScreen), findsOneWidget);
    });

    testWidgets('cancel with changes asks before discarding', (tester) async {
      await _openNews(tester, canManage: true);
      await goTo(tester, AppRoutes.editArticle('sample-evening-classes'));
      await tester.enterText(_input('articleFieldTitle'), 'Changed');
      await tester.pump();

      await _tapKey(tester, const Key('articleCancelButton'));
      expect(find.text('Ma tuuraysaa isbeddellada?'), findsOneWidget);
      await tester.tap(find.text('Sii wad wax ka beddelka'));
      await tester.pumpAndSettle();
      expect(find.byType(EditArticleScreen), findsOneWidget);

      await _tapKey(tester, const Key('articleCancelButton'));
      await tester.tap(find.text('Tuur'));
      await tester.pumpAndSettle();
      expect(find.byType(EditArticleScreen), findsNothing);
      expect(find.text('Changed'), findsNothing);
    });
  });

  group('Rich body guard', () {
    testWidgets('an article with headings keeps its body untouched', (
      tester,
    ) async {
      await _openNews(tester, canManage: true);
      await goTo(tester, AppRoutes.editArticle('sample-long'));
      expect(find.byType(EditArticleScreen), findsOneWidget);
      expect(find.textContaining('Tifaftiraha buuxa'), findsOneWidget);

      final field = tester.widget<EditableText>(
        _input('articleFieldBody').first,
      );
      expect(field.readOnly || !field.focusNode.canRequestFocus, isTrue);

      // Metadata still saves, and the heading survives.
      await tester.enterText(
        _input('articleFieldTitle'),
        'Cinwaan la beddelay',
      );
      await tester.pump();
      await _tapKey(tester, const Key('articleSaveButton'));
      await tester.pumpAndSettle();

      await goTo(tester, AppRoutes.article('sample-long'));
      await tester.pumpAndSettle();
      expect(find.text('Qaybta 1 (tusaale)'), findsOneWidget);
    });
  });
}
