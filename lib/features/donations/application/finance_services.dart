import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/application/demo_session_provider.dart';
import '../models/donation_models.dart';

/// Whether the current user may use the staff (treasurer / admin) screens.
///
/// FRONTEND-ONLY AND INCOMPLETE: anyone signed in through the demo login
/// counts as staff. This only shows/hides UI and guards routes inside the
/// app; it is NOT security. Real permissions (Mosque Admin / Treasurer)
/// must be enforced by the backend with Row Level Security scoped to the
/// mosque, and every change written to an insert-only audit log.
final canManageFinanceProvider = Provider<bool>(
  (ref) => ref.watch(demoSessionProvider) != null,
);

/// Owner id for "my donations". DEMO: the demo session has no id, so its
/// display name is used; replaced by `auth.uid()` with Supabase.
final donorUserIdProvider = Provider<String?>(
  (ref) => ref.watch(demoSessionProvider)?.userId,
);

/// Result of a payment attempt (future: verified by the provider's webhook
/// on the server, never trusted from the client alone).
enum PaymentResult { unavailable }

/// Future integration point for an approved payment provider (mobile money,
/// bank or card processor). No real provider is connected: the only
/// implementation reports that payments are unavailable, so the app never
/// claims that money was taken.
abstract interface class PaymentProcessor {
  bool get isAvailable;

  Future<PaymentResult> pay(Donation donation);
}

class UnavailablePaymentProcessor implements PaymentProcessor {
  const UnavailablePaymentProcessor();

  @override
  bool get isAvailable => false;

  @override
  Future<PaymentResult> pay(Donation donation) async =>
      PaymentResult.unavailable;
}

final paymentProcessorProvider = Provider<PaymentProcessor>(
  (ref) => const UnavailablePaymentProcessor(),
);
