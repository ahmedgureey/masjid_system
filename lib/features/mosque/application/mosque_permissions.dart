import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/application/demo_session_provider.dart';

/// Whether the current user may edit the mosque profile.
///
/// FRONTEND-ONLY AND INCOMPLETE: today anyone signed in through the demo
/// login counts as a mosque administrator. This only hides/shows UI; it is
/// not security. Real permissions (Mosque Administrator / Super
/// Administrator roles) must be enforced by Supabase Row Level Security, and
/// this provider will then read the role from the authenticated profile.
final canEditMosqueProfileProvider = Provider<bool>(
  (ref) => ref.watch(demoSessionProvider) != null,
);
