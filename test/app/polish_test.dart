import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/widgets/pulse_bottom_nav.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/widgets/candidate_profile_page.dart';
import 'package:pulse/features/discover/presentation/widgets/discover_widgets.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_view.dart';
import 'package:pulse/l10n/app_localizations.dart';

Widget _app(Widget home, {List<Object> overrides = const []}) => ProviderScope(
  overrides: overrides.cast(),
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: home,
  ),
);

void main() {
  testWidgets('the card photo flies into the full profile (Hero)', (
    tester,
  ) async {
    const candidate = DiscoverCandidate(
      id: 'elisa',
      firstName: 'Elisa',
      age: 27,
      photoPaths: ['elisa/0.jpg'],
    );
    SwipeDirection? decision;

    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PhotoCarousel(
                    photos: candidate.photos,
                    heroTag: candidatePhotoHeroTag(candidate.id),
                  ),
                ),
                TextButton(
                  onPressed: () async => decision = await showCandidateProfile(
                    context,
                    candidate: candidate,
                    accent: Colors.pink,
                  ),
                  child: const Text('abrir'),
                ),
              ],
            ),
          ),
        ),
        overrides: [
          photoUrlProvider.overrideWith((ref, path) async => 'https://x/$path'),
          // Still loading: the page shows the card's data meanwhile.
          publicProfileProvider.overrideWith(
            (ref, id) => Future.delayed(const Duration(days: 1)),
          ),
        ],
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Mid-flight: the Hero is moving between the two routes.
    expect(find.byType(Hero), findsWidgets);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Elisa, 27'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Curtir'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(decision, SwipeDirection.like);
  });

  testWidgets('the Chats tab shows unread messages as a badge', (tester) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          bottomNavigationBar: PulseBottomNav(
            currentIndex: 0,
            onSelected: (_) {},
            items: const [
              PulseNavItem(
                icon: Icons.local_fire_department_outlined,
                selectedIcon: Icons.local_fire_department,
                label: 'Descobrir',
              ),
              PulseNavItem(
                icon: Icons.chat_bubble_outline,
                selectedIcon: Icons.chat_bubble,
                label: 'Chats',
                badgeCount: 3,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('3'), findsOneWidget);
    expect(find.bySemanticsLabel('Chats, 3 novidades'), findsOneWidget);
  });
}
