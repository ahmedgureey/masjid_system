import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/localization/app_locales.dart';
import 'package:masjid_management/core/utils/validators.dart';
import 'package:masjid_management/core/widgets/app_text_field.dart';
import 'package:masjid_management/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows label with required marker', (tester) async {
    await tester.pumpApp(
      const AppTextField(label: 'Full name', isRequired: true),
    );

    expect(find.textContaining('Full name'), findsOneWidget);
    expect(find.textContaining('*', findRichText: true), findsOneWidget);
  });

  testWidgets('shows translated validation error on submit', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpApp(
      Builder(
        builder: (context) => Form(
          key: formKey,
          child: AppTextField(
            label: 'Full name',
            validator: AppValidators.required(AppLocalizations.of(context)),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('Somali validation message', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpApp(
      Builder(
        builder: (context) => Form(
          key: formKey,
          child: AppTextField(
            validator: AppValidators.required(AppLocalizations.of(context)),
          ),
        ),
      ),
      locale: AppLocales.somali,
    );

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('Meeshan waa in la buuxiyaa'), findsOneWidget);
  });

  testWidgets('prefix text is visible while the field is empty', (
    tester,
  ) async {
    await tester.pumpApp(const AppTextField(label: 'Amount', prefixText: r'$'));
    expect(find.text(r'$'), findsOneWidget);
  });

  testWidgets('password toggle switches visibility', (tester) async {
    await tester.pumpApp(
      const AppTextField(label: 'Password', isPassword: true),
    );

    EditableText editable() =>
        tester.widget<EditableText>(find.byType(EditableText));

    expect(editable().obscureText, isTrue);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(editable().obscureText, isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });
}
