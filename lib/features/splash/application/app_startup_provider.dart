import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../routing/app_routes.dart';

/// Runs app start-up work while the splash screen is visible and returns the
/// route to open next.
///
/// Today it only waits for the minimum splash duration. Later phases add:
/// session check, minimum app-version check, and loading cached prayer data
/// (see `docs/design/screen-designs.md` §1).
final appStartupProvider = FutureProvider<String>((ref) async {
  await Future<void>.delayed(AppConstants.splashMinDuration);
  return AppRoutes.home;
});
