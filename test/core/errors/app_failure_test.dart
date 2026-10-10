import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/l10n/app_localizations_pt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('AppFailure.from', () {
    test('keeps an AppFailure as is', () {
      const failure = NotFoundFailure();
      expect(AppFailure.from(failure), same(failure));
    });

    test('maps network errors', () {
      expect(
        AppFailure.from(const SocketException('offline')),
        isA<NetworkFailure>(),
      );
      expect(AppFailure.from(TimeoutException('slow')), isA<NetworkFailure>());
    });

    test('maps auth errors', () {
      expect(
        AppFailure.from(const AuthException('expired', statusCode: '401')),
        isA<SessionExpiredFailure>(),
      );
      expect(
        AppFailure.from(const AuthException('slow down', statusCode: '429')),
        isA<RateLimitedFailure>(),
      );
    });

    test('maps Postgrest error codes', () {
      PostgrestException pg(String code) =>
          PostgrestException(message: 'error', code: code);

      expect(AppFailure.from(pg('42501')), isA<PermissionDeniedFailure>());
      expect(AppFailure.from(pg('PGRST116')), isA<NotFoundFailure>());
      expect(AppFailure.from(pg('PGRST301')), isA<SessionExpiredFailure>());
      expect(AppFailure.from(pg('P0429')), isA<RateLimitedFailure>());
      expect(AppFailure.from(pg('23505')), isA<UnknownFailure>());
    });

    test('maps Edge Function errors', () {
      AppFailure fn(int status, [String? code]) => AppFailure.from(
        FunctionException(
          status: status,
          details: code == null ? null : {'error': code},
        ),
      );

      expect(fn(403, 'invalid_password'), isA<WrongPasswordFailure>());
      expect(fn(401, 'not_signed_in'), isA<SessionExpiredFailure>());
      expect(fn(429, 'rate_limited'), isA<RateLimitedFailure>());
      expect(fn(500, 'delete_failed'), isA<UnknownFailure>());
    });

    test('falls back to unknown and keeps the cause', () {
      final error = StateError('boom');
      final failure = AppFailure.from(error);
      expect(failure, isA<UnknownFailure>());
      expect(failure.cause, same(error));
    });
  });

  group('auth and account errors', () {
    AppFailure auth(String code) =>
        AppFailure.from(AuthException('x', code: code, statusCode: '400'));

    test('maps GoTrue error codes', () {
      expect(auth('invalid_credentials'), isA<InvalidCredentialsFailure>());
      expect(auth('email_not_confirmed'), isA<EmailNotConfirmedFailure>());
      expect(auth('weak_password'), isA<WeakPasswordFailure>());
      expect(auth('same_password'), isA<SamePasswordFailure>());
      expect(auth('email_exists'), isA<EmailInUseFailure>());
      expect(auth('over_email_send_rate_limit'), isA<RateLimitedFailure>());
      expect(auth('refresh_token_not_found'), isA<SessionExpiredFailure>());
      expect(auth('something_new'), isA<UnknownFailure>());
    });

    test('only a fetch error without status is a network failure', () {
      expect(
        AppFailure.from(AuthRetryableFetchException(message: 'offline')),
        isA<NetworkFailure>(),
      );
      // e.g. "Error sending confirmation email" answered with HTTP 500.
      expect(
        AppFailure.from(
          AuthRetryableFetchException(message: 'smtp', statusCode: '500'),
        ),
        isA<UnknownFailure>(),
      );
    });

    test('maps the unique phone error', () {
      expect(
        AppFailure.from(
          const PostgrestException(
            message:
                'duplicate key value violates unique constraint '
                '"user_private_phone_key"',
            code: '23505',
          ),
        ),
        isA<PhoneInUseFailure>(),
      );
    });

    test('guardFailures converts and keeps the stack trace', () async {
      await expectLater(
        guardFailures<void>(
          () async => throw const AuthException('x', code: 'weak_password'),
        ),
        throwsA(isA<WeakPasswordFailure>()),
      );
    });
  });

  test('every failure has a pt-BR message', () {
    final l10n = AppLocalizationsPt();
    const failures = <AppFailure>[
      NetworkFailure(),
      SessionExpiredFailure(),
      PermissionDeniedFailure(),
      NotFoundFailure(),
      RateLimitedFailure(),
      InvalidCredentialsFailure(),
      WrongPasswordFailure(),
      SensitiveConsentFailure(),
      EmailNotConfirmedFailure(),
      EmailInUseFailure(),
      WeakPasswordFailure(),
      SamePasswordFailure(),
      PhoneInUseFailure(),
      UnknownFailure(),
    ];
    for (final failure in failures) {
      expect(failure.message(l10n), isNotEmpty);
    }
    expect(
      friendlyErrorMessage(const SocketException('x'), l10n),
      l10n.errorNetwork,
    );
  });
}
