import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/utils/date_formatter.dart';
import 'core/utils/font_licenses.dart';
import 'services/local_storage_service.dart';

/// Entry point. Keeps start-up minimal: bindings, date symbols, local
/// settings, licenses, the backend client, state scope.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loads intl date symbols (bundled, no network) so dates can be formatted
  // anywhere, not only below the Material localizations.
  await initializeDateFormatting();
  AppDateFormatter.configure();
  final prefs = await SharedPreferences.getInstance();
  registerFontLicenses();
  // A build without a key keeps running on local sample data instead of
  // failing to start, so the app stays usable while the backend is wired up.
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  }
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MasjidApp(),
    ),
  );
}
