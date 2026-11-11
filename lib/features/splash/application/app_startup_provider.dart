import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../routing/app_routes.dart';
import '../../../services/local_storage_service.dart';

/// Runs app start-up work while the splash screen is visible and returns the
/// route to open next:
/// - first launch → language selection (start of onboarding)
/// - onboarding already seen → welcome (login / create account)
///
/// Module 3 adds: signed-in user (dummy session) → home.
final appStartupProvider = FutureProvider<String>((ref) async {
  final storage = ref.read(localStorageServiceProvider);
  await Future<void>.delayed(AppConstants.splashMinDuration);
  return storage.isOnboardingCompleted
      ? AppRoutes.welcome
      : AppRoutes.languageSelection;
});
