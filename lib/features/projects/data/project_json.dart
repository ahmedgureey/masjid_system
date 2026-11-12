import '../../donations/models/money.dart';
import '../models/project_models.dart';

/// Maps [MosqueProject] and [ProjectUpdate] to and from the JSON stored on
/// the device.
///
/// Money is written as integer minor units plus a currency code, exactly as
/// [Money] holds it. Writing a formatted string, or a double, would lose the
/// precision the model exists to protect.
///
/// Reading is forgiving: a row written by a newer build, or one damaged by a
/// half-finished write, costs the user that project at worst, never the
/// ability to open the screen. The two `fromJson` methods return null for
/// anything unusable and callers drop it.
abstract final class ProjectJson {
  // ---------------------------------------------------------------------------
  // Project
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> toJson(MosqueProject p) => {
    'id': p.id,
    'mosque_id': p.mosqueId,
    'title': p.title,
    'summary': p.summary,
    'description': p.description,
    'category_id': p.categoryId,
    'location': p.location,
    'manager': p.manager,
    'budget': _moneyTo(p.budget),
    'funding_target': p.fundingTarget == null
        ? null
        : _moneyTo(p.fundingTarget!),
    'start_date': p.startDate?.toIso8601String(),
    'expected_end_date': p.expectedEndDate?.toIso8601String(),
    'status': p.status.name,
    'is_featured': p.isFeatured,
    'funding_campaign_id': p.fundingCampaignId,
    'physical_progress': p.physicalProgress,
    'progress_note': p.progressNote,
    'objectives': p.objectives,
    'beneficiaries': p.beneficiaries,
    'milestones': [
      for (final m in p.milestones)
        {
          'id': m.id,
          'title': m.title,
          'description': m.description,
          'due_date': m.dueDate?.toIso8601String(),
          'completed_date': m.completedDate?.toIso8601String(),
          'status': m.status.name,
        },
    ],
    'cover_image_url': p.coverImageUrl,
    'image_urls': p.imageUrls,
    'created_at': p.createdAt.toIso8601String(),
    'updated_at': p.updatedAt.toIso8601String(),
    'history': [
      for (final h in p.history)
        {
          'at': h.at.toIso8601String(),
          'actor': h.actor,
          'note': h.note,
        },
    ],
    'is_sample': p.isSample,
  };

  static MosqueProject? fromJson(Map<String, dynamic> row) {
    final id = row['id'];
    final budget = _moneyFrom(row['budget']);
    // Without an id there is nothing to update or delete later, and the
    // whole screen is built around a budget, so a project without one is not
    // worth guessing at.
    if (id is! String || id.isEmpty || budget == null) return null;

    final created = _date(row['created_at']) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return MosqueProject(
      id: id,
      mosqueId: _string(row['mosque_id']) ?? '',
      title: _string(row['title']) ?? '',
      summary: _string(row['summary']) ?? '',
      description: _string(row['description']) ?? '',
      categoryId: _string(row['category_id']) ?? '',
      location: _string(row['location']),
      manager: _string(row['manager']),
      budget: budget,
      fundingTarget: _moneyFrom(row['funding_target']),
      startDate: _date(row['start_date']),
      expectedEndDate: _date(row['expected_end_date']),
      status: _enum(ProjectStatus.values, row['status']) ??
          ProjectStatus.planned,
      isFeatured: row['is_featured'] == true,
      fundingCampaignId: _string(row['funding_campaign_id']),
      physicalProgress: _int(row['physical_progress']),
      progressNote: _string(row['progress_note']),
      objectives: _string(row['objectives']),
      beneficiaries: _string(row['beneficiaries']),
      milestones: _milestones(row['milestones']),
      coverImageUrl: _string(row['cover_image_url']),
      imageUrls: _strings(row['image_urls']),
      createdAt: created,
      updatedAt: _date(row['updated_at']) ?? created,
      history: _history(row['history']),
      isSample: row['is_sample'] == true,
    );
  }

  static List<MosqueProject> listFrom(Iterable<Map<String, dynamic>> rows) =>
      rows.map(fromJson).whereType<MosqueProject>().toList();

  static List<Map<String, dynamic>> listTo(Iterable<MosqueProject> items) =>
      items.map(toJson).toList();

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> updateToJson(ProjectUpdate u) => {
    'id': u.id,
    'project_id': u.projectId,
    'title': u.title,
    'description': u.description,
    'date': u.date.toIso8601String(),
    'progress_percent': u.progressPercent,
    'milestone_id': u.milestoneId,
    'author': u.author,
    'is_published': u.isPublished,
    'revisions': [
      for (final r in u.revisions)
        {
          'title': r.title,
          'description': r.description,
          'edited_at': r.editedAt.toIso8601String(),
          'edited_by': r.editedBy,
        },
    ],
    'image_urls': u.imageUrls,
    'is_sample': u.isSample,
  };

  static ProjectUpdate? updateFromJson(Map<String, dynamic> row) {
    final id = row['id'];
    final projectId = row['project_id'];
    // An update that belongs to no project can never be shown.
    if (id is! String || id.isEmpty) return null;
    if (projectId is! String || projectId.isEmpty) return null;

    return ProjectUpdate(
      id: id,
      projectId: projectId,
      title: _string(row['title']) ?? '',
      description: _string(row['description']) ?? '',
      date: _date(row['date']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      progressPercent: _int(row['progress_percent']),
      milestoneId: _string(row['milestone_id']),
      author: _string(row['author']) ?? '',
      isPublished: row['is_published'] == true,
      revisions: _revisions(row['revisions']),
      imageUrls: _strings(row['image_urls']),
      isSample: row['is_sample'] == true,
    );
  }

  static List<ProjectUpdate> updatesFrom(
    Iterable<Map<String, dynamic>> rows,
  ) => rows.map(updateFromJson).whereType<ProjectUpdate>().toList();

  static List<Map<String, dynamic>> updatesTo(Iterable<ProjectUpdate> items) =>
      items.map(updateToJson).toList();

  // ---------------------------------------------------------------------------
  // Parts
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _moneyTo(Money m) => {
    'minor': m.minor,
    'currency': m.currency.code,
  };

  static Money? _moneyFrom(Object? value) {
    if (value is! Map) return null;
    final minor = _int(value['minor']);
    if (minor == null) return null;
    final code = value['currency'];
    for (final currency in Currency.values) {
      if (currency.code == code) return Money(minor, currency);
    }
    return null;
  }

  static List<ProjectMilestone> _milestones(Object? value) {
    if (value is! List) return const [];
    final out = <ProjectMilestone>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final id = _string(entry['id']);
      if (id == null || id.isEmpty) continue;
      out.add(
        ProjectMilestone(
          id: id,
          title: _string(entry['title']) ?? '',
          description: _string(entry['description']),
          dueDate: _date(entry['due_date']),
          completedDate: _date(entry['completed_date']),
          status: _enum(MilestoneStatus.values, entry['status']) ??
              MilestoneStatus.pending,
        ),
      );
    }
    return out;
  }

  static List<ProjectChange> _history(Object? value) {
    if (value is! List) return const [];
    final out = <ProjectChange>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final at = _date(entry['at']);
      // An undated history line cannot be placed in the trail, and a trail
      // in the wrong order is worse than one entry short.
      if (at == null) continue;
      out.add(
        ProjectChange(
          at: at,
          actor: _string(entry['actor']) ?? '',
          note: _string(entry['note']) ?? '',
        ),
      );
    }
    return out;
  }

  static List<UpdateRevision> _revisions(Object? value) {
    if (value is! List) return const [];
    final out = <UpdateRevision>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final editedAt = _date(entry['edited_at']);
      if (editedAt == null) continue;
      out.add(
        UpdateRevision(
          title: _string(entry['title']) ?? '',
          description: _string(entry['description']) ?? '',
          editedAt: editedAt,
          editedBy: _string(entry['edited_by']) ?? '',
        ),
      );
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // Primitives
  // ---------------------------------------------------------------------------

  static String? _string(Object? v) => v is String ? v : null;

  static int? _int(Object? v) => v is num ? v.toInt() : null;

  static List<String> _strings(Object? v) =>
      v is List ? v.whereType<String>().toList() : const [];

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v) : null;

  static T? _enum<T extends Enum>(List<T> values, Object? v) {
    if (v is! String) return null;
    for (final value in values) {
      if (value.name == v) return value;
    }
    return null;
  }
}
