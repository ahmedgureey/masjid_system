import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/utils/date_formatter.dart';
import 'core/utils/font_licenses.dart';
import 'services/local_storage_service.dart';

/// Entry point. Keeps start-up minimal: bindings, date symbols, local
/// settings, licenses, state scope. Supabase and Firebase initialization are
/// added in later phases.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loads intl date symbols (bundled, no network) so dates can be formatted
  // anywhere, not only below the Material localizations.
  await initializeDateFormatting();
  AppDateFormatter.configure();
  final prefs = await SharedPreferences.getInstance();
  registerFontLicenses();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MasjidApp(),
    ),
  );
}
