import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/widgets/app_button.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('primary button shows label and handles taps', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      AppButton.primary(label: 'Save', onPressed: () => taps++),
    );

    expect(find.text('Save'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(taps, 1);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await tester.pumpApp(
      const AppButton.primary(label: 'Save', onPressed: null),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('loading shows spinner, keeps label and ignores taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton.primary(
            label: 'Save',
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(taps, 0);
  });

  testWidgets('each variant renders the right Material button', (tester) async {
    await tester.pumpApp(
      Column(
        children: [
          AppButton.primary(label: 'a', onPressed: () {}),
          AppButton.secondary(label: 'b', onPressed: () {}),
          AppButton.accent(label: 'c', onPressed: () {}),
          AppButton.text(label: 'd', onPressed: () {}),
          AppButton.destructive(label: 'e', onPressed: () {}),
        ],
      ),
    );

    // primary + accent + destructive are FilledButtons.
    expect(find.byType(FilledButton), findsNWidgets(3));
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('expand makes the button full width', (tester) async {
    await tester.pumpApp(
      AppButton.primary(label: 'Wide', expand: true, onPressed: () {}),
      surfaceSize: const Size(360, 640),
    );

    expect(tester.getSize(find.byType(FilledButton)).width, 360);
  });
}
