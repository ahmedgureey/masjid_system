import 'package:flutter/foundation.dart';

import '../../donations/models/money.dart';

/// Project lifecycle (future column `projects.status`).
enum ProjectStatus { planned, ongoing, paused, completed, cancelled }

enum MilestoneStatus { pending, inProgress, completed }

/// A step that communicates real (physical) progress, e.g. "Foundation
/// completed".
@immutable
class ProjectMilestone {
  const ProjectMilestone({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.completedDate,
    this.status = MilestoneStatus.pending,
  });

  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime? completedDate;
  final MilestoneStatus status;

  bool get isCompleted => status == MilestoneStatus.completed;
}

/// One entry of a project's change history (who changed what, when).
/// In memory today; the backend keeps an insert-only audit log.
@immutable
class ProjectChange {
  const ProjectChange({
    required this.at,
    required this.actor,
    required this.note,
  });

  final DateTime at;
  final String actor;
  final String note;
}

/// A mosque project (future table `projects`).
///
/// Funding is NOT stored here: the amount raised is always calculated from
/// confirmed donations of the linked fundraising campaign
/// ([fundingCampaignId]) in the existing Donations module — one source of
/// truth, nothing counted twice. Physical progress ([physicalProgress],
/// milestones, updates) is kept separate from funding progress.
@immutable
class MosqueProject {
  const MosqueProject({
    required this.id,
    required this.mosqueId,
    required this.title,
    required this.summary,
    this.description = '',
    required this.categoryId,
    this.location,
    this.manager,
    required this.budget,
    this.fundingTarget,
    this.startDate,
    this.expectedEndDate,
    required this.status,
    this.isFeatured = false,
    this.fundingCampaignId,
    this.physicalProgress,
    this.progressNote,
    this.objectives,
    this.beneficiaries,
    this.milestones = const [],
    this.coverImageUrl,
    this.imageUrls = const [],
    required this.createdAt,
    required this.updatedAt,
    this.history = const [],
    this.isSample = false,
  });

  final String id;
  final String mosqueId;
  final String title;
  final String summary;
  final String description;
  final String categoryId;
  final String? location;

  /// Responsible person or department.
  final String? manager;

  /// Total project budget (a plan, not money spent).
  final Money budget;

  /// Amount to fundraise; defaults to [budget].
  final Money? fundingTarget;
  final DateTime? startDate;
  final DateTime? expectedEndDate;
  final ProjectStatus status;
  final bool isFeatured;

  /// Existing donation campaign that collects money for this project.
  final String? fundingCampaignId;

  /// Physical progress 0–100 entered by an administrator (null = unknown).
  final int? physicalProgress;
  final String? progressNote;
  final String? objectives;
  final String? beneficiaries;
  final List<ProjectMilestone> milestones;
  final String? coverImageUrl;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProjectChange> history;

  /// Clearly identified mock data.
  final bool isSample;

  Money get effectiveFundingTarget => fundingTarget ?? budget;

  MosqueProject copyWith({DateTime? updatedAt, List<ProjectChange>? history}) =>
      MosqueProject(
        id: id,
        mosqueId: mosqueId,
        title: title,
        summary: summary,
        description: description,
        categoryId: categoryId,
        location: location,
        manager: manager,
        budget: budget,
        fundingTarget: fundingTarget,
        startDate: startDate,
        expectedEndDate: expectedEndDate,
        status: status,
        isFeatured: isFeatured,
        fundingCampaignId: fundingCampaignId,
        physicalProgress: physicalProgress,
        progressNote: progressNote,
        objectives: objectives,
        beneficiaries: beneficiaries,
        milestones: milestones,
        coverImageUrl: coverImageUrl,
        imageUrls: imageUrls,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        history: history ?? this.history,
        isSample: isSample,
      );
}

/// Earlier version of an edited update (history is never overwritten).
@immutable
class UpdateRevision {
  const UpdateRevision({
    required this.title,
    required this.description,
    required this.editedAt,
    required this.editedBy,
  });

  final String title;
  final String description;
  final DateTime editedAt;
  final String editedBy;
}

/// A progress update (future table `project_updates`). Ordinary users see
/// only published updates.
@immutable
class ProjectUpdate {
  const ProjectUpdate({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.date,
    this.progressPercent,
    this.milestoneId,
    required this.author,
    required this.isPublished,
    this.revisions = const [],
    this.imageUrls = const [],
    this.isSample = false,
  });

  final String id;
  final String projectId;
  final String title;
  final String description;
  final DateTime date;
  final int? progressPercent;

  /// Milestone achieved with this update, if any.
  final String? milestoneId;
  final String author;
  final bool isPublished;

  /// Previous versions, oldest first.
  final List<UpdateRevision> revisions;
  final List<String> imageUrls;
  final bool isSample;
}
