import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/application/demo_session_provider.dart';

/// Whether the current user may add or edit events.
///
/// FRONTEND-ONLY AND INCOMPLETE: anyone signed in through the demo login
/// counts as a mosque administrator. This only shows/hides UI and guards
/// routes inside the app; it is NOT security. Real permission checks must be
/// enforced by the backend (Supabase Row Level Security on `events`).
final canManageEventsProvider = Provider<bool>(
  (ref) => ref.watch(demoSessionProvider) != null,
);
