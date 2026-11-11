import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/app.dart';
import 'package:masjid_management/core/widgets/widgets.dart';
import 'package:masjid_management/features/authentication/application/demo_session_provider.dart';
import 'package:masjid_management/features/donations/data/donations_repository.dart';
import 'package:masjid_management/features/donations/models/money.dart';
import 'package:masjid_management/features/donations/screens/donate_screen.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/projects/application/project_logic.dart';
import 'package:masjid_management/features/projects/data/projects_repository.dart';
import 'package:masjid_management/features/projects/models/project_category.dart';
import 'package:masjid_management/features/projects/models/project_models.dart';
import 'package:masjid_management/features/projects/screens/project_details_screen.dart';
import 'package:masjid_management/features/projects/screens/project_form_screen.dart';
import 'package:masjid_management/features/projects/screens/projects_screen.dart';
import 'package:masjid_management/routing/app_router.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

// testNow = 11 Nov 2026. Sample funding (confirmed donations of linked
// campaigns): construction $1,700 of $50,000 (+$300 pending) · roof $250 of
// $5,000 · solar $1,650 of $1,200 (capped 100 %) · well: budget 0, no
// campaign. Approved project expenses: solar $120.

const _usd = Currency.usd;

LocalProjectsRepository _projectsRepo({List<MosqueProject>? projects}) =>
    LocalProjectsRepository(
      seedDate: testNow,
      latency: Duration.zero,
      projects: projects,
    );

class _FailingProjects implements ProjectsRepository {
  final LocalProjectsRepository inner = _projectsRepo();
  bool fail = true;
  Duration delay = Duration.zero;

  @override
  Future<List<MosqueProject>> getProjects({required String mosqueId}) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (fail) throw Exception('network');
    return inner.getProjects(mosqueId: mosqueId);
  }

  @override
  Future<List<ProjectUpdate>> getUpdates({required String mosqueId}) =>
      inner.getUpdates(mosqueId: mosqueId);

  @override
  Future<MosqueProject> saveProject(MosqueProject project) =>
      inner.saveProject(project);

  @override
  Future<ProjectUpdate> saveUpdate(
    ProjectUpdate update, {
    required String editor,
    required DateTime now,
  }) => inner.saveUpdate(update, editor: editor, now: now);
}

Future<ProviderContainer> _open(
  WidgetTester tester,
  String location, {
  String locale = 'so',
  Size size = const Size(400, 2600),
  double scale = 1.0,
  bool admin = false,
  ProjectsRepository? repo,
  Map<String, Object> prefs = const {},
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale, ...prefs},
    surfaceSize: size,
    textScale: scale,
    overrides: [
      projectsRepositoryProvider.overrideWithValue(repo ?? _projectsRepo()),
      donationsRepositoryProvider.overrideWithValue(
        LocalDonationsRepository(seedDate: testNow, latency: Duration.zero),
      ),
    ],
  );
  await passSplash(tester);
  final c = ProviderScope.containerOf(tester.element(find.byType(MasjidApp)));
  if (admin) {
    c.read(demoSessionProvider.notifier).signIn(displayName: 'Admin');
  }
  await goTo(tester, location);
  return c;
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

String _text(WidgetTester tester, Key key) =>
    tester.widget<Text>(find.byKey(key)).data!;

Finder _input(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

void main() {
  final projects = LocalProjectsRepository.sampleProjects(testNow);
  final donations = LocalDonationsRepository.sampleDonations(testNow);
  final expenses = LocalDonationsRepository.sampleExpenses(testNow);
  MosqueProject project(String id) => projects.firstWhere((p) => p.id == id);

  group('Fixes (audit)', () {
    final campaigns = LocalDonationsRepository.sampleCampaigns(testNow);

    test('campaign choices: active, same currency, not linked elsewhere', () {
      List<String> ids(String? projectId, Currency cur) => [
        for (final c in ProjectLogic.availableCampaigns(
          projectId: projectId,
          currency: cur,
          campaigns: campaigns,
          projects: projects,
        ))
          c.id,
      ];
      final forNew = ids(null, _usd);
      // Already funding another project → not offered (no double counting).
      expect(forNew, isNot(contains('camp-construction')));
      expect(forNew, isNot(contains('camp-maintenance')));
      // Closed / draft campaigns are not offered.
      expect(forNew, isNot(contains('camp-old')));
      expect(forNew, isNot(contains('camp-draft')));
      expect(forNew, contains('camp-general'));
      // A project keeps its own campaign as a choice.
      expect(ids('proj-roof', _usd), contains('camp-maintenance'));
      expect(ids('proj-roof', _usd), isNot(contains('camp-construction')));
      // No sample campaign is in SOS.
      expect(ids(null, Currency.sos), isEmpty);
    });

    test('donations need an ACTIVE linked campaign', () {
      MosqueProject linkedTo(String? id, [ProjectStatus? s]) => MosqueProject(
        id: 'x',
        mosqueId: 'al-ikhlas',
        title: 'X',
        summary: 'S',
        categoryId: 'other',
        budget: const Money.major(10, _usd),
        status: s ?? ProjectStatus.ongoing,
        fundingCampaignId: id,
        createdAt: testNow,
        updatedAt: testNow,
      );
      bool can(MosqueProject p) =>
          ProjectLogic.canAcceptDonations(p, campaigns);
      expect(can(linkedTo('camp-general')), isTrue);
      expect(can(linkedTo('camp-old')), isFalse); // campaign completed
      expect(can(linkedTo('camp-draft')), isFalse); // campaign draft
      expect(can(linkedTo('missing')), isFalse);
      expect(can(linkedTo(null)), isFalse);
      expect(can(linkedTo('camp-general', ProjectStatus.completed)), isFalse);
    });

    test('budget: comma only as a thousands separator', () {
      expect(ProjectValidation.budget('12,50', _usd), isNotNull);
      expect(ProjectValidation.budget('1,5', _usd), isNotNull);
      expect(ProjectValidation.parseAmount('12,50', _usd), isNull);
      expect(
        ProjectValidation.parseAmount('1,250.50', _usd),
        const Money(125050, _usd),
      );
      expect(
        ProjectValidation.parseAmount('50,000', _usd),
        const Money.major(50000, _usd),
      );
    });

    testWidgets('switching currency clears the campaign without crashing', (
      tester,
    ) async {
      final c = await _open(
        tester,
        AppRoutes.editProject('proj-roof'),
        admin: true,
      );
      expect(find.text('TUSAALE: Dayactirka masaajidka'), findsOneWidget);
      await _tap(tester, find.byType(DropdownButtonFormField<Currency>));
      await _tap(tester, find.text('SOS').last);
      expect(tester.takeException(), isNull);
      expect(find.text('TUSAALE: Dayactirka masaajidka'), findsNothing);
      // Back to USD: the campaign stays cleared (user must choose again).
      await _tap(tester, find.byType(DropdownButtonFormField<Currency>));
      await _tap(tester, find.text('USD').last);
      expect(tester.takeException(), isNull);
      await _tap(tester, find.byKey(const Key('projSave')));
      final p = c
          .read(projectsProvider)
          .value!
          .firstWhere((x) => x.id == 'proj-roof');
      expect(p.fundingCampaignId, isNull);
    });

    testWidgets('closed linked campaign: donate disabled and not redirected', (
      tester,
    ) async {
      final closed = MosqueProject(
        id: 'proj-closed',
        mosqueId: 'al-ikhlas',
        title: 'Closed campaign project',
        summary: 'S',
        categoryId: 'other',
        budget: const Money.major(10, _usd),
        status: ProjectStatus.ongoing,
        fundingCampaignId: 'camp-old',
        createdAt: testNow,
        updatedAt: testNow,
      );
      await _open(
        tester,
        AppRoutes.project('proj-closed'),
        repo: _projectsRepo(projects: [closed]),
      );
      final button = find.descendant(
        of: find.byKey(const Key('projectDonate')),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      );
      expect(tester.widget<ButtonStyleButton>(button).onPressed, isNull);
      // A direct link must not fall back to another campaign.
      await goTo(tester, AppRoutes.donateToProject('proj-closed', 'camp-old'));
      expect(find.byKey(const Key('donateCampaignClosed')), findsOneWidget);
      expect(find.text('Ololahan hadda deeq ma aqbalayo.'), findsOneWidget);
      expect(find.byKey(const Key('donateDemoWarning')), findsNothing);
    });

    testWidgets('expenses are not loaded for non-staff on project details', (
      tester,
    ) async {
      final c = await _open(tester, AppRoutes.project('proj-solar'));
      expect(find.byKey(const Key('projectExpenses')), findsNothing);
      // ignore: deprecated_member_use
      expect(c.exists(expensesProvider), isFalse);
    });
  });

  group('Logic (pure)', () {
    test('funding counts confirmed campaign donations only', () {
      final f = ProjectLogic.funding(project('proj-construction'), donations);
      expect(f.raised, const Money.major(1700, _usd));
      expect(f.pending, const Money.major(300, _usd));
      expect(f.target, const Money.major(50000, _usd));
      expect(f.remaining, const Money.major(48300, _usd));
      expect(f.percent, 3);
    });

    test('funding is capped at 100 % and remaining never negative', () {
      final f = ProjectLogic.funding(project('proj-solar'), donations);
      expect(f.percent, 100);
      expect(f.remaining.isZero, isTrue);
    });

    test('zero budget / no campaign: no division by zero', () {
      final f = ProjectLogic.funding(project('proj-well'), donations);
      expect(f.fraction, 0);
      expect(f.percent, 0);
      expect(f.raised.isZero, isTrue);
      expect(f.remaining.isZero, isTrue);
    });

    test('project expenses: approved, not voided, this project only', () {
      expect(
        ProjectLogic.approvedExpenses('proj-solar', expenses, _usd),
        const Money.major(120, _usd),
      );
      // Rejected expense.
      expect(
        ProjectLogic.approvedExpenses('proj-roof', expenses, _usd).isZero,
        isTrue,
      );
      // Voided expense.
      expect(
        ProjectLogic.approvedExpenses(
          'proj-quran-school',
          expenses,
          _usd,
        ).isZero,
        isTrue,
      );
    });

    test('search, category and status filters', () {
      List<String> ids({String q = '', String? cat, ProjectStatus? s}) =>
          ProjectLogic.filter(
            projects,
            query: q,
            categoryId: cat,
            status: s,
          ).map((p) => p.id).toList();
      expect(ids(q: 'QORRAXDA'), ['proj-solar']);
      expect(ids(cat: 'water'), ['proj-well']);
      expect(ids(s: ProjectStatus.paused), ['proj-fans']);
      expect(ids(q: 'zzz'), isEmpty);
      expect(ids().length, projects.length);
    });

    test('drafts are visible only to managers', () {
      final updates = LocalProjectsRepository.sampleUpdates(testNow);
      final public = ProjectLogic.visibleUpdates(
        updates,
        'proj-construction',
        canManage: false,
      );
      expect(public.map((u) => u.id), ['upd-2', 'upd-1']);
      expect(
        ProjectLogic.visibleUpdates(
          updates,
          'proj-construction',
          canManage: true,
        ).length,
        3,
      );
    });

    test('milestones: completed vs upcoming', () {
      final p = project('proj-construction');
      expect(ProjectLogic.completedMilestones(p).map((m) => m.id), ['ms-land']);
      expect(ProjectLogic.upcomingMilestones(p).first.id, 'ms-foundation');
    });

    test('validation: budget, dates, percent, required', () {
      expect(ProjectValidation.budget('', _usd), ProjectFieldError.required);
      expect(ProjectValidation.budget('-5', _usd), ProjectFieldError.negative);
      expect(
        ProjectValidation.budget('abc', _usd),
        ProjectFieldError.invalidAmount,
      );
      expect(
        ProjectValidation.budget('1.234', _usd),
        ProjectFieldError.tooManyDecimals,
      );
      expect(ProjectValidation.budget('0', _usd), isNull);
      expect(
        ProjectValidation.parseAmount('5,000.5', _usd),
        const Money(500050, _usd),
      );
      expect(
        ProjectValidation.dates(DateTime(2026, 5, 2), DateTime(2026, 5, 1)),
        ProjectFieldError.endBeforeStart,
      );
      expect(
        ProjectValidation.dates(DateTime(2026, 5, 1), DateTime(2026, 5, 1)),
        isNull,
      );
      expect(ProjectValidation.percent('101'), ProjectFieldError.percentRange);
      expect(ProjectValidation.percent(''), isNull);
      expect(ProjectValidation.requiredText('  '), ProjectFieldError.required);
    });

    test('categories are centralised (10, unknown → Other)', () {
      expect(projectCategories.length, 10);
      expect(projectCategoryById('nope').id, 'other');
    });

    test('editing an update keeps the previous version', () async {
      final repo = _projectsRepo();
      final updates = await repo.getUpdates(mosqueId: 'al-ikhlas');
      final u = updates.firstWhere((x) => x.id == 'upd-1');
      final saved = await repo.saveUpdate(
        ProjectUpdate(
          id: u.id,
          projectId: u.projectId,
          title: 'New title',
          description: u.description,
          date: u.date,
          author: 'X',
          isPublished: true,
        ),
        editor: 'Admin',
        now: testNow,
      );
      expect(saved.title, 'New title');
      expect(saved.revisions.single.title, u.title);
      expect(saved.author, u.author);
    });
  });

  group('Dashboard integration', () {
    testWidgets(
      '"Mashaariicda" replaces "Nala Soo Xiriir" and opens projects',
      (tester) async {
        await _open(tester, AppRoutes.home);
        expect(find.text('Nala Soo Xiriir'), findsNothing);
        await _tap(tester, find.text('Mashaariicda'));
        expect(find.byType(ProjectsScreen), findsOneWidget);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);
        // Bottom navigation unchanged.
        for (final label in ['HOME', 'SETTINGS', 'PROFILE', 'ABOUT']) {
          expect(find.text(label), findsOneWidget);
        }
      },
    );
  });

  group('Projects list', () {
    testWidgets('renders sections, sample notice and funding', (tester) async {
      await _open(tester, AppRoutes.projects);
      expect(find.text('Mashaariicda Masaajidka'), findsOneWidget);
      expect(find.byKey(const Key('projectsSampleNotice')), findsOneWidget);
      expect(find.text('Mashaariicda la soo xulay'), findsOneWidget);
      expect(find.text('Mashaariicda socda'), findsOneWidget);
      expect(find.text('Kuwa dhowaan lagu daray'), findsOneWidget);
      final card = find.byKey(const ValueKey('project-proj-construction'));
      expect(
        find.descendant(of: card, matching: find.text(r'$1,700.00')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('projectAdd')), findsNothing); // not admin
    });

    testWidgets('search, category and status filters', (tester) async {
      await _open(tester, AppRoutes.projects);
      await tester.enterText(
        find.byKey(const Key('projectSearch')),
        'qorraxda',
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('project-proj-solar')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('project-proj-construction')),
        findsNothing,
      );
      await tester.enterText(find.byKey(const Key('projectSearch')), '');
      await tester.pumpAndSettle();

      await _tap(tester, find.byKey(const ValueKey('projCat-water')));
      expect(find.byKey(const ValueKey('project-proj-well')), findsOneWidget);
      expect(find.byKey(const ValueKey('project-proj-solar')), findsNothing);
      await _tap(tester, find.byKey(const Key('projCat-all')));

      await _tap(tester, find.byKey(const ValueKey('projStatus-paused')));
      expect(find.byKey(const ValueKey('project-proj-fans')), findsOneWidget);
      expect(find.byKey(const ValueKey('project-proj-well')), findsNothing);

      await _tap(tester, find.byKey(const ValueKey('projCat-library')));
      expect(find.text('Mashruuc lama helin'), findsOneWidget);
    });

    testWidgets('empty state', (tester) async {
      await _open(
        tester,
        AppRoutes.projects,
        repo: _projectsRepo(projects: const []),
      );
      expect(find.text('Mashruuc ma jiro'), findsOneWidget);
    });

    testWidgets('error state with retry', (tester) async {
      final repo = _FailingProjects();
      await _open(tester, AppRoutes.projects, repo: repo);
      expect(find.byType(ErrorState), findsOneWidget);
      repo.fail = false;
      await tester.tap(
        find.descendant(
          of: find.byType(ErrorState),
          matching: find.byType(AppButton),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ErrorState), findsNothing);
      expect(
        find.byKey(const ValueKey('project-proj-construction')),
        findsOneWidget,
      );
    });

    testWidgets('loading indicator while fetching', (tester) async {
      final repo = _FailingProjects()
        ..fail = false
        ..delay = const Duration(seconds: 2);
      await pumpFullApp(
        tester,
        prefs: {localeCodeKey: 'so'},
        overrides: [projectsRepositoryProvider.overrideWithValue(repo)],
      );
      await passSplash(tester);
      ProviderScope.containerOf(tester.element(find.byType(MasjidApp)))
          .read(appRouterProvider)
          .go(AppRoutes.projects);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(AppLoadingIndicator), findsNothing);
    });
  });

  group('Project details', () {
    testWidgets('opens the selected project with funding and progress', (
      tester,
    ) async {
      await _open(tester, AppRoutes.projects);
      await _tap(
        tester,
        find.byKey(const ValueKey('project-proj-construction')),
      );
      expect(find.byType(ProjectDetailsScreen), findsOneWidget);
      expect(
        _text(tester, const Key('projectTitle')),
        'TUSAALE: Dhismaha masaajid cusub',
      );
      expect(_text(tester, const Key('projectRaised')), r'$1,700.00');
      expect(_text(tester, const Key('projectRemaining')), r'$48,300.00');
      expect(_text(tester, const Key('projectBudget')), r'$50,000.00');
      // Physical progress is separate from funding (25 % vs 3 %).
      expect(_text(tester, const Key('projectPhysicalPercent')), '25%');
      expect(find.byKey(const ValueKey('milestone-ms-land')), findsOneWidget);
      // Published updates only; no admin actions; no staff expenses.
      expect(find.byKey(const ValueKey('update-upd-1')), findsOneWidget);
      expect(find.byKey(const ValueKey('update-upd-draft')), findsNothing);
      expect(find.byKey(const Key('projectEdit')), findsNothing);
      expect(find.byKey(const Key('projectAddUpdate')), findsNothing);
      expect(find.byKey(const Key('projectExpenses')), findsNothing);
    });

    testWidgets('zero-budget project without campaign: donate disabled', (
      tester,
    ) async {
      await _open(tester, AppRoutes.project('proj-well'));
      expect(_text(tester, const Key('projectBudget')), r'$0.00');
      final button = find.descendant(
        of: find.byKey(const Key('projectDonate')),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      );
      expect(tester.widget<ButtonStyleButton>(button).onPressed, isNull);
      expect(find.textContaining('laguma xirin olole'), findsWidgets);
    });

    testWidgets('donate passes the project into the existing donation flow', (
      tester,
    ) async {
      await _open(tester, AppRoutes.project('proj-construction'));
      await _tap(tester, find.byKey(const Key('projectDonate')));
      final screen = tester.widget<DonateScreen>(find.byType(DonateScreen));
      expect(screen.projectId, 'proj-construction');
      expect(screen.campaignId, 'camp-construction');
      expect(find.byKey(const Key('donateProjectBanner')), findsOneWidget);
      expect(find.text('TUSAALE: Dhismaha masaajid cusub'), findsOneWidget);
      // Linked campaign pre-selected; demo warning still shown.
      expect(find.text('TUSAALE: Dhismaha masaajidka'), findsOneWidget);
      expect(find.byKey(const Key('donateDemoWarning')), findsOneWidget);
    });

    testWidgets('admin sees drafts, expenses, edit and add-update actions', (
      tester,
    ) async {
      await _open(tester, AppRoutes.project('proj-solar'), admin: true);
      expect(find.byKey(const Key('projectEdit')), findsOneWidget);
      expect(find.byKey(const Key('projectAddUpdate')), findsOneWidget);
      expect(_text(tester, const Key('projectExpenses')), r'$120.00');
      await goTo(tester, AppRoutes.project('proj-construction'));
      expect(find.byKey(const ValueKey('update-upd-draft')), findsOneWidget);
      expect(find.text('Qabyo'), findsWidgets);
    });

    testWidgets('unknown id shows not found', (tester) async {
      await _open(tester, AppRoutes.project('nope'));
      expect(find.text('Mashruucan lama helin.'), findsOneWidget);
    });
  });

  group('Admin forms (frontend-only permission)', () {
    testWidgets('ordinary users are redirected away from admin routes', (
      tester,
    ) async {
      await _open(tester, AppRoutes.newProject);
      expect(find.byType(ProjectFormScreen), findsNothing);
      expect(find.byType(ProjectsScreen), findsOneWidget);
      await goTo(tester, AppRoutes.editProject('proj-roof'));
      expect(find.byType(ProjectFormScreen), findsNothing);
      await goTo(tester, AppRoutes.newProjectUpdate('proj-roof'));
      expect(find.byType(ProjectUpdateFormScreen), findsNothing);
    });

    testWidgets('new project: required fields and negative budget', (
      tester,
    ) async {
      await _open(tester, AppRoutes.projects, admin: true);
      await _tap(tester, find.byKey(const Key('projectAdd')));
      expect(find.byType(ProjectFormScreen), findsOneWidget);
      await _tap(tester, find.byKey(const Key('projSave')));
      expect(find.text('Meeshan waa in la buuxiyaa'), findsWidgets);
      expect(find.text('Fadlan dooro mid'), findsOneWidget);
      await tester.enterText(_input('projFieldBudget'), '-5');
      await _tap(tester, find.byKey(const Key('projSave')));
      expect(find.text('Qaddarku ma noqon karo taban.'), findsOneWidget);
      expect(find.byType(ProjectFormScreen), findsOneWidget); // not saved
    });

    testWidgets('end date before start date blocks saving', (tester) async {
      final bad = MosqueProject(
        id: 'bad',
        mosqueId: 'al-ikhlas',
        title: 'Bad dates',
        summary: 'S',
        categoryId: 'other',
        budget: const Money.major(10, _usd),
        startDate: DateTime(2026, 12, 10),
        expectedEndDate: DateTime(2026, 12, 1),
        status: ProjectStatus.planned,
        createdAt: testNow,
        updatedAt: testNow,
      );
      await _open(
        tester,
        AppRoutes.editProject('bad'),
        admin: true,
        repo: _projectsRepo(projects: [bad]),
      );
      expect(find.byKey(const Key('projDateError')), findsOneWidget);
      final save = find.descendant(
        of: find.byKey(const Key('projSave')),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      );
      expect(tester.widget<ButtonStyleButton>(save).onPressed, isNull);
    });

    testWidgets('editing the budget is recorded in the change history', (
      tester,
    ) async {
      final c = await _open(
        tester,
        AppRoutes.project('proj-roof'),
        admin: true,
      );
      await _tap(tester, find.byKey(const Key('projectEdit')));
      await tester.enterText(_input('projFieldBudget'), '6000');
      await _tap(tester, find.byKey(const Key('projSave')));
      expect(find.byType(ProjectDetailsScreen), findsOneWidget);
      expect(_text(tester, const Key('projectBudget')), r'$6,000.00');
      final p = c
          .read(projectsProvider)
          .value!
          .firstWhere((x) => x.id == 'proj-roof');
      expect(p.history.last.note, contains(r'$5,000.00 → $6,000.00'));
      expect(p.history.length, 2); // earlier history kept
    });

    testWidgets('cancel with changes asks before discarding', (tester) async {
      await _open(tester, AppRoutes.project('proj-roof'), admin: true);
      await _tap(tester, find.byKey(const Key('projectEdit')));
      await tester.enterText(_input('projFieldTitle'), 'Changed');
      await tester.pump();
      await _tap(tester, find.byKey(const Key('projCancel')));
      expect(find.text('Ma tuuraysaa isbeddellada?'), findsOneWidget);
      await _tap(tester, find.byKey(const Key('discardConfirm')));
      expect(find.byType(ProjectDetailsScreen), findsOneWidget);
      expect(find.text('Changed'), findsNothing);
    });

    testWidgets('add a draft update, then edit it (history kept)', (
      tester,
    ) async {
      final c = await _open(
        tester,
        AppRoutes.project('proj-roof'),
        admin: true,
      );
      await _tap(tester, find.byKey(const Key('projectAddUpdate')));
      await _tap(tester, find.byKey(const Key('updSave')));
      expect(find.text('Meeshan waa in la buuxiyaa'), findsNWidgets(2));
      await tester.enterText(_input('updFieldTitle'), 'Saqafka bilow');
      await tester.enterText(
        _input('updFieldDescription'),
        'Shaqadu way bilaabatay',
      );
      await tester.enterText(_input('updFieldPercent'), '101');
      await _tap(tester, find.byKey(const Key('updSave')));
      expect(
        find.text('Geli tiro dhan oo u dhaxaysa 0 iyo 100.'),
        findsOneWidget,
      );
      await tester.enterText(_input('updFieldPercent'), '40');
      await _tap(tester, find.byKey(const Key('updFieldPublished')));
      await _tap(tester, find.byKey(const Key('updSave')));
      expect(find.byType(ProjectDetailsScreen), findsOneWidget);
      expect(find.text('Saqafka bilow'), findsOneWidget);
      expect(find.text('Qabyo'), findsWidgets);

      final created = c
          .read(projectUpdatesProvider)
          .value!
          .firstWhere((u) => u.title == 'Saqafka bilow');
      expect(created.isPublished, isFalse);
      await _tap(tester, find.byKey(ValueKey('editUpdate-${created.id}')));
      await tester.enterText(_input('updFieldTitle'), 'Saqafka: tallaabada 1');
      await _tap(tester, find.byKey(const Key('updSave')));
      final edited = c
          .read(projectUpdatesProvider)
          .value!
          .firstWhere((u) => u.id == created.id);
      expect(edited.title, 'Saqafka: tallaabada 1');
      expect(edited.revisions.single.title, 'Saqafka bilow');
    });
  });

  group('Layout', () {
    const cases = <String, (Size, double, String, bool)>{
      'small Android 320x568 @200%': (Size(320, 568), 2.0, 'so', false),
      'Arabic 360x780 @130%': (Size(360, 780), 1.3, 'ar', false),
      'dark mode 400x800': (Size(400, 800), 1.0, 'so', true),
    };
    for (final MapEntry(key: name, value: (size, scale, locale, dark))
        in cases.entries) {
      testWidgets('projects screens have no overflow on $name', (tester) async {
        await _open(
          tester,
          AppRoutes.projects,
          locale: locale,
          size: size,
          scale: scale,
          admin: true,
          prefs: dark ? {'theme_mode': 'dark'} : const {},
        );
        expect(tester.takeException(), isNull);
        for (final route in [
          AppRoutes.project('proj-construction'),
          AppRoutes.project('proj-well'),
          AppRoutes.editProject('proj-construction'),
          AppRoutes.newProjectUpdate('proj-construction'),
        ]) {
          await goTo(tester, route);
          expect(tester.takeException(), isNull, reason: route);
        }
      });
    }
  });
}
