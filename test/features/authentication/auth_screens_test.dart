import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/features/authentication/screens/forgot_password_screen.dart';
import 'package:masjid_management/features/authentication/screens/login_screen.dart';
import 'package:masjid_management/features/authentication/screens/register_screen.dart';
import 'package:masjid_management/features/home/screens/home_screen.dart';
import 'package:masjid_management/features/onboarding/screens/welcome_screen.dart';
import 'package:masjid_management/routing/app_routes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_app.dart';

/// Somali strings used below (lib/l10n/app_so.arb).
const _required = 'Meeshan waa in la buuxiyaa';
const _login = 'Gal';
const _createAccount = 'Samee akoon';

/// Opens the welcome screen in Somali (returning user).
Future<void> _openWelcome(
  WidgetTester tester, {
  Size? size,
  double scale = 1,
}) async {
  await pumpFullApp(
    tester,
    prefs: {onboardingCompletedKey: true, localeCodeKey: 'so'},
    surfaceSize: size,
    textScale: scale,
  );
  await passSplash(tester);
  await goTo(tester, AppRoutes.welcome);
  expect(find.byType(WelcomeScreen), findsOneWidget);
}

Finder _submitButton(String label) =>
    find.widgetWithText(FilledButton, label).last;

Future<void> _tapSubmit(WidgetTester tester, String label) async {
  await tester.ensureVisible(_submitButton(label));
  await tester.tap(_submitButton(label));
  await tester.pumpAndSettle();
}

Future<void> _openLogin(WidgetTester tester) async {
  await _openWelcome(tester);
  await tester.tap(find.text(_login));
  await tester.pumpAndSettle();
  expect(find.byType(LoginScreen), findsOneWidget);
}

Future<void> _openRegister(WidgetTester tester) async {
  await _openWelcome(tester);
  await tester.tap(find.text(_createAccount));
  await tester.pumpAndSettle();
  expect(find.byType(RegisterScreen), findsOneWidget);
}

/// Text field whose label (rendered above it) is [label].
Finder _field(String label) => find.descendant(
  of: find
      .ancestor(of: find.textContaining(label), matching: find.byType(Column))
      .first,
  matching: find.byType(TextFormField),
);

void main() {
  group('Welcome buttons', () {
    testWidgets('"Gal" opens login and back returns to welcome', (
      tester,
    ) async {
      await _openLogin(tester);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('"Samee akoon" opens registration', (tester) async {
      await _openRegister(tester);
    });

    testWidgets('double tap opens only one login screen', (tester) async {
      await _openWelcome(tester);
      // Two taps delivered before the next frame.
      await tester.tap(find.text(_login));
      await tester.tap(find.text(_login));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen, skipOffstage: false), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });

  group('Login screen', () {
    testWidgets('renders Somali labels and controls', (tester) async {
      await _openLogin(tester);
      expect(find.text('Ku soo dhowoow mar kale'), findsOneWidget);
      expect(find.textContaining('Email-ka'), findsOneWidget);
      expect(find.textContaining('Password-ka'), findsWidgets);
      expect(find.text('I xasuuso'), findsOneWidget);
      expect(find.text('Ma illowday password-ka?'), findsOneWidget);
      expect(_submitButton(_login), findsOneWidget);
      expect(find.text('Akoon ma lihid?'), findsOneWidget);
    });

    testWidgets('empty form shows required errors', (tester) async {
      await _openLogin(tester);
      await _tapSubmit(tester, _login);
      expect(find.text(_required), findsNWidgets(2));
    });

    testWidgets('invalid email shows email error', (tester) async {
      await _openLogin(tester);
      await tester.enterText(_field('Email-ka'), 'not-an-email');
      await tester.enterText(_field('Password-ka'), 'secret123');
      await _tapSubmit(tester, _login);
      expect(find.text('Geli email sax ah'), findsOneWidget);
    });

    testWidgets('password visibility toggle', (tester) async {
      await _openLogin(tester);
      EditableText password() => tester.widget<EditableText>(
        find.descendant(
          of: _field('Password-ka'),
          matching: find.byType(EditableText),
        ),
      );
      expect(password().obscureText, isTrue);
      await tester.tap(find.byTooltip('Muuji password-ka'));
      await tester.pump();
      expect(password().obscureText, isFalse);
    });

    testWidgets('"I xasuuso" checkbox toggles', (tester) async {
      await _openLogin(tester);
      Checkbox box() => tester.widget<Checkbox>(find.byType(Checkbox));
      expect(box().value, isFalse);
      await tester.tap(find.text('I xasuuso'));
      await tester.pump();
      expect(box().value, isTrue);
    });

    testWidgets('valid form: loading, then demo sign-in opens Home', (
      tester,
    ) async {
      await _openLogin(tester);
      await tester.enterText(_field('Email-ka'), 'ahmed@example.com');
      await tester.enterText(_field('Password-ka'), 'secret123');
      await tester.ensureVisible(_submitButton(_login));
      await tester.tap(_submitButton(_login));
      await tester.pump(const Duration(milliseconds: 100));

      // Loading state while the mock "request" runs.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      // Clearly marked as demo mode, greeting uses the email name.
      expect(find.text('Habka tijaabada'), findsOneWidget);
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget);
    });

    testWidgets('"Ka bax" ends demo mode; home stays open for visitors', (
      tester,
    ) async {
      await _openLogin(tester);
      await tester.enterText(_field('Email-ka'), 'ahmed@example.com');
      await tester.enterText(_field('Password-ka'), 'secret123');
      await _tapSubmit(tester, _login);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Habka tijaabada'), findsOneWidget);

      await tester.ensureVisible(find.text('Ka bax'));
      await tester.tap(find.text('Ka bax'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Habka tijaabada'), findsNothing);
    });

    testWidgets('forgot password: validation, dialog and back', (tester) async {
      await _openLogin(tester);
      await tester.tap(find.text('Ma illowday password-ka?'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);

      await _tapSubmit(tester, 'Dir link-ga');
      expect(find.text(_required), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'ahmed@example.com');
      await _tapSubmit(tester, 'Dir link-ga');
      expect(find.textContaining('Waxba lama dirin'), findsOneWidget);
      await tester.tap(find.text('Haye'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ku noqo galitaanka'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  group('Registration screen', () {
    testWidgets('renders all fields', (tester) async {
      await _openRegister(tester);
      expect(find.text('Samee akoonkaaga'), findsOneWidget);
      expect(find.textContaining('Magaca oo buuxa'), findsOneWidget);
      expect(find.textContaining('Email-ka'), findsOneWidget);
      expect(find.textContaining('(ikhtiyaari)'), findsOneWidget);
      expect(find.textContaining('Xaqiiji password-ka'), findsOneWidget);
      expect(find.textContaining('Waan oggolahay'), findsOneWidget);
      expect(_submitButton(_createAccount), findsOneWidget);
    });

    testWidgets('empty form shows required and terms errors', (tester) async {
      await _openRegister(tester);
      await _tapSubmit(tester, _createAccount);
      // Name, email, password, confirm password (phone is optional).
      expect(find.text(_required), findsNWidgets(4));
      expect(
        find.text('Waa inaad oggolaataa shuruudaha si aad u sii wadato'),
        findsOneWidget,
      );
    });

    testWidgets('invalid values show specific Somali errors', (tester) async {
      await _openRegister(tester);
      await tester.enterText(_field('Magaca oo buuxa'), 'Ax');
      await tester.enterText(_field('Email-ka'), 'ahmed@');
      await tester.enterText(_field('(ikhtiyaari)'), '12');
      await tester.enterText(_field('Password-ka'), 'short');
      await tester.enterText(_field('Xaqiiji password-ka'), 'different');
      await _tapSubmit(tester, _createAccount);

      expect(find.text('Geli magacaaga oo buuxa'), findsOneWidget);
      expect(find.text('Geli email sax ah'), findsOneWidget);
      expect(find.text('Geli lambar taleefan oo sax ah'), findsOneWidget);
      expect(
        find.text('Password-ku waa inuu ka koobnaadaa ugu yaraan 8 xaraf'),
        findsOneWidget,
      );
      expect(find.text('Labada password isku mid ma aha'), findsOneWidget);
    });

    testWidgets('matching passwords pass confirmation', (tester) async {
      await _openRegister(tester);
      await tester.enterText(_field('Password-ka'), 'secret123');
      await tester.enterText(_field('Xaqiiji password-ka'), 'secret123');
      await _tapSubmit(tester, _createAccount);
      expect(find.text('Labada password isku mid ma aha'), findsNothing);
    });

    testWidgets('valid form (no phone): demo sign-in opens Home', (
      tester,
    ) async {
      await _openRegister(tester);
      await tester.enterText(_field('Magaca oo buuxa'), 'Axmed Cabdi');
      await tester.enterText(_field('Email-ka'), 'axmed@example.com');
      await tester.enterText(_field('Password-ka'), 'secret123');
      await tester.enterText(_field('Xaqiiji password-ka'), 'secret123');
      await tester.ensureVisible(find.textContaining('Waan oggolahay'));
      await tester.tap(find.textContaining('Waan oggolahay'));
      await _tapSubmit(tester, _createAccount);

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Habka tijaabada'), findsOneWidget);
      expect(find.text('Masjid Al-Ikhlas'), findsOneWidget);
    });
  });

  group('Navigation between login and registration', () {
    testWidgets('links swap screens without growing the stack', (tester) async {
      await _openLogin(tester);

      await tester.ensureVisible(
        find.widgetWithText(TextButton, _createAccount),
      );
      await tester.tap(find.widgetWithText(TextButton, _createAccount));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(find.byType(LoginScreen, skipOffstage: false), findsNothing);

      await tester.ensureVisible(find.widgetWithText(TextButton, _login));
      await tester.tap(find.widgetWithText(TextButton, _login));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(RegisterScreen, skipOffstage: false), findsNothing);

      // Back goes straight to welcome.
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });

  group('Responsive', () {
    for (final (size, scale) in [
      (const Size(320, 640), 1.0),
      (const Size(360, 780), 2.0),
    ]) {
      testWidgets(
        'login and register with errors fit ${size.width.toInt()}dp @${scale}x',
        (tester) async {
          await _openWelcome(tester, size: size, scale: scale);
          // At large text sizes the welcome buttons may be below the fold.
          await tester.ensureVisible(find.text(_login));
          await tester.tap(find.text(_login));
          await tester.pumpAndSettle();
          expect(find.byType(LoginScreen), findsOneWidget);
          await _tapSubmit(tester, _login);
          expect(tester.takeException(), isNull);

          await tester.ensureVisible(
            find.widgetWithText(TextButton, _createAccount),
          );
          await tester.tap(find.widgetWithText(TextButton, _createAccount));
          await tester.pumpAndSettle();
          await _tapSubmit(tester, _createAccount);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  group('Demo session survives a restart', () {
    // Prefs keys written by LocalStorageService.
    const nameKey = 'demo_session_name';
    const emailKey = 'demo_session_email';

    /// A restart with a session already on the device.
    Future<SharedPreferences> openSignedIn(WidgetTester tester) async {
      final prefs = await pumpFullApp(
        tester,
        prefs: {
          onboardingCompletedKey: true,
          localeCodeKey: 'so',
          nameKey: 'ahmed',
          emailKey: 'ahmed@example.com',
        },
      );
      await passSplash(tester);
      await goTo(tester, AppRoutes.home);
      return prefs;
    }

    testWidgets('signing in is saved, but never the password', (tester) async {
      final prefs = await pumpFullApp(
        tester,
        prefs: {onboardingCompletedKey: true, localeCodeKey: 'so'},
      );
      await passSplash(tester);
      await goTo(tester, AppRoutes.login);
      await tester.enterText(_field('Email-ka'), 'ahmed@example.com');
      await tester.enterText(_field('Password-ka'), 'secret123');
      await _tapSubmit(tester, _login);
      expect(find.byType(HomeScreen), findsOneWidget);

      expect(prefs.getString(nameKey), 'ahmed');
      expect(prefs.getString(emailKey), 'ahmed@example.com');
      // Nothing stored on the device may contain the password.
      expect(
        prefs.getKeys().any(
          (k) => prefs.get(k).toString().contains('secret123'),
        ),
        isFalse,
      );
    });

    testWidgets('a saved session is restored on the next start', (
      tester,
    ) async {
      await openSignedIn(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
      // Admin UI is back without signing in again.
      expect(find.text('Habka tijaabada'), findsOneWidget);
    });

    testWidgets('signing out clears it from the device', (tester) async {
      final prefs = await openSignedIn(tester);
      await tester.ensureVisible(find.text('Ka bax'));
      await tester.tap(find.text('Ka bax'));
      await tester.pumpAndSettle();

      expect(find.text('Habka tijaabada'), findsNothing);
      expect(prefs.getString(nameKey), isNull);
      expect(prefs.getString(emailKey), isNull);
    });
  });
}
