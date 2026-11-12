import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/clock_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../routing/navigation_guard.dart';
import '../application/event_permissions.dart';
import '../application/event_reminders.dart';
import '../data/events_repository.dart';
import '../models/event_labels.dart';
import '../models/mosque_event.dart';
import '../widgets/event_card.dart';

/// "Faahfaahinta Dhacdada". Sharing is not offered (no share mechanism in
/// the app yet); the reminder button is disabled until reminders exist.
class EventDetailsScreen extends ConsumerWidget {
  const EventDetailsScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final eventsAsync = ref.watch(eventsProvider);
    final canManage = ref.watch(canManageEventsProvider);
    final event = eventsAsync.value?.where((e) => e.id == eventId).firstOrNull;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.eventDetailsTitle,
        actions: [
          if (canManage && event != null) ...[
            IconButton(
              tooltip: l10n.profileEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () =>
                  context.pushIfCurrent(AppRoutes.editEvent(event.id)),
            ),
            IconButton(
              key: const Key('eventDelete'),
              tooltip: l10n.commonDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _delete(context, ref, event),
            ),
          ],
        ],
      ),
      body: SafeArea(
        top: false,
        child: eventsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(eventsProvider)),
          data: (_) => event == null
              ? EmptyState(
                  icon: Icons.event_busy_rounded,
                  title: l10n.eventNotFound,
                )
              : _Details(event: event),
        ),
      ),
    );
  }

  /// Confirms, deletes, then leaves: staying on the details of an event that
  /// no longer exists would only show the "not found" empty state.
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    MosqueEvent event,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!await confirmDelete(context, title: l10n.deleteEventTitle)) return;

    try {
      await ref.read(eventsProvider.notifier).delete(event.id);
    } on Object {
      // The event is still there, so stay on the page and say so rather than
      // popping back to a list that still shows it.
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteFailed)));
      return;
    }
    if (navigator.canPop()) navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.deleteDone)));
  }
}

class _Details extends ConsumerWidget {
  const _Details({required this.event});

  final MosqueEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final lang = ref.watch(localeProvider).languageCode;
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);
    final reminders = ref.watch(eventReminderServiceProvider);
    final imageUrl = event.imageUrl;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.isSample) ...[
            AppCard(
              variant: AppCardVariant.gold,
              child: Text(
                l10n.eventsMockTitle,
                style: textTheme.bodySmall?.copyWith(color: AppColors.gold800),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
          ],
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const ColoredBox(color: AppColors.green50),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
          ],
          Wrap(
            spacing: AppSpacing.space2,
            runSpacing: AppSpacing.space1,
            children: [
              StatusChip(
                label: event.category.label(l10n),
                icon: event.category.icon,
              ),
              eventStatusChip(event, now, l10n),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            event.title,
            key: const Key('eventDetailsTitle'),
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.green800,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          AppCard(
            child: Column(
              children: [
                _Row(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.eventDate,
                  value: AppDateFormatter.fullDate(event.start, locale: lang),
                ),
                _Row(
                  icon: Icons.schedule_rounded,
                  label: l10n.eventTime,
                  value: eventTimeRange(
                    event,
                    languageCode: lang,
                    use24h: use24h,
                  ),
                ),
                _Row(
                  icon: Icons.place_outlined,
                  label: l10n.eventLocation,
                  value: event.location,
                ),
                if (event.organizer != null)
                  _Row(
                    icon: Icons.person_outline_rounded,
                    label: l10n.eventOrganizer,
                    value: event.organizer!,
                  ),
                _Row(
                  icon: event.category.icon,
                  label: l10n.eventCategory,
                  value: event.category.label(l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.eventDescription, style: textTheme.titleSmall),
                const SizedBox(height: AppSpacing.space2),
                Text(event.description, style: textTheme.bodyMedium),
              ],
            ),
          ),
          if (event.registration != null) ...[
            const SizedBox(height: AppSpacing.space3),
            AppCard(
              variant: AppCardVariant.tinted,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.how_to_reg_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.space2),
                      Expanded(
                        child: Text(
                          l10n.eventRegistrationRequired,
                          style: textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(event.registration!.details),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.space4),
          // Reminders are not implemented: disabled, with the reason shown.
          AppButton.secondary(
            key: const Key('eventReminderButton'),
            label: l10n.eventReminder,
            icon: Icons.notifications_none_rounded,
            expand: true,
            onPressed: reminders.isAvailable ? () {} : null,
          ),
          if (!reminders.isAvailable) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              l10n.eventReminderUnavailable,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
                Text(value, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
