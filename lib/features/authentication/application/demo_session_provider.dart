import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DEMO — the signed-in state while no backend exists.
///
/// Held in memory only: nothing about the user (and never the password) is
/// saved, and closing the app signs the user out. Replaced by the real
/// Supabase session later.
class DemoSession {
  const DemoSession({required this.displayName});

  /// Name shown in the greeting (full name, or the part of the email
  /// before "@").
  final String displayName;
}

final demoSessionProvider =
    NotifierProvider<DemoSessionController, DemoSession?>(
      DemoSessionController.new,
    );

class DemoSessionController extends Notifier<DemoSession?> {
  @override
  DemoSession? build() => null;

  void signIn({required String displayName}) {
    state = DemoSession(displayName: displayName);
  }

  void signOut() => state = null;
}
