import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../routing/app_routes.dart';

/// Runs app start-up work while the splash screen is visible and returns the
/// route to open next.
///
/// Owner decision: the welcome screen ("Gal" / "Samee akoon") opens after
/// the splash; login leads to the home dashboard.
final appStartupProvider = FutureProvider<String>((ref) async {
  await Future<void>.delayed(AppConstants.splashMinDuration);
  return AppRoutes.welcome;
});
