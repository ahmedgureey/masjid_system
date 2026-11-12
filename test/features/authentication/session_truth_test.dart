import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/config/supabase_config.dart';
import 'package:masjid_management/features/authentication/application/auth_service.dart';
import 'package:masjid_management/features/authentication/application/demo_session_provider.dart';
import 'package:masjid_management/features/mosque/application/mosque_permissions.dart';
import 'package:masjid_management/services/local_storage_service.dart';

import '../../helpers/test_app.dart';

/// Stands in for the backend, so a test can say whether a real session
/// exists — which is what the app must believe over anything on the device.
class _FakeAuth implements AuthService {
  _FakeAuth({this.hasBackendSession = false});

  @override
  bool hasBackendSession;

  final _changes = StreamController<bool>.broadcast();

  @override
  Stream<bool> get backendSessionChanges => _changes.stream;

  /// The backend session appearing or disappearing (expiry, sign-out on
  /// another device, token revoked).
  void backendSays({required bool signedIn}) {
    hasBackendSession = signedIn;
    _changes.add(signedIn);
  }

  @override
  Future<void> signOut() async => hasBackendSession = false;

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async => AuthResult.success;

  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    String? phone,
    required String password,
  }) async => AuthResult.success;

  @override
  Future<AuthResult> sendPasswordReset({required String email}) async =>
      AuthResult.success;
}

const _nameKey = 'demo_session_name';
const _emailKey = 'demo_session_email';

void main() {
  group('With a backend, the backend decides who is signed in', () {
    test('a stored name is ignored when the backend has no session', () async {
      final auth = _FakeAuth(hasBackendSession: false);
      final c = await testContainer(
        // Looks signed in on the device...
        prefs: {_nameKey: 'Axmed', _emailKey: 'a@b.so'},
        overrides: [
          backendConfiguredProvider.overrideWithValue(true),
          authServiceProvider.overrideWithValue(auth),
        ],
      );
      addTearDown(c.dispose);

      // ...but the token expired while the app was closed.
      expect(c.read(demoSessionProvider), isNull);
      // So no admin buttons are offered for saves the database would refuse.
      expect(c.read(canEditMosqueProfileProvider), isFalse);
    });

    test('the stale name is wiped, not left for next time', () async {
      final auth = _FakeAuth(hasBackendSession: false);
      final c = await testContainer(
        prefs: {_nameKey: 'Axmed', _emailKey: 'a@b.so'},
        overrides: [
          backendConfiguredProvider.overrideWithValue(true),
          authServiceProvider.overrideWithValue(auth),
        ],
      );
      addTearDown(c.dispose);
      c.read(demoSessionProvider);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(sharedPreferencesProvider).getString(_nameKey), isNull);
    });

    test('a live backend session restores the stored name', () async {
      final auth = _FakeAuth(hasBackendSession: true);
      final c = await testContainer(
        prefs: {_nameKey: 'Axmed', _emailKey: 'a@b.so'},
        overrides: [
          backendConfiguredProvider.overrideWithValue(true),
          authServiceProvider.overrideWithValue(auth),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(demoSessionProvider)?.displayName, 'Axmed');
      expect(c.read(canEditMosqueProfileProvider), isTrue);
    });

    test('losing the backend session signs the app out immediately', () async {
      final auth = _FakeAuth(hasBackendSession: true);
      final c = await testContainer(
        prefs: {_nameKey: 'Axmed', _emailKey: 'a@b.so'},
        overrides: [
          backendConfiguredProvider.overrideWithValue(true),
          authServiceProvider.overrideWithValue(auth),
        ],
      );
      addTearDown(c.dispose);
      // Keep the provider alive so it is listening.
      final sub = c.listen(demoSessionProvider, (_, _) {});
      addTearDown(sub.close);
      expect(c.read(demoSessionProvider), isNotNull);

      // Signed out on another device, or the refresh token expired.
      auth.backendSays(signedIn: false);
      await Future<void>.delayed(Duration.zero);

      expect(c.read(demoSessionProvider), isNull);
      expect(c.read(sharedPreferencesProvider).getString(_nameKey), isNull);
    });
  });

  group('Remember me', () {
    test('ticked: the session is kept for next time', () async {
      final c = await testContainer();
      addTearDown(c.dispose);
      c
          .read(demoSessionProvider.notifier)
          .signIn(displayName: 'Axmed', email: 'a@b.so');
      await Future<void>.delayed(Duration.zero);
      expect(c.read(sharedPreferencesProvider).getString(_nameKey), 'Axmed');
    });

    test('unticked: signed in now, nothing left on the device', () async {
      final c = await testContainer();
      addTearDown(c.dispose);
      c
          .read(demoSessionProvider.notifier)
          .signIn(displayName: 'Axmed', email: 'a@b.so', remember: false);
      expect(c.read(demoSessionProvider), isNotNull);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(sharedPreferencesProvider).getString(_nameKey), isNull);
    });
  });

  group('Without a backend, the device is all there is', () {
    test('a stored session is restored and grants the admin UI', () async {
      final c = await testContainer(
        prefs: {_nameKey: 'Axmed', _emailKey: 'a@b.so'},
      );
      addTearDown(c.dispose);
      expect(c.read(demoSessionProvider)?.email, 'a@b.so');
      expect(c.read(canEditMosqueProfileProvider), isTrue);
    });
  });
}
