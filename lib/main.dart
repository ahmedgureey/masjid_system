import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/utils/font_licenses.dart';

/// Entry point. Keeps start-up minimal: bindings, date symbols, licenses,
/// state scope. Supabase and Firebase initialization are added in later
/// phases.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loads intl date symbols (bundled, no network) so dates can be formatted
  // anywhere, not only below the Material localizations.
  await initializeDateFormatting();
  registerFontLicenses();
  runApp(const ProviderScope(child: MasjidApp()));
}
