import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/local_storage_service.dart';

/// DEMO — the signed-in state while no backend exists.
///
/// The display name, email and phone the user typed are kept on the device so
/// a reload does not sign them out; the password is never saved. This is not
/// an auth token and proves nothing to a server. Replaced by the real Supabase
/// session later.
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
    final name = _storage.demoSessionName;
    if (name == null || name.trim().isEmpty) return null;
    return DemoSession(
      displayName: name,
      email: _storage.demoSessionEmail,
      phone: _storage.demoSessionPhone,
    );
  }

  void signIn({required String displayName, String? email, String? phone}) {
    String? clean(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    final session = DemoSession(
      displayName: displayName,
      email: clean(email),
      phone: clean(phone),
    );
    state = session;
    // The UI must not wait on the disk write.
    unawaited(
      _storage.saveDemoSession(
        displayName: session.displayName,
        email: session.email,
        phone: session.phone,
      ),
    );
  }

  void signOut() {
    state = null;
    unawaited(_storage.clearDemoSession());
  }
}
