import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current time, emitted immediately and then once per second (live clocks
/// on the home screen and prayer dashboard).
///
/// Tests override this with a fixed time so screens are deterministic and
/// `pumpAndSettle` is not kept busy by a ticking timer.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});
