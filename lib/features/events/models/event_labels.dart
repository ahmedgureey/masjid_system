import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'islamic_occasion.dart';
import 'mosque_event.dart';

extension EventCategoryLabels on EventCategory {
  String label(AppLocalizations l10n) => switch (this) {
    EventCategory.quranClasses => l10n.eventCatQuran,
    EventCategory.lectures => l10n.eventCatLectures,
    EventCategory.religiousLessons => l10n.eventCatLessons,
    EventCategory.communityMeetings => l10n.eventCatCommunity,
    EventCategory.childrenPrograms => l10n.eventCatChildren,
    EventCategory.youthPrograms => l10n.eventCatYouth,
    EventCategory.ramadanPrograms => l10n.eventCatRamadan,
    EventCategory.eidCelebrations => l10n.eventCatEid,
    EventCategory.other => l10n.eventCatOther,
  };

  IconData get icon => switch (this) {
    EventCategory.quranClasses => Icons.menu_book_rounded,
    EventCategory.lectures => Icons.record_voice_over_rounded,
    EventCategory.religiousLessons => Icons.school_rounded,
    EventCategory.communityMeetings => Icons.groups_rounded,
    EventCategory.childrenPrograms => Icons.child_care_rounded,
    EventCategory.youthPrograms => Icons.diversity_3_rounded,
    EventCategory.ramadanPrograms => Icons.nightlight_round,
    EventCategory.eidCelebrations => Icons.celebration_rounded,
    EventCategory.other => Icons.event_rounded,
  };
}

extension EventStatusLabels on EventStatus {
  String label(AppLocalizations l10n) => switch (this) {
    EventStatus.scheduled => l10n.eventStatusScheduled,
    EventStatus.postponed => l10n.eventStatusPostponed,
    EventStatus.cancelled => l10n.eventStatusCancelled,
  };
}

extension EventFilterLabels on EventFilter {
  String label(AppLocalizations l10n) => switch (this) {
    EventFilter.all => l10n.eventFilterAll,
    EventFilter.upcoming => l10n.eventFilterUpcoming,
    EventFilter.past => l10n.eventFilterPast,
    EventFilter.quranClasses => l10n.eventCatQuran,
    EventFilter.lectures => l10n.eventCatLectures,
    EventFilter.communityMeetings => l10n.eventCatCommunity,
    EventFilter.islamicOccasions => l10n.eventFilterOccasions,
  };

  /// Heading of the list when no date is selected.
  String listTitle(AppLocalizations l10n) => switch (this) {
    EventFilter.upcoming => l10n.eventsUpcomingTitle,
    EventFilter.past => l10n.eventsPastTitle,
    EventFilter.all => l10n.eventsAllTitle,
    _ => label(l10n),
  };
}

extension IslamicOccasionLabels on IslamicOccasionType {
  String label(AppLocalizations l10n) => switch (this) {
    IslamicOccasionType.islamicNewYear => l10n.occasionIslamicNewYear,
    IslamicOccasionType.ashura => l10n.occasionAshura,
    IslamicOccasionType.ramadanStart => l10n.occasionRamadanStart,
    IslamicOccasionType.eidAlFitr => l10n.occasionEidFitr,
    IslamicOccasionType.dayOfArafah => l10n.occasionArafah,
    IslamicOccasionType.eidAlAdha => l10n.occasionEidAdha,
  };
}

/// Status chip of an event at [now]: admin status wins over timing.
StatusChip eventStatusChip(
  MosqueEvent event,
  DateTime now,
  AppLocalizations l10n,
) {
  switch (event.status) {
    case EventStatus.cancelled:
      return StatusChip(
        label: l10n.eventStatusCancelled,
        type: StatusType.error,
        icon: Icons.cancel_outlined,
      );
    case EventStatus.postponed:
      return StatusChip(
        label: l10n.eventStatusPostponed,
        type: StatusType.warning,
        icon: Icons.update_rounded,
      );
    case EventStatus.scheduled:
      return switch (event.timingAt(now)) {
        EventTiming.upcoming => StatusChip(
          label: l10n.eventTimingUpcoming,
          type: StatusType.info,
          icon: Icons.schedule_rounded,
        ),
        EventTiming.ongoing => StatusChip(
          label: l10n.eventTimingOngoing,
          type: StatusType.success,
          icon: Icons.play_circle_outline_rounded,
        ),
        EventTiming.ended => StatusChip(
          label: l10n.eventTimingEnded,
          icon: Icons.check_circle_outline_rounded,
        ),
      };
  }
}
