import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/widgets/widgets.dart';

/// Notification inbox. Push notifications (FCM) are not connected yet, so
/// this honestly shows that there are none — no invented notifications and
/// no fake unread count.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppTopBar(title: l10n.notificationsTitle),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: EmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notificationsEmptyTitle,
                  message: l10n.notificationsEmptyMessage,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
