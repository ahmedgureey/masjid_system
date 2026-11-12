import 'package:material_ui/material_ui.dart';

import '../localization/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Asks before deleting something, and reports true only on a real "yes".
///
/// One helper rather than an [AlertDialog] per screen: deletion is the one
/// action in the app a user cannot undo, and the wording, the warning and
/// which button is destructive should not drift between the calendar, the
/// news list and the projects list.
///
/// Returns false when the dialog is dismissed by tapping outside or by the
/// back gesture, so a caller can treat anything but true as "do nothing".
/// [title] is the question ("Delete this event?"); the body defaults to
/// [AppLocalizations.deleteMessage], which says the data is on this device
/// and that this cannot be undone.
///
/// [message] replaces that body where the plain warning is not enough — a
/// donation or expense that counts in the mosque's totals says so, and
/// points at voiding instead, at the moment the choice is being made rather
/// than in a help page nobody opens.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  String? message,
}) async {
  final answer = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;
      return AlertDialog(
        icon: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.errorContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.error,
            size: 28,
          ),
        ),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(
          message ?? l10n.deleteMessage,
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.space6,
          0,
          AppSpacing.space6,
          AppSpacing.space5,
        ),
        actions: [
          // Cancel first and plain, delete second and red: the safe choice
          // should not be the one that sits under the thumb by default.
          TextButton(
            key: const Key('deleteCancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            key: const Key('deleteConfirm'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      );
    },
  );
  return answer ?? false;
}

/// Information dialog with one "OK" action.
Future<void> showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  IconData icon = Icons.info_outline_rounded,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.infoContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.info, size: 28),
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.space6,
        0,
        AppSpacing.space6,
        AppSpacing.space5,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dialogContext.l10n.commonOk),
          ),
        ),
      ],
    ),
  );
}
