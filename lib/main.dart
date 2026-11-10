import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/utils/font_licenses.dart';

/// Entry point. Keeps start-up minimal: bindings, licenses, state scope.
/// Supabase and Firebase initialization are added in later phases.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicenses();
  runApp(const ProviderScope(child: MasjidApp()));
}
