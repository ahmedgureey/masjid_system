import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../application/auth_service.dart';

/// [AuthService] backed by Supabase Auth.
///
/// Every failure is mapped to a specific [AuthResult] so the screens can say
/// something true. Anything unrecognised becomes
/// [AuthResult.serverError] rather than being reported as success.
class SupabaseAuthService implements AuthService {
  const SupabaseAuthService();

  GoTrueClient get _auth => Supabase.instance.client.auth;

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    // rememberMe is not forwarded: supabase_flutter persists the session for
    // every sign-in. Honouring it would mean clearing the session on close,
    // which is a separate change — it is not silently ignored elsewhere.
    return _guard(() async {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session == null
          ? AuthResult.serverError
          : AuthResult.success;
    });
  }

  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    String? phone,
    required String password,
  }) async {
    return _guard(() async {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        },
      );
      // With email confirmation on, sign-up succeeds but returns no session;
      // the user must confirm first. That is not a failure, and it is not a
      // completed sign-in either.
      if (response.session != null) return AuthResult.success;
      if (response.user != null) return AuthResult.emailNotConfirmed;
      return AuthResult.serverError;
    });
  }

  @override
  Future<AuthResult> sendPasswordReset({required String email}) async {
    return _guard(() async {
      await _auth.resetPasswordForEmail(email);
      return AuthResult.success;
    });
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException {
      // Already signed out, or the token is gone. The local session is
      // cleared either way, so there is nothing to tell the user.
    } on SocketException {
      // Offline: the local session is still cleared.
    }
  }

  @override
  bool get hasBackendSession => _auth.currentSession != null;

  @override
  Stream<bool> get backendSessionChanges =>
      _auth.onAuthStateChange.map((event) => event.session != null);

  /// Runs [action], turning backend and transport failures into results.
  Future<AuthResult> _guard(Future<AuthResult> Function() action) async {
    try {
      return await action();
    } on AuthException catch (e) {
      return resultForException(e);
    } on SocketException {
      return AuthResult.networkError;
    } on TimeoutException {
      return AuthResult.networkError;
    }
  }

  /// Which [AuthResult] a backend error means.
  ///
  /// Exposed for tests: this mapping is the part most likely to be wrong, and
  /// provoking each error against a live backend is impractical.
  @visibleForTesting
  static AuthResult resultForException(AuthException e) {
    // Supabase sends a stable `code` on recent versions; the message is the
    // fallback for older ones.
    final code = e.code?.toLowerCase() ?? '';
    final message = e.message.toLowerCase();

    bool has(String needle) =>
        code.contains(needle) || message.contains(needle);

    if (has('invalid_credentials') || has('invalid login')) {
      return AuthResult.invalidCredentials;
    }
    if (has('email_not_confirmed') || has('not confirmed')) {
      return AuthResult.emailNotConfirmed;
    }
    if (has('user_already_exists') ||
        has('email_exists') ||
        has('already registered')) {
      return AuthResult.emailAlreadyRegistered;
    }
    if (has('over_request_rate_limit') ||
        has('over_email_send_rate_limit') ||
        has('rate limit') ||
        e.statusCode == '429') {
      return AuthResult.tooManyAttempts;
    }
    // Supabase's built-in SMTP is shared and strictly limited, so a project
    // without its own SMTP fails here rather than at the account itself.
    if (has('error sending') || has('smtp') || has('confirmation email')) {
      return AuthResult.emailDeliveryFailed;
    }
    // Never reached the backend at all.
    //
    // gotrue catches the transport failure itself and rethrows it as an
    // AuthRetryableFetchException, so the SocketException in _guard never
    // fires: no DNS, no route, a refused TLS handshake and a dropped
    // connection all arrive here instead. Those are the user being offline,
    // not the server refusing them, and telling them to "try again shortly"
    // sends them back to a request that cannot succeed until they have a
    // connection. The same exception carries a status code when the backend
    // did answer with a 5xx, and that one is a genuine server error.
    if (e is AuthRetryableFetchException && e.statusCode == null) {
      return AuthResult.networkError;
    }
    // Reached the backend, and it refused. Not the same as having no backend.
    return AuthResult.serverError;
  }
}
