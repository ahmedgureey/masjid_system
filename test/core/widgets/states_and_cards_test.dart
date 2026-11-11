import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('EmptyState shows defaults and triggers action', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      EmptyState(actionLabel: 'Create', onAction: () => tapped = true),
    );

    expect(find.text('Nothing here yet'), findsOneWidget);
    await tester.tap(find.text('Create'));
    expect(tapped, isTrue);
  });

  testWidgets('ErrorState shows retry button', (tester) async {
    var retried = false;
    await tester.pumpApp(ErrorState(onRetry: () => retried = true));

    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retried, isTrue);
  });

  testWidgets('AppCard is tappable', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      AppCard(onTap: () => tapped = true, child: const Text('Card')),
    );

    await tester.tap(find.text('Card'));
    expect(tapped, isTrue);
  });

  testWidgets('SectionHeader see-all link works', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      SectionHeader(title: 'Events', onSeeAll: () => tapped = true),
    );

    await tester.tap(find.text('See all'));
    expect(tapped, isTrue);
  });

  testWidgets('loading, skeleton, offline banner and chips render', (
    tester,
  ) async {
    await tester.pumpApp(
      settle: false,
      const Column(
        children: [
          SizedBox(height: 80, child: AppLoadingIndicator()),
          AppSkeletonList(count: 2),
          OfflineBanner(),
          StatusChip(label: 'Approved', type: StatusType.success),
          SizedBox(height: 120, child: HeroCard(child: Text('Hero'))),
        ],
      ),
    );

    expect(find.text('Loading…'), findsOneWidget);
    expect(find.text("You're offline"), findsOneWidget);
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Hero'), findsOneWidget);
  });
}
