import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/verification/domain/verification_models.dart';
import 'package:pulse/features/verification/presentation/verification_providers.dart';
import 'package:pulse/features/verification/presentation/verification_screen.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _photos = [
  ProfilePhoto(id: 'p1', userId: 'me', storagePath: 'me/1.jpg', position: 0),
  ProfilePhoto(id: 'p2', userId: 'me', storagePath: 'me/2.jpg', position: 1),
];

Future<void> _pump(
  WidgetTester tester, {
  bool verified = false,
  VerificationRequest? request,
  List<ProfilePhoto> photos = _photos,
}) async {
  await tester.binding.setSurfaceSize(const Size(400, 1000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        myProfileProvider.overrideWith(
          (ref) async => MyProfile(id: 'me', isVerified: verified),
        ),
        myVerificationProvider.overrideWith((ref) async => request),
        myPhotosProvider.overrideWith((ref) async => photos),
      ],
      child: MaterialApp(
        theme: AppTheme.dark(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: const VerificationScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('asks for a pose and consent before the selfie', (tester) async {
    await _pump(tester);
    expect(find.text('FAÇA ESTA POSE'), findsOneWidget);
    NeonButton button() =>
        tester.widget(find.widgetWithText(NeonButton, 'Tirar selfie'));
    // Disabled until the person consents.
    expect(button().onPressed, isNull);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(button().onPressed, isNotNull);
  });

  testWidgets('a pending request is "em análise"', (tester) async {
    await _pump(
      tester,
      request: VerificationRequest(
        id: 'v1',
        pose: VerificationPose.thumbsUp,
        status: RequestStatus.pending,
        createdAt: DateTime(2026, 10, 10),
      ),
    );
    expect(find.text('Em análise'), findsOneWidget);
  });

  testWidgets('a verified profile sees the badge state', (tester) async {
    await _pump(tester, verified: true);
    expect(find.text('Perfil verificado'), findsOneWidget);
  });

  testWidgets('a rejected request shows why', (tester) async {
    await _pump(
      tester,
      request: VerificationRequest(
        id: 'v2',
        pose: VerificationPose.pointUp,
        status: RequestStatus.rejected,
        createdAt: DateTime(2026, 10, 10),
        rejectionReason: 'O rosto não aparece.',
      ),
    );
    expect(find.text('Verificação não aprovada'), findsOneWidget);
    expect(find.text('Motivo: O rosto não aparece.'), findsOneWidget);
  });

  testWidgets('without 2 photos it asks for photos first', (tester) async {
    await _pump(tester, photos: const []);
    expect(
      find.text('Para verificar, seu perfil precisa de pelo menos 2 fotos.'),
      findsOneWidget,
    );
  });

  test('database hints map to their own failures', () {
    AppFailure fail(String hint) => AppFailure.from(
      PostgrestException(message: 'x', code: 'P0001', hint: hint),
    );
    expect(fail('verification_pending'), isA<VerificationPendingFailure>());
    expect(fail('already_verified'), isA<AlreadyVerifiedFailure>());
  });
}
