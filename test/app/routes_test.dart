import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/features/auth/domain/session_status.dart';

void main() {
  String? redirect(SessionStatus status, String location) =>
      resolveRedirect(status: status, location: location);

  group('resolveRedirect', () {
    test('unknown session always goes to splash', () {
      expect(redirect(SessionStatus.unknown, AppRoutes.splash), isNull);
      expect(
        redirect(SessionStatus.unknown, AppRoutes.discover),
        AppRoutes.splash,
      );
      expect(
        redirect(SessionStatus.unknown, AppRoutes.login),
        AppRoutes.splash,
      );
    });

    test('signed out users only reach public routes', () {
      for (final path in AppRoutes.publicPaths) {
        expect(redirect(SessionStatus.signedOut, path), isNull);
      }
      for (final path in [
        AppRoutes.splash,
        AppRoutes.accountSetup,
        AppRoutes.onboarding,
        AppRoutes.resetPassword,
        AppRoutes.discover,
        AppRoutes.eventDetail('42'),
        AppRoutes.admin,
      ]) {
        expect(redirect(SessionStatus.signedOut, path), AppRoutes.login);
      }
    });

    test('password recovery forces the reset screen', () {
      expect(
        redirect(SessionStatus.passwordRecovery, AppRoutes.resetPassword),
        isNull,
      );
      expect(
        redirect(SessionStatus.passwordRecovery, AppRoutes.discover),
        AppRoutes.resetPassword,
      );
    });

    test('incomplete accounts are kept in account setup', () {
      expect(
        redirect(SessionStatus.needsAccountSetup, AppRoutes.accountSetup),
        isNull,
      );
      for (final path in [
        AppRoutes.login,
        AppRoutes.checkEmail,
        AppRoutes.onboarding,
        AppRoutes.discover,
      ]) {
        expect(
          redirect(SessionStatus.needsAccountSetup, path),
          AppRoutes.accountSetup,
        );
      }
    });

    test('users without onboarding are kept in onboarding', () {
      expect(
        redirect(SessionStatus.needsOnboarding, AppRoutes.onboarding),
        isNull,
      );
      for (final path in [
        AppRoutes.login,
        AppRoutes.accountSetup,
        AppRoutes.discover,
        AppRoutes.settings,
      ]) {
        expect(
          redirect(SessionStatus.needsOnboarding, path),
          AppRoutes.onboarding,
        );
      }
    });

    test('ready users leave the entry flow and browse freely', () {
      for (final path in [
        AppRoutes.splash,
        AppRoutes.accountSetup,
        AppRoutes.onboarding,
        AppRoutes.resetPassword,
        ...AppRoutes.publicPaths,
      ]) {
        expect(redirect(SessionStatus.ready, path), AppRoutes.discover);
      }
      for (final path in [
        AppRoutes.discover,
        AppRoutes.events,
        AppRoutes.newEvent,
        AppRoutes.eventDetail('42'),
        AppRoutes.conversation('c1'),
        AppRoutes.profile,
        AppRoutes.settings,
      ]) {
        expect(redirect(SessionStatus.ready, path), isNull);
      }
    });
  });

  test('restricted accounts only see the notice or delete the account', () {
    expect(
      redirect(SessionStatus.restricted, AppRoutes.accountRestricted),
      isNull,
    );
    expect(redirect(SessionStatus.restricted, AppRoutes.deleteAccount), isNull);
    for (final path in [
      AppRoutes.discover,
      AppRoutes.conversation('c1'),
      AppRoutes.settings,
      AppRoutes.admin,
    ]) {
      expect(
        redirect(SessionStatus.restricted, path),
        AppRoutes.accountRestricted,
      );
    }
    // Lifted suspension: back into the app.
    expect(
      redirect(SessionStatus.ready, AppRoutes.accountRestricted),
      AppRoutes.discover,
    );
  });

  test('checkEmailFor encodes the e-mail as a query parameter', () {
    final uri = Uri.parse(AppRoutes.checkEmailFor('ana+teste@pulse.app'));
    expect(uri.path, AppRoutes.checkEmail);
    expect(uri.queryParameters['email'], 'ana+teste@pulse.app');
  });
}
