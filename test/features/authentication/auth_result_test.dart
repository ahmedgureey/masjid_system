import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_management/core/localization/app_locales.dart';
import 'package:masjid_management/features/authentication/application/auth_result_message.dart';
import 'package:masjid_management/features/authentication/application/auth_service.dart';
import 'package:masjid_management/features/authentication/data/supabase_auth_service.dart';
import 'package:masjid_management/l10n/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Backend errors map to the right outcome', () {
    AuthResult of({String? code, String message = '', String? statusCode}) =>
        SupabaseAuthService.resultForException(
          AuthException(message, statusCode: statusCode, code: code),
        );

    test('wrong email or password', () {
      expect(of(code: 'invalid_credentials'), AuthResult.invalidCredentials);
      // Older backends send no code, only a message.
      expect(
        of(message: 'Invalid login credentials'),
        AuthResult.invalidCredentials,
      );
    });

    test('address not confirmed', () {
      expect(of(code: 'email_not_confirmed'), AuthResult.emailNotConfirmed);
      expect(of(message: 'Email not confirmed'), AuthResult.emailNotConfirmed);
    });

    test('address already registered', () {
      expect(
        of(code: 'user_already_exists'),
        AuthResult.emailAlreadyRegistered,
      );
      expect(of(code: 'email_exists'), AuthResult.emailAlreadyRegistered);
      expect(
        of(message: 'User already registered'),
        AuthResult.emailAlreadyRegistered,
      );
    });

    test('rate limited', () {
      expect(of(code: 'over_request_rate_limit'), AuthResult.tooManyAttempts);
      expect(of(statusCode: '429'), AuthResult.tooManyAttempts);
    });

    test('a failed confirmation email is its own outcome', () {
      expect(
        of(message: 'Error sending confirmation email'),
        AuthResult.emailDeliveryFailed,
      );
      expect(
        of(code: 'unexpected_failure', message: 'smtp error'),
        AuthResult.emailDeliveryFailed,
      );
    });

    test('a request that never left the device is an offline error', () {
      // gotrue wraps every transport failure in this, so the SocketException
      // catch in _guard never sees them. A release build without the INTERNET
      // permission failed exactly this way and was reported to the user as
      // the server refusing a perfectly good email and password.
      expect(
        SupabaseAuthService.resultForException(
          AuthRetryableFetchException(
            message:
                'ClientException with SocketException: Failed host lookup: '
                r"'shujpessldyxbtneacpa.supabase.co'",
          ),
        ),
        AuthResult.networkError,
      );
    });

    test('a 5xx from the backend stays a server error', () {
      // Same exception type, but the backend did answer. Calling this
      // "you are offline" would send the user to check their wifi.
      expect(
        SupabaseAuthService.resultForException(
          AuthRetryableFetchException(
            message: '{"code":500,"error_code":"unexpected_failure"}',
            statusCode: '500',
          ),
        ),
        AuthResult.serverError,
      );
    });

    test('an unrecognised refusal is a server error, not "no backend"', () {
      final result = of(code: 'something_new_from_supabase');
      // backendUnavailable means this build has no key at all. Saying that
      // when the server answered would be a lie to the user.
      expect(result, AuthResult.serverError);
      expect(result, isNot(AuthResult.backendUnavailable));
      expect(result, isNot(AuthResult.success));
    });

    test('matching ignores case', () {
      expect(
        of(message: 'INVALID LOGIN CREDENTIALS'),
        AuthResult.invalidCredentials,
      );
    });
  });

  group('Every failure has something to say', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(AppLocales.english);
    });

    test('each non-success outcome gives a title, message and icon', () {
      for (final result in AuthResult.values) {
        if (result == AuthResult.success) continue;
        final m = authMessageFor(
          result,
          l10n,
          unavailableMessage: 'unavailable',
        );
        expect(m.title.trim(), isNotEmpty, reason: '$result title');
        expect(m.message.trim(), isNotEmpty, reason: '$result message');
        expect(m.icon, isA<IconData>(), reason: '$result icon');
      }
    });

    test('the messages are distinct, so failures are distinguishable', () {
      final titles = <String>{};
      for (final result in AuthResult.values) {
        if (result == AuthResult.success) continue;
        titles.add(
          authMessageFor(result, l10n, unavailableMessage: 'unavailable').title,
        );
      }
      expect(titles.length, AuthResult.values.length - 1);
    });

    test('wrong password does not reveal whether the email exists', () {
      final m = authMessageFor(
        AuthResult.invalidCredentials,
        l10n,
        unavailableMessage: 'unavailable',
      );
      final text = '${m.title} ${m.message}'.toLowerCase();
      expect(text, contains('password'));
      // Must not say the account was not found.
      expect(text, isNot(contains('no account')));
      expect(text, isNot(contains('not registered')));
      expect(text, isNot(contains('does not exist')));
    });

    test('the screen-specific wording is used when no backend is present', () {
      final m = authMessageFor(
        AuthResult.backendUnavailable,
        l10n,
        unavailableMessage: 'nothing was sent',
      );
      expect(m.message, 'nothing was sent');
    });
  });
}
