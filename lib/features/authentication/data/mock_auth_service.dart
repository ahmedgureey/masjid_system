import '../application/auth_service.dart';

/// MOCK / DEMO — stands in for Supabase Auth during frontend development.
///
/// - Sign in and registration succeed for any form that passed validation,
///   so the app can be explored with sample data (demo mode). The UI marks
///   this clearly as demo mode.
/// - Password reset reports [AuthResult.backendUnavailable], because no real
///   email can be sent.
///
/// It never stores, sends or logs any of the values it receives (including
/// passwords).
class MockAuthService implements AuthService {
  const MockAuthService({this.latency = const Duration(milliseconds: 800)});

  final Duration latency;

  Future<AuthResult> _respond(AuthResult result) async {
    await Future<void>.delayed(latency);
    return result;
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) => _respond(AuthResult.success);

  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    String? phone,
    required String password,
  }) => _respond(AuthResult.success);

  @override
  Future<AuthResult> sendPasswordReset({required String email}) =>
      _respond(AuthResult.backendUnavailable);

  @override
  Future<void> signOut() async {
    // Nothing to end: the mock never created a backend session.
  }

  @override
  bool get hasBackendSession => false;

  @override
  Stream<bool> get backendSessionChanges => const Stream<bool>.empty();
}
