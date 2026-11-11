import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/widgets.dart';

/// Loading / error / data for screens that need two async sources (e.g.
/// campaigns and donations). Error and empty states stay scrollable so
/// they never overflow on small screens.
class FinanceAsync<A, B> extends StatelessWidget {
  const FinanceAsync({
    super.key,
    required this.first,
    required this.second,
    required this.onRetry,
    required this.builder,
  });

  final AsyncValue<A> first;
  final AsyncValue<B> second;
  final VoidCallback onRetry;
  final Widget Function(A first, B second) builder;

  @override
  Widget build(BuildContext context) {
    if (first.hasError || second.hasError) {
      return ScrollableCenter(child: ErrorState(onRetry: onRetry));
    }
    final a = first.value;
    final b = second.value;
    if (a == null || b == null) return const AppLoadingIndicator();
    return builder(a, b);
  }
}

/// Centred content that scrolls when it does not fit.
class ScrollableCenter extends StatelessWidget {
  const ScrollableCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(child: child),
      ),
    ),
  );
}
