import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/supabase_config.dart';
import '../data/mock_auth_service.dart';
import '../data/supabase_auth_service.dart';

/// Outcome of an authentication request.
///
/// Each value is a different thing to tell the user, so the UI handles them
/// separately. A failure is never reported as success: the app must not
/// pretend that somebody is signed in.
enum AuthResult {
  /// Accepted by the backend.
  success,

  /// Email or password is wrong. Deliberately one value for both, so the
  /// message cannot be used to discover which addresses are registered.
  invalidCredentials,

  /// Registration refused: that address already has an account.
  emailAlreadyRegistered,

  /// Correct credentials, but the address has not been confirmed yet.
  emailNotConfirmed,

  /// Too many attempts; the backend is rate limiting.
  tooManyAttempts,

  /// The request never reached the backend — offline, DNS, timeout.
  networkError,

  /// The backend could not send the confirmation email. The account may or
  /// may not exist; the user cannot finish either way.
  emailDeliveryFailed,

  /// The backend was reached and refused for a reason the app does not
  /// recognise. Distinct from [backendUnavailable]: here there *is* a server
  /// and it answered, so telling the user "not connected yet" would be false.
  serverError,

  /// This build has no backend key at all, so nothing was even attempted.
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

  /// Ends the backend session. Safe to call when nobody is signed in.
  Future<void> signOut();

  /// Whether the backend currently holds a valid session.
  ///
  /// This, not anything stored on the device, is what the database trusts.
  /// Always false for the mock, which has no backend to hold one.
  bool get hasBackendSession;

  /// Emits true when the backend session appears and false when it goes —
  /// signed out here, signed out on another device, or the refresh token
  /// expired. Empty for the mock.
  Stream<bool> get backendSessionChanges;
}

/// The real backend when a key was supplied at build time, otherwise the
/// mock that refuses honestly.
final authServiceProvider = Provider<AuthService>(
  (ref) => SupabaseConfig.isConfigured
      ? const SupabaseAuthService()
      : const MockAuthService(),
);
