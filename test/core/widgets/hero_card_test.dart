import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/widgets/hero_card.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('HeroCard fills its width so centred content is centred', (
    tester,
  ) async {
    await tester.pumpApp(
      const Padding(
        padding: EdgeInsets.all(16),
        child: HeroCard(
          child: Column(children: [SizedBox(width: 40, height: 40)]),
        ),
      ),
      surfaceSize: const Size(400, 800),
    );

    expect(tester.getSize(find.byType(HeroCard)).width, 368);
    final box = tester.getCenter(find.byType(SizedBox).last);
    expect(box.dx, closeTo(200, 1));
  });
}
