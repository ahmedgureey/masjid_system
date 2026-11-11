import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Navigation helpers that ignore repeated taps, so a quick double tap on a
/// button cannot put the same screen on the stack twice.
///
/// A tap is ignored when:
/// 1. another guarded navigation already started in the current frame
///    (two taps delivered before the next frame), or
/// 2. the screen it comes from is no longer the top route (a later tap
///    after the new screen has been pushed).
extension GuardedNavigation on BuildContext {
  static bool _navigationInProgress = false;

  bool get _canNavigate =>
      !_navigationInProgress && (ModalRoute.of(this)?.isCurrent ?? true);

  void _guard(VoidCallback navigate) {
    if (!_canNavigate) return;
    _navigationInProgress = true;
    // Released after the next frame, when the new route is on the stack.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _navigationInProgress = false,
    );
    WidgetsBinding.instance.scheduleFrame();
    navigate();
  }

  /// Pushes [location] on top of the current screen.
  void pushIfCurrent(String location) => _guard(() => push(location));

  /// Replaces the current screen with [location] (stack does not grow),
  /// e.g. switching between login and registration.
  void replaceIfCurrent(String location) =>
      _guard(() => pushReplacement(location));
}
