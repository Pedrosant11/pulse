import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/auth/domain/auth_validators.dart';
import 'package:pulse/features/auth/domain/phone_number.dart';
import 'package:pulse/features/auth/domain/session_status.dart';

void main() {
  group('AuthValidators', () {
    test('e-mail', () {
      expect(AuthValidators.isValidEmail('ana@pulse.app'), isTrue);
      expect(AuthValidators.isValidEmail(' ana@pulse.app '), isTrue);
      expect(AuthValidators.isValidEmail('ana@pulse'), isFalse);
      expect(AuthValidators.isValidEmail('ana pulse.app'), isFalse);
    });

    test('password policy matches the server (8+, letters and digits)', () {
      expect(AuthValidators.isPasswordAccepted('abcdefg1'), isTrue);
      expect(AuthValidators.isPasswordAccepted('abc1'), isFalse);
      expect(AuthValidators.isPasswordAccepted('abcdefgh'), isFalse);
      expect(AuthValidators.isPasswordAccepted('12345678'), isFalse);
    });

    test('password strength grows with length, case and symbols', () {
      expect(AuthValidators.passwordStrength('abc'), PasswordStrength.weak);
      expect(
        AuthValidators.passwordStrength('abcdefg1'),
        PasswordStrength.fair,
      );
      expect(
        AuthValidators.passwordStrength('Abcdefg1'),
        PasswordStrength.good,
      );
      expect(
        AuthValidators.passwordStrength('Abcdefg1!xyz'),
        PasswordStrength.strong,
      );
    });

    test('age counts completed years only', () {
      final today = DateTime(2026, 10, 3);
      expect(AuthValidators.ageOn(DateTime(2008, 10, 3), today), 18);
      expect(AuthValidators.ageOn(DateTime(2008, 10, 4), today), 17);
      expect(
        AuthValidators.isAdult(DateTime(2008, 10, 3), today: today),
        isTrue,
      );
      expect(
        AuthValidators.isAdult(DateTime(2008, 10, 4), today: today),
        isFalse,
      );
    });
  });

  group('PhoneNumbers', () {
    test('validates Brazilian mobiles', () {
      expect(
        PhoneNumbers.isValidNational(CallingCode.brazil, '(11) 98765-4321'),
        isTrue,
      );
      // Landline (no leading 9) and short numbers are rejected.
      expect(
        PhoneNumbers.isValidNational(CallingCode.brazil, '(11) 3765-4321'),
        isFalse,
      );
      expect(
        PhoneNumbers.isValidNational(CallingCode.brazil, '98765-4321'),
        isFalse,
      );
    });

    test('builds E.164 numbers', () {
      expect(
        PhoneNumbers.toE164(CallingCode.brazil, '(11) 98765-4321'),
        '+5511987654321',
      );
      expect(
        PhoneNumbers.toE164(CallingCode.portugal, '912 345 678'),
        '+351912345678',
      );
    });

    test('masks Brazilian numbers while typing', () {
      final formatter = NationalPhoneFormatter(CallingCode.brazil);
      String type(String text) => formatter
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: text),
          )
          .text;

      expect(type('11'), '(11');
      expect(type('11987'), '(11) 987');
      expect(type('11987654321'), '(11) 98765-4321');
      expect(type('119876543210000'), '(11) 98765-4321');
    });
  });

  group('resolveSessionStatus', () {
    AccountState account({
      bool phone = true,
      bool terms = true,
      bool onboarding = true,
    }) => AccountState(
      userId: 'u1',
      hasPhone: phone,
      termsAccepted: terms,
      onboardingCompleted: onboarding,
      status: AccountStatus.active,
    );

    SessionStatus resolve({
      bool session = true,
      bool recovery = false,
      AccountState? state,
    }) => resolveSessionStatus(
      hasSession: session,
      isPasswordRecovery: recovery,
      account: state,
    );

    test('no session → signed out', () {
      expect(resolve(session: false), SessionStatus.signedOut);
    });

    test('recovery link wins over everything else', () {
      expect(
        resolve(recovery: true, state: account()),
        SessionStatus.passwordRecovery,
      );
    });

    test('account still loading → unknown', () {
      expect(resolve(), SessionStatus.unknown);
    });

    test('missing phone or terms → account setup', () {
      expect(
        resolve(state: account(phone: false)),
        SessionStatus.needsAccountSetup,
      );
      expect(
        resolve(state: account(terms: false)),
        SessionStatus.needsAccountSetup,
      );
    });

    test('then onboarding, then ready', () {
      expect(
        resolve(state: account(onboarding: false)),
        SessionStatus.needsOnboarding,
      );
      expect(resolve(state: account()), SessionStatus.ready);
    });

    test('suspended or banned accounts are restricted', () {
      for (final status in [AccountStatus.suspended, AccountStatus.banned]) {
        expect(
          resolve(state: account().copyWith(status: status)),
          SessionStatus.restricted,
        );
      }
    });
  });
}
