import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import 'auth_service.dart';

/// What to tell the user about a failed [AuthResult].
///
/// One place, so sign-in, registration and password reset cannot drift into
/// saying different things about the same failure.
@immutable
class AuthMessage {
  const AuthMessage({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;
}

/// [result] must not be [AuthResult.success] — success is not a message.
///
/// [offlineMessage] is the wording for [AuthResult.backendUnavailable], which
/// differs per screen ("nothing was saved" / "nothing was sent").
AuthMessage authMessageFor(
  AuthResult result,
  AppLocalizations l10n, {
  required String unavailableMessage,
}) {
  assert(result != AuthResult.success, 'success has no message');
  return switch (result) {
    AuthResult.success => throw ArgumentError('success has no message'),
    AuthResult.invalidCredentials => AuthMessage(
      title: l10n.authInvalidTitle,
      message: l10n.authInvalidMessage,
      icon: Icons.lock_outline_rounded,
    ),
    AuthResult.emailAlreadyRegistered => AuthMessage(
      title: l10n.authEmailExistsTitle,
      message: l10n.authEmailExistsMessage,
      icon: Icons.person_outline_rounded,
    ),
    AuthResult.emailNotConfirmed => AuthMessage(
      title: l10n.authConfirmEmailTitle,
      message: l10n.authConfirmEmailMessage,
      icon: Icons.mark_email_unread_outlined,
    ),
    AuthResult.tooManyAttempts => AuthMessage(
      title: l10n.authTooManyTitle,
      message: l10n.authTooManyMessage,
      icon: Icons.hourglass_empty_rounded,
    ),
    AuthResult.networkError => AuthMessage(
      title: l10n.authOfflineTitle,
      message: l10n.authOfflineMessage,
      icon: Icons.wifi_off_rounded,
    ),
    AuthResult.emailDeliveryFailed => AuthMessage(
      title: l10n.authEmailSendFailedTitle,
      message: l10n.authEmailSendFailedMessage,
      icon: Icons.outgoing_mail,
    ),
    AuthResult.serverError => AuthMessage(
      title: l10n.authServerErrorTitle,
      message: l10n.authServerErrorMessage,
      icon: Icons.report_gmailerrorred_rounded,
    ),
    AuthResult.backendUnavailable => AuthMessage(
      title: l10n.mockTitle,
      message: unavailableMessage,
      icon: Icons.cloud_off_rounded,
    ),
  };
}
