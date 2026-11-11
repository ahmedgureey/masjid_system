import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/application/demo_session_provider.dart';
import '../../donations/models/money.dart';
import '../../mosque/data/mosque_repository.dart';
import '../models/project_models.dart';

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
}

class LocalProjectsRepository implements ProjectsRepository {
  LocalProjectsRepository({
    required DateTime seedDate,
    this.latency = const Duration(milliseconds: 400),
    List<MosqueProject>? projects,
    List<ProjectUpdate>? updates,
  }) : _projects = projects ?? sampleProjects(seedDate),
       _updates = updates ?? sampleUpdates(seedDate);

  final Duration latency;
  final List<MosqueProject> _projects;
  final List<ProjectUpdate> _updates;
  int _sequence = 0;

  Future<void> _wait() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  @override
  Future<List<MosqueProject>> getProjects({required String mosqueId}) async {
    await _wait();
    return [
      for (final p in _projects)
        if (p.mosqueId == mosqueId) p,
    ];
  }

  @override
  Future<MosqueProject> saveProject(MosqueProject project) async {
    await _wait();
    final i = _projects.indexWhere((p) => p.id == project.id);
    if (i >= 0) {
      _projects[i] = project;
    } else {
      _projects.add(project);
    }
    return project;
  }

  @override
  Future<List<ProjectUpdate>> getUpdates({required String mosqueId}) async {
    await _wait();
    final ids = {
      for (final p in _projects)
        if (p.mosqueId == mosqueId) p.id,
    };
    return [
      for (final u in _updates)
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
    final i = _updates.indexWhere((u) => u.id == update.id);
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
      _updates.add(created);
      return created;
    }
    final old = _updates[i];
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
    _updates[i] = saved;
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
  (ref) => LocalProjectsRepository(seedDate: DateTime.now()),
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
