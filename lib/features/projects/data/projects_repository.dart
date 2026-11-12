import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/local_collection_store.dart';
import '../../authentication/application/demo_session_provider.dart';
import '../../donations/models/money.dart';
import '../../mosque/data/mosque_repository.dart';
import '../models/project_models.dart';
import 'project_json.dart';

/// Source of projects and their progress updates.
///
/// Today: [LocalProjectsRepository] — in-memory MOCK data, every record
/// titled "TUSAALE" and flagged `isSample`. Supabase phase: tables
/// `projects`, `project_milestones`, `project_updates` (+ images /
/// documents in Storage), scoped by `mosque_id` with Row Level Security.
/// Money is not stored here: funding comes from the Donations module.
abstract interface class ProjectsRepository {
  Future<List<MosqueProject>> getProjects({required String mosqueId});

  /// Inserts or updates (matched by id); keeps the change history.
  Future<MosqueProject> saveProject(MosqueProject project);

  Future<List<ProjectUpdate>> getUpdates({required String mosqueId});

  /// Inserts or edits an update. Editing keeps the previous version in
  /// [ProjectUpdate.revisions] (history is never overwritten).
  Future<ProjectUpdate> saveUpdate(
    ProjectUpdate update, {
    required String editor,
    required DateTime now,
  });

  /// Removes the project with [id] and every update belonging to it.
  /// Leaving the updates behind would keep them in storage for ever with no
  /// screen that can reach them. Removing a project that is already gone is
  /// not an error.
  Future<void> deleteProject(String id);

  /// Removes a single progress update. Removing one that is already gone is
  /// not an error.
  Future<void> deleteUpdate(String id);
}

/// Projects and their progress updates, held on the device.
///
/// With a [store], the samples are written once on the very first run and
/// are ordinary rows from then on: the user can edit them, delete them and
/// add their own, and all of it survives closing the app. Deleting every
/// sample does not bring it back — the store seeds on "never written", not
/// on "empty".
///
/// Without a [store] it is purely in-memory, which is what the widget tests
/// want: they pass [projects] / [updates] and assert on what they passed.
class LocalProjectsRepository implements ProjectsRepository {
  LocalProjectsRepository({
    required this.seedDate,
    this.store,
    this.latency = const Duration(milliseconds: 400),
    List<MosqueProject>? projects,
    List<ProjectUpdate>? updates,
  }) : // Copied: the lists passed in must not be mutated by saves or deletes.
       _projects = projects == null ? null : List<MosqueProject>.of(projects),
       _updates = updates == null ? null : List<ProjectUpdate>.of(updates);

  final Duration latency;

  /// What the sample dates are built around.
  final DateTime seedDate;

  /// Null in tests that work purely in memory.
  final LocalCollectionStore? store;

  static const String projectsCollection = 'projects';
  static const String updatesCollection = 'project_updates';

  /// Null until first loaded, so a store-backed repository does not read the
  /// device in its constructor.
  List<MosqueProject>? _projects;
  List<ProjectUpdate>? _updates;
  int _sequence = 0;

  Future<void> _wait() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  Future<List<MosqueProject>> _loadedProjects() async {
    final cached = _projects;
    if (cached != null) return cached;
    final store = this.store;
    return _projects = store == null
        ? sampleProjects(seedDate)
        : ProjectJson.listFrom(
            await store.readOrSeed(
              projectsCollection,
              () => ProjectJson.listTo(sampleProjects(seedDate)),
            ),
          );
  }

  Future<List<ProjectUpdate>> _loadedUpdates() async {
    final cached = _updates;
    if (cached != null) return cached;
    final store = this.store;
    return _updates = store == null
        ? sampleUpdates(seedDate)
        : ProjectJson.updatesFrom(
            await store.readOrSeed(
              updatesCollection,
              () => ProjectJson.updatesTo(sampleUpdates(seedDate)),
            ),
          );
  }

  /// Writes both lists back. A no-op without a store.
  Future<void> _flush() async {
    final store = this.store;
    if (store == null) return;
    await store.write(
      projectsCollection,
      ProjectJson.listTo(_projects ?? const []),
    );
    await store.write(
      updatesCollection,
      ProjectJson.updatesTo(_updates ?? const []),
    );
  }

  @override
  Future<List<MosqueProject>> getProjects({required String mosqueId}) async {
    await _wait();
    return [
      for (final p in await _loadedProjects())
        if (p.mosqueId == mosqueId) p,
    ];
  }

  @override
  Future<MosqueProject> saveProject(MosqueProject project) async {
    await _wait();
    final projects = await _loadedProjects();
    final i = projects.indexWhere((p) => p.id == project.id);
    if (i >= 0) {
      projects[i] = project;
    } else {
      projects.add(project);
    }
    await _flush();
    return project;
  }

  @override
  Future<void> deleteProject(String id) async {
    await _wait();
    final projects = await _loadedProjects();
    final updates = await _loadedUpdates();
    projects.removeWhere((p) => p.id == id);
    updates.removeWhere((u) => u.projectId == id);
    await _flush();
  }

  @override
  Future<void> deleteUpdate(String id) async {
    await _wait();
    final updates = await _loadedUpdates();
    updates.removeWhere((u) => u.id == id);
    await _flush();
  }

  @override
  Future<List<ProjectUpdate>> getUpdates({required String mosqueId}) async {
    await _wait();
    final ids = {
      for (final p in await _loadedProjects())
        if (p.mosqueId == mosqueId) p.id,
    };
    return [
      for (final u in await _loadedUpdates())
        if (ids.contains(u.projectId)) u,
    ];
  }

  @override
  Future<ProjectUpdate> saveUpdate(
    ProjectUpdate update, {
    required String editor,
    required DateTime now,
  }) async {
    await _wait();
    final updates = await _loadedUpdates();
    final i = updates.indexWhere((u) => u.id == update.id);
    if (i < 0) {
      final created = ProjectUpdate(
        id: update.id.isEmpty ? 'upd-local-${++_sequence}' : update.id,
        projectId: update.projectId,
        title: update.title,
        description: update.description,
        date: update.date,
        progressPercent: update.progressPercent,
        milestoneId: update.milestoneId,
        author: update.author,
        isPublished: update.isPublished,
      );
      updates.add(created);
      await _flush();
      return created;
    }
    final old = updates[i];
    final textChanged =
        old.title != update.title || old.description != update.description;
    final saved = ProjectUpdate(
      id: old.id,
      projectId: old.projectId,
      title: update.title,
      description: update.description,
      date: update.date,
      progressPercent: update.progressPercent,
      milestoneId: update.milestoneId,
      author: old.author,
      isPublished: update.isPublished,
      revisions: [
        ...old.revisions,
        if (textChanged)
          UpdateRevision(
            title: old.title,
            description: old.description,
            editedAt: now,
            editedBy: editor,
          ),
      ],
      imageUrls: old.imageUrls,
      isSample: old.isSample,
    );
    updates[i] = saved;
    await _flush();
    return saved;
  }

  // -------------------------------------------------------------------------
  // SAMPLE DATA — clearly labelled, not real projects.
  // -------------------------------------------------------------------------

  static const String sampleMosqueId = 'al-ikhlas';

  static const String _note =
      'Tani waa mashruuc tusaale ah (mock) oo loogu talagalay tijaabinta '
      'naqshadda app-ka. Ma aha mashruuc rasmi ah oo masaajidka.';

  static List<MosqueProject> sampleProjects(DateTime seed) {
    DateTime day(int offset) =>
        DateTime(seed.year, seed.month, seed.day + offset);
    MosqueProject p(
      String id,
      String title,
      String categoryId,
      int budgetUsd,
      ProjectStatus status, {
      String? campaignId,
      bool featured = false,
      int? progress,
      int created = -30,
      int? start,
      int? end,
      List<ProjectMilestone> milestones = const [],
      Currency currency = Currency.usd,
    }) => MosqueProject(
      id: id,
      mosqueId: sampleMosqueId,
      title: 'TUSAALE: $title',
      summary: 'Tusaale sharraxaad gaaban oo mashruuca ah.',
      description: _note,
      categoryId: categoryId,
      location: 'Tusaale: agagaarka masaajidka',
      manager: 'Tusaale: guddiga mashaariicda',
      budget: Money.major(budgetUsd, currency),
      startDate: start == null ? null : day(start),
      expectedEndDate: end == null ? null : day(end),
      status: status,
      isFeatured: featured,
      fundingCampaignId: campaignId,
      physicalProgress: progress,
      progressNote: progress == null
          ? null
          : 'Tusaale: horumarka shaqada waxaa geliyay maamulaha.',
      objectives: 'Tusaale: ujeeddooyinka mashruuca.',
      beneficiaries: 'Tusaale: jamaacada masaajidka.',
      milestones: milestones,
      createdAt: day(created),
      updatedAt: day(created + 5),
      history: [
        ProjectChange(
          at: day(created),
          actor: 'Tusaale: maamulaha',
          note: 'Mashruuca waa la sameeyay',
        ),
      ],
      isSample: true,
    );

    return [
      p(
        'proj-construction',
        'Dhismaha masaajid cusub',
        'construction',
        50000,
        ProjectStatus.ongoing,
        campaignId: 'camp-construction',
        featured: true,
        progress: 25,
        created: -60,
        start: -60,
        end: 300,
        milestones: [
          ProjectMilestone(
            id: 'ms-land',
            title: 'Diyaarinta dhulka',
            status: MilestoneStatus.completed,
            dueDate: day(-40),
            completedDate: day(-42),
          ),
          ProjectMilestone(
            id: 'ms-foundation',
            title: 'Aasaaska',
            status: MilestoneStatus.inProgress,
            dueDate: day(20),
          ),
          ProjectMilestone(
            id: 'ms-walls',
            title: 'Darbiyada',
            dueDate: day(120),
          ),
          ProjectMilestone(id: 'ms-roof', title: 'Saqafka', dueDate: day(220)),
        ],
      ),
      p(
        'proj-roof',
        'Dayactirka saqafka',
        'maintenance',
        5000,
        ProjectStatus.ongoing,
        campaignId: 'camp-maintenance',
        progress: 60,
        created: -20,
        start: -15,
        end: 45,
      ),
      p(
        'proj-solar',
        'Rakibidda tamarta qorraxda',
        'electricity',
        1200,
        ProjectStatus.completed,
        campaignId: 'camp-utilities',
        featured: true,
        progress: 100,
        created: -90,
        start: -80,
        end: -10,
      ),
      p(
        'proj-quran-school',
        "Dugsi Qur'aan cusub",
        'quran-education',
        3000,
        ProjectStatus.planned,
        campaignId: 'camp-quran',
        created: -5,
        start: 30,
        end: 200,
      ),
      // No linked campaign and zero budget: volunteer work.
      p(
        'proj-well',
        'Ceel biyo (mutadawacin)',
        'water',
        0,
        ProjectStatus.planned,
        created: -2,
      ),
      p(
        'proj-fans',
        'Marawaxadaha iyo codbaahiyaha',
        'equipment',
        800,
        ProjectStatus.paused,
        created: -40,
        start: -35,
      ),
      p(
        'proj-community',
        'Barnaamij bulsho',
        'community',
        600,
        ProjectStatus.cancelled,
        created: -100,
      ),
    ];
  }

  static List<ProjectUpdate> sampleUpdates(DateTime seed) {
    DateTime day(int offset) =>
        DateTime(seed.year, seed.month, seed.day + offset);
    return [
      ProjectUpdate(
        id: 'upd-1',
        projectId: 'proj-construction',
        title: 'TUSAALE: Dhulka waa la diyaariyay',
        description:
            'Tusaale cusbooneysiin ah: diyaarinta dhulka waa la dhammeeyay.',
        date: day(-42),
        progressPercent: 10,
        milestoneId: 'ms-land',
        author: 'Tusaale: maamulaha',
        isPublished: true,
        isSample: true,
      ),
      ProjectUpdate(
        id: 'upd-2',
        projectId: 'proj-construction',
        title: 'TUSAALE: Aasaaska ayaa socda',
        description: 'Tusaale cusbooneysiin ah oo ku saabsan aasaaska.',
        date: day(-5),
        progressPercent: 25,
        author: 'Tusaale: maamulaha',
        isPublished: true,
        isSample: true,
      ),
      ProjectUpdate(
        id: 'upd-draft',
        projectId: 'proj-construction',
        title: 'TUSAALE: Qabyo aan la daabicin',
        description: 'Cusbooneysiin weli qabyo ah.',
        date: day(-1),
        author: 'Tusaale: maamulaha',
        isPublished: false,
        isSample: true,
      ),
    ];
  }
}

final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) => LocalProjectsRepository(
    seedDate: DateTime.now(),
    store: ref.watch(localCollectionStoreProvider),
  ),
);

Future<String> _mosqueId(Ref ref) async =>
    (await ref.watch(mosqueProvider.future)).id;

/// Projects of the current mosque.
final projectsProvider =
    AsyncNotifierProvider<ProjectsController, List<MosqueProject>>(
      ProjectsController.new,
    );

class ProjectsController extends AsyncNotifier<List<MosqueProject>> {
  @override
  Future<List<MosqueProject>> build() async => ref
      .read(projectsRepositoryProvider)
      .getProjects(mosqueId: await _mosqueId(ref));

  Future<MosqueProject> save(MosqueProject project) async {
    final saved = await ref
        .read(projectsRepositoryProvider)
        .saveProject(project);
    final list = [...?state.value];
    final i = list.indexWhere((p) => p.id == saved.id);
    if (i >= 0) {
      list[i] = saved;
    } else {
      list.add(saved);
    }
    state = AsyncData(list);
    return saved;
  }

  /// Deletes through the repository; throws on failure (state unchanged).
  ///
  /// The repository also drops that project's updates, so the updates list
  /// is invalidated rather than patched: it is derived from the projects
  /// that still exist, and recomputing it is cheaper than keeping two lists
  /// in step by hand.
  Future<void> delete(String id) async {
    await ref.read(projectsRepositoryProvider).deleteProject(id);
    state = AsyncData([...?state.value]..removeWhere((p) => p.id == id));
    ref.invalidate(projectUpdatesProvider);
  }
}

/// All updates of the current mosque's projects (filter per project in UI).
final projectUpdatesProvider =
    AsyncNotifierProvider<ProjectUpdatesController, List<ProjectUpdate>>(
      ProjectUpdatesController.new,
    );

class ProjectUpdatesController extends AsyncNotifier<List<ProjectUpdate>> {
  @override
  Future<List<ProjectUpdate>> build() async => ref
      .read(projectsRepositoryProvider)
      .getUpdates(mosqueId: await _mosqueId(ref));

  Future<ProjectUpdate> save(
    ProjectUpdate update, {
    required DateTime now,
  }) async {
    final editor = ref.read(demoSessionProvider)?.displayName ?? '—';
    final saved = await ref
        .read(projectsRepositoryProvider)
        .saveUpdate(update, editor: editor, now: now);
    final list = [...?state.value];
    final i = list.indexWhere((u) => u.id == saved.id);
    if (i >= 0) {
      list[i] = saved;
    } else {
      list.add(saved);
    }
    state = AsyncData(list);
    return saved;
  }
}

/// Whether the current user may create / edit projects, milestones and
/// updates.
///
/// FRONTEND-ONLY AND INCOMPLETE: anyone signed in through the demo login
/// counts as a Mosque Admin. This only shows/hides UI and guards routes; it
/// is NOT security. Real roles (Super Admin, Mosque Admin, Treasurer,
/// Staff) must be enforced by the backend with Row Level Security.
final canManageProjectsProvider = Provider<bool>(
  (ref) => ref.watch(demoSessionProvider) != null,
);
