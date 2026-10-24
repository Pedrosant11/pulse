import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/widgets/event_share.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:pulse/l10n/app_localizations_pt.dart';

final _event = EventDetail(
  id: 'e1',
  name: 'Beltran na D-EDGE Rio',
  venueName: 'D-EDGE Rio',
  city: 'Rio de Janeiro',
  state: 'RJ',
  startsAt: DateTime(2026, 11, 6, 23),
  endsAt: DateTime(2026, 11, 7, 6),
  status: EventStatus.approved,
  lineup: const ['Beltran'],
  genres: const [MusicGenre.techHouse],
  ticketUrl: 'https://ingresse.com/d-edge-rio-3-anos',
  ticketCoupon: 'SANT',
);

void main() {
  test('the invite has the party, when, line-up, ticket and coupon', () {
    final text = eventInviteText(
      AppLocalizationsPt(),
      _event,
      when: 'sex., 6 de nov. · 23:00',
    );
    expect(
      text,
      'Bora na Beltran na D-EDGE Rio? 🎧\n'
      'sex., 6 de nov. · 23:00 · D-EDGE Rio, Rio de Janeiro\n'
      'Line-up: Beltran\n'
      'Ingresso: https://ingresse.com/d-edge-rio-3-anos\n'
      'Cupom de desconto: SANT\n'
      'Marca presença no Pulse pra gente montar a crew!',
    );
  });

  testWidgets('the story card shows "Eu vou", the line-up and the coupon', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Center(child: EventStoryCard(event: _event, going: true)),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('EU VOU 🔥'), findsOneWidget);
    expect(find.text('BELTRAN NA D-EDGE RIO'), findsOneWidget);
    expect(find.text('Beltran'), findsOneWidget);
    expect(find.text('Cupom: SANT'), findsOneWidget);
    expect(find.text('Tech House'), findsOneWidget);
  });
}
