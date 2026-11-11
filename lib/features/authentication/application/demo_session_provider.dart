import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DEMO — the signed-in state while no backend exists.
///
/// Held in memory only: nothing about the user (and never the password) is
/// saved, and closing the app signs the user out. Replaced by the real
/// Supabase session later.
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
  @override
  DemoSession? build() => null;

  void signIn({required String displayName, String? email, String? phone}) {
    String? clean(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    state = DemoSession(
      displayName: displayName,
      email: clean(email),
      phone: clean(phone),
    );
  }

  void signOut() => state = null;
}
