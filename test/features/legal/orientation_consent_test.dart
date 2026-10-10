import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_forms.dart';

import '../../helpers/pump_app.dart';

/// Sexual orientation is sensitive data (LGPD art. 11): saving it needs a
/// specific consent.
void main() {
  const profile = MyProfile(
    id: 'me',
    firstName: 'Ana',
    city: 'São Paulo',
    state: 'SP',
    lat: -23.55,
    lng: -46.63,
    gender: Gender.woman,
  );

  Future<List<Map<String, Object?>>> pumpForm(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final submitted = <Map<String, Object?>>[];
    await tester.pumpApp(
      SingleChildScrollView(
        child: BasicsForm(
          initial: profile,
          submitLabel: 'Salvar',
          onSubmit: (fields) async => submitted.add(fields),
        ),
      ),
    );
    return submitted;
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    await tester.pump();
  }

  testWidgets('choosing an orientation asks for the consent', (tester) async {
    final submitted = await pumpForm(tester);

    await tapVisible(tester, find.text('Bissexual'));
    await tapVisible(tester, find.text('Salvar'));

    expect(submitted, isEmpty);
    expect(
      find.text(
        'Para salvar a orientação, marque a autorização ou deixe sem informar.',
      ),
      findsOneWidget,
    );

    await tapVisible(tester, find.byType(CheckboxListTile));
    await tapVisible(tester, find.text('Salvar'));

    expect(submitted.single['orientation'], 'bisexual');
    expect(submitted.single['sensitive_data_consent_at'], isNotNull);
  });

  testWidgets('without an orientation no consent is sent', (tester) async {
    final submitted = await pumpForm(tester);

    await tapVisible(tester, find.text('Salvar'));

    expect(submitted.single['orientation'], isNull);
    expect(submitted.single.containsKey('sensitive_data_consent_at'), isFalse);
  });
}
