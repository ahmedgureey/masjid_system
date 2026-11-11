import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/widgets/brand_mark.dart';
import 'package:masjid_management/features/onboarding/widgets/brand_header.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('BrandHeader centers its content horizontally', (tester) async {
    await tester.pumpApp(
      const Align(
        alignment: Alignment.topCenter,
        child: BrandHeader(child: Column(children: [BrandMark(size: 80)])),
      ),
      surfaceSize: const Size(400, 800),
    );

    final center = tester.getCenter(find.byType(BrandMark));
    expect(center.dx, closeTo(200, 1));
  });
}
