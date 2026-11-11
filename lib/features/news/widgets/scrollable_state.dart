import 'package:material_ui/material_ui.dart';

/// Keeps an empty / error / sign-in state centred, but scrollable when it
/// does not fit (small phones with large text).
class ScrollableStateView extends StatelessWidget {
  const ScrollableStateView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}
