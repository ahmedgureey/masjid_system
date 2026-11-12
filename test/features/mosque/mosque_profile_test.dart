import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/authentication/application/demo_session_provider.dart';
import 'package:masjid_management/features/mosque/data/mosque_repository.dart';
import 'package:masjid_management/features/mosque/models/mosque.dart';
import 'package:masjid_management/features/mosque/screens/edit_mosque_profile_screen.dart';
import 'package:masjid_management/features/mosque/screens/mosque_profile_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

// ---------------------------------------------------------------------------
// Test doubles
// ---------------------------------------------------------------------------

class _SignedIn extends DemoSessionController {
  @override
  DemoSession? build() => const DemoSession(displayName: 'Admin');
}

/// Counts saves (duplicate-submission test).
class _CountingRepository extends LocalMosqueRepository {
  int updates = 0;

  @override
  Future<Mosque> updateMosque(Mosque mosque) {
    updates++;
    return super.updateMosque(mosque);
  }
}

class _FailingRepository extends LocalMosqueRepository {
  @override
  Future<Mosque> updateMosque(Mosque mosque) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    throw Exception('network');
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Order of the text fields on the edit screen.
const _fieldOrder = [
  'name',
  'description',
  'year',
  'registration',
  'country',
  'city',
  'district',
  'address',
  'lat',
  'lng',
  'phone',
  'email',
  'website',
  'imam',
  'chairman',
  'administrator',
  'treasurer',
];

Finder _field(String key) =>
    find.byType(TextFormField).at(_fieldOrder.indexOf(key));

Future<void> _openProfile(
  WidgetTester tester, {
  bool signedIn = false,
  MosqueRepository? repository,
  String locale = 'so',
  Size? size,
  double scale = 1.0,
}) async {
  await pumpFullApp(
    tester,
    prefs: {localeCodeKey: locale},
    surfaceSize: size,
    textScale: scale,
    overrides: [
      if (signedIn) demoSessionProvider.overrideWith(_SignedIn.new),
      if (repository != null)
        mosqueRepositoryProvider.overrideWithValue(repository),
    ],
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.mosqueProfile);
  expect(find.byType(MosqueProfileScreen), findsOneWidget);
}

Future<void> _openEdit(
  WidgetTester tester, {
  MosqueRepository? repository,
}) async {
  await _openProfile(tester, signedIn: true, repository: repository);
  await tester.tap(find.byTooltip('Wax ka beddel'));
  await tester.pumpAndSettle();
  expect(find.byType(EditMosqueProfileScreen), findsOneWidget);
}

Finder get _saveButton => find.widgetWithText(FilledButton, 'Kaydi');
Finder get _cancelButton => find.widgetWithText(OutlinedButton, 'Ka noqo');

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------

void main() {
  group('Profile (visitor)', () {
    testWidgets('renders sections and honest empty states', (tester) async {
      await _openProfile(tester);

      expect(find.text('Macluumaadka Masaajidka'), findsOneWidget);
      expect(find.text('Masjid Al-Ikhlas'), findsWidgets);
      expect(find.text('Sharaxaad weli lama gelin.'), findsOneWidget);
      for (final title in [
        'Goobta Masaajidka',
        'Xogta Xiriirka',
        'Maamulka Masaajidka',
        'Adeegyada Masaajidka',
        'Tas-hiilaadka Masaajidka',
      ]) {
        expect(find.text(title), findsOneWidget);
      }
      // Location, contact, leadership, facilities have no data yet.
      expect(find.text('Xog weli lama gelin.'), findsNWidgets(4));
      // No service is built yet, so none is shown as available.
      expect(find.textContaining('Adeegyadu halkan'), findsOneWidget);
      // Leadership privacy note.
      expect(find.textContaining('Magacyada oo kaliya'), findsOneWidget);
    });

    testWidgets('no edit controls for visitors', (tester) async {
      await _openProfile(tester);
      expect(find.byTooltip('Wax ka beddel'), findsNothing);
      expect(find.text('Wax ka beddel'), findsNothing);
      expect(find.text('Ku dar xog'), findsNothing);
      expect(find.textContaining('(demo)'), findsNothing);
    });

    testWidgets('visitor opening the edit URL is sent back to the profile', (
      tester,
    ) async {
      await _openProfile(tester);
      await goTo(tester, AppRoutes.editMosqueProfile);
      expect(find.byType(EditMosqueProfileScreen), findsNothing);
      expect(find.byType(MosqueProfileScreen), findsOneWidget);
    });

    testWidgets('Arabic: mosque name in Arabic, RTL layout', (tester) async {
      await _openProfile(tester, locale: 'ar');
      expect(find.text('معلومات المسجد'), findsOneWidget);
      expect(find.text('مسجد الإخلاص'), findsWidgets);
      expect(
        Directionality.of(tester.element(find.byType(MosqueProfileScreen))),
        TextDirection.rtl,
      );
    });
  });

  group('Profile (administrator, frontend-only)', () {
    testWidgets('edit controls and frontend-only notice are shown', (
      tester,
    ) async {
      await _openProfile(tester, signedIn: true);
      expect(find.byTooltip('Wax ka beddel'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Wax ka beddel'),
        findsOneWidget,
      );
      expect(find.text('Ku dar xog'), findsWidgets);
      expect(find.textContaining('(demo)'), findsOneWidget);
    });

    testWidgets('header edit button opens the edit screen', (tester) async {
      await _openProfile(tester, signedIn: true);
      await _tap(tester, find.widgetWithText(FilledButton, 'Wax ka beddel'));
      expect(find.byType(EditMosqueProfileScreen), findsOneWidget);
    });
  });

  group('Edit — validation (Somali messages)', () {
    testWidgets('mosque name is required', (tester) async {
      await _openEdit(tester);
      await tester.enterText(_field('name'), '');
      await _tap(tester, _saveButton);
      expect(find.text('Meeshan waa in la buuxiyaa'), findsOneWidget);
      expect(find.byType(EditMosqueProfileScreen), findsOneWidget);
    });

    testWidgets('email, website, year and coordinates are validated', (
      tester,
    ) async {
      await _openEdit(tester);
      await tester.enterText(_field('email'), 'masjid@');
      await tester.enterText(_field('website'), 'not a site');
      await tester.enterText(_field('year'), '3000');
      await tester.enterText(_field('lat'), '2.04');
      await _tap(tester, _saveButton);

      expect(find.text('Geli email sax ah'), findsOneWidget);
      expect(find.textContaining('Geli cinwaan website'), findsOneWidget);
      expect(find.textContaining('Geli sanad sax ah'), findsOneWidget);
      // Latitude given without longitude → longitude required.
      expect(find.text('Meeshan waa in la buuxiyaa'), findsOneWidget);

      await tester.enterText(_field('lng'), '200');
      await _tap(tester, _saveButton);
      expect(find.textContaining('Longitude-ku'), findsOneWidget);
    });

    testWidgets('optional fields may stay empty', (tester) async {
      await _openEdit(tester);
      await _tap(tester, _saveButton);
      expect(find.byType(MosqueProfileScreen), findsOneWidget);
    });
  });

  group('Edit — save and cancel', () {
    testWidgets('save shows loading, then local-only success, values appear', (
      tester,
    ) async {
      await _openEdit(tester);
      await tester.enterText(_field('description'), 'Masjid bulsho.');
      await tester.enterText(_field('city'), 'Hargeysa');
      await tester.enterText(_field('phone'), '+252 63 000 0000');
      await tester.enterText(_field('email'), 'info@example.com');
      await tester.enterText(_field('website'), 'www.example.com');
      await tester.enterText(_field('imam'), 'Sheekh Cali');
      await tester.ensureVisible(find.text('Baarkin'));
      await tester.tap(find.text('Baarkin'));
      await tester.pump();

      await tester.ensureVisible(_saveButton);
      await tester.tap(_saveButton);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(MosqueProfileScreen), findsOneWidget);
      // The notice still has to say the change is local; the wording changed
      // when saves started surviving a restart.
      expect(find.textContaining('kaydiyey qalabkan'), findsOneWidget);

      expect(find.text('Masjid bulsho.'), findsOneWidget);
      expect(find.text('Hargeysa'), findsOneWidget);
      expect(find.text('info@example.com'), findsOneWidget);
      expect(find.text('Sheekh Cali'), findsOneWidget);
      // Only the ticked facility is listed; nothing else is claimed.
      expect(find.text('Baarkin'), findsOneWidget);
      expect(find.text('Goobta salaadda haweenka'), findsNothing);
      // Fields that were not filled are not shown.
      expect(find.text('Lambarka diiwaangelinta'), findsNothing);
    });

    testWidgets('double tap on Save submits only once', (tester) async {
      final repository = _CountingRepository();
      await _openEdit(tester, repository: repository);
      await tester.ensureVisible(_saveButton);
      await tester.tap(_saveButton);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(_saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(repository.updates, 1);
    });

    testWidgets('save failure shows an error and keeps the form', (
      tester,
    ) async {
      await _openEdit(tester, repository: _FailingRepository());
      await tester.enterText(_field('city'), 'Hargeysa');
      await _tap(tester, _saveButton);
      expect(
        find.text('Isbeddellada lama kaydin karin. Fadlan isku day mar kale.'),
        findsOneWidget,
      );
      expect(find.byType(EditMosqueProfileScreen), findsOneWidget);
    });

    testWidgets('cancel without changes closes immediately', (tester) async {
      await _openEdit(tester);
      await _tap(tester, _cancelButton);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(MosqueProfileScreen), findsOneWidget);
    });

    testWidgets('cancel with changes asks; keep editing, then discard', (
      tester,
    ) async {
      await _openEdit(tester);
      await tester.enterText(_field('city'), 'Burco');
      await _tap(tester, _cancelButton);
      expect(find.text('Ma tuuraysaa isbeddellada?'), findsOneWidget);

      await _tap(tester, find.text('Sii wad wax ka beddelka'));
      expect(find.byType(EditMosqueProfileScreen), findsOneWidget);

      await _tap(tester, _cancelButton);
      await _tap(tester, find.text('Tuur'));
      expect(find.byType(MosqueProfileScreen), findsOneWidget);
      expect(find.text('Burco'), findsNothing); // not saved
    });

    testWidgets('back button with changes also asks before leaving', (
      tester,
    ) async {
      await _openEdit(tester);
      await tester.enterText(_field('city'), 'Burco');
      await tester.pump(); // a frame passes before the user can press back
      await _tap(tester, find.byType(BackButton));
      expect(find.text('Ma tuuraysaa isbeddellada?'), findsOneWidget);
      await _tap(tester, find.text('Tuur'));
      expect(find.byType(MosqueProfileScreen), findsOneWidget);
    });

    testWidgets('logo upload is disabled and explains why', (tester) async {
      await _openEdit(tester);
      final upload = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Soo geli logo'),
      );
      expect(upload.onPressed, isNull);
      expect(find.textContaining('Supabase'), findsOneWidget);
    });
  });

  group('Responsive', () {
    for (final (size, scale) in [
      (const Size(320, 568), 1.0),
      (const Size(360, 780), 2.0),
    ]) {
      testWidgets('profile and edit fit ${size.width.toInt()}dp @${scale}x', (
        tester,
      ) async {
        await _openProfile(tester, signedIn: true, size: size, scale: scale);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Tas-hiilaadka Masaajidka'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.tap(find.byTooltip('Wax ka beddel'));
        await tester.pumpAndSettle();
        expect(find.byType(EditMosqueProfileScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
        await _tap(tester, _saveButton);
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('container is available (sanity)', (tester) async {
    await _openProfile(tester);
    expect(
      ProviderScope.containerOf(
        tester.element(find.byType(MosqueProfileScreen)),
      ),
      isNotNull,
    );
  });
}
