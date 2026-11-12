import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the app's backend lives.
///
/// The project URL and the publishable ("anon") key are public values by
/// design: they ship inside every installed copy of the app, and Row Level
/// Security — not secrecy — is what protects the data. They are still read
/// from the build environment rather than written into the source, so a fork,
/// a staging project or a reviewer's own instance can point elsewhere:
///
/// ```sh
/// flutter run --dart-define=SUPABASE_KEY=sb_publishable_xxx
/// ```
///
/// A `service_role` or `sb_secret_…` key must never appear here, in any
/// environment: it bypasses every policy.
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://shujpessldyxbtneacpa.supabase.co',
  );

  /// Empty until a key is supplied at build time.
  static const String publishableKey = String.fromEnvironment('SUPABASE_KEY');

  /// Whether the app can reach the backend at all.
  ///
  /// False on a build with no key, and the app then runs on its local sample
  /// data exactly as it does today rather than failing to start. Every
  /// repository checks this before reaching for the network.
  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}

/// [SupabaseConfig.isConfigured] as a provider, so tests can exercise the
/// with-backend behaviour without a real build-time key.
final backendConfiguredProvider = Provider<bool>(
  (ref) => SupabaseConfig.isConfigured,
);
