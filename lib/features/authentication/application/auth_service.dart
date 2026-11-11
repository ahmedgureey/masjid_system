import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_auth_service.dart';

/// Outcome of an authentication request.
enum AuthResult {
  /// Request accepted by the backend (only possible once Supabase exists).
  success,

  /// No backend is connected yet — the UI must say so honestly and must not
  /// pretend that the user is signed in.
  backendUnavailable,
}

/// Authentication operations used by the auth screens.
///
/// The screens depend only on this interface. Today it is backed by
/// [MockAuthService]; in the Supabase phase a real implementation replaces it
/// in [authServiceProvider] without touching the UI.
abstract interface class AuthService {
  Future<AuthResult> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<AuthResult> register({
    required String fullName,
    required String email,
    String? phone,
    required String password,
  });

  Future<AuthResult> sendPasswordReset({required String email});
}

final authServiceProvider = Provider<AuthService>(
  (ref) => const MockAuthService(),
);
