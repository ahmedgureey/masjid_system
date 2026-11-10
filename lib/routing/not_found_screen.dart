import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../core/theme/app_spacing.dart';
import 'app_routes.dart';

/// Shown when a route (e.g. a deep link) does not exist.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location});

  final Uri location;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Page not found', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.space2),
              Text(
                location.toString(),
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space6),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
