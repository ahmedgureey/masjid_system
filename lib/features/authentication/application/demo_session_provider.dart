import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/supabase_config.dart';
import '../../../services/local_storage_service.dart';
import 'auth_service.dart';

/// Who the app shows as signed in.
///
/// The display name, email and phone are kept on the device so a reload does
/// not sign the user out; the password is never saved. This is identity for
/// the UI, not proof: when a backend key is present, Supabase Auth has
/// verified the user and its own session is what the database trusts.
class DemoSession {
  const DemoSession({required this.displayName, this.email, this.phone});

  /// Name shown in the greeting (full name, or the part of the email
  /// before "@").
  final String displayName;

  /// What the user typed on the login / register form (memory only).
  final String? email;
  final String? phone;

  /// Stable id for per-user demo data (donation history, bookmarks). The
  /// email (lower-case) — two users with the same display name must not
  /// see each other's data; the name is only a fallback when no email.
  String get userId {
    final e = email?.trim().toLowerCase();
    return (e == null || e.isEmpty) ? displayName : e;
  }
}

final demoSessionProvider =
    NotifierProvider<DemoSessionController, DemoSession?>(
      DemoSessionController.new,
    );

class DemoSessionController extends Notifier<DemoSession?> {
  LocalStorageService get _storage => ref.read(localStorageServiceProvider);

  @override
  DemoSession? build() {
    final auth = ref.watch(authServiceProvider);

    if (ref.watch(backendConfiguredProvider)) {
      // The backend decides who is signed in. What is on the device is only
      // a display name; it proves nothing and can outlive the real session.
      final subscription = auth.backendSessionChanges.listen((signedIn) {
        if (!signedIn && state != null) {
          state = null;
          unawaited(_storage.clearDemoSession());
        }
      });
      ref.onDispose(subscription.cancel);

      if (!auth.hasBackendSession) {
        // Signed out elsewhere, or the token expired while the app was
        // closed. Showing the stored name would promise rights the database
        // will refuse.
        unawaited(_storage.clearDemoSession());
        return null;
      }
    }

    final name = _storage.demoSessionName;
    if (name == null || name.trim().isEmpty) return null;
    return DemoSession(
      displayName: name,
      email: _storage.demoSessionEmail,
      phone: _storage.demoSessionPhone,
    );
  }

  /// [remember] false keeps the session for this run only, which is what the
  /// unticked "Remember me" box promises.
  void signIn({
    required String displayName,
    String? email,
    String? phone,
    bool remember = true,
  }) {
    String? clean(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    final session = DemoSession(
      displayName: displayName,
      email: clean(email),
      phone: clean(phone),
    );
    state = session;
    // The UI must not wait on the disk write.
    unawaited(
      remember
          ? _storage.saveDemoSession(
              displayName: session.displayName,
              email: session.email,
              phone: session.phone,
            )
          : _storage.clearDemoSession(),
    );
  }

  void signOut() {
    state = null;
    unawaited(_storage.clearDemoSession());
    // End the backend session too, or the user stays signed in to Supabase
    // while the app shows them as signed out.
    unawaited(ref.read(authServiceProvider).signOut());
  }
}
