import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/local_storage_service.dart';

/// Onboarding actions. UI calls these; it never touches storage directly.
final onboardingControllerProvider = Provider<OnboardingController>(
  (ref) => OnboardingController(ref.watch(localStorageServiceProvider)),
);

class OnboardingController {
  OnboardingController(this._storage);

  final LocalStorageService _storage;

  /// Called on "Get started" and "Skip" — onboarding is not shown again.
  Future<void> complete() => _storage.setOnboardingCompleted();
}
