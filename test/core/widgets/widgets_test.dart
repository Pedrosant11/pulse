import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/widgets/genre_chip.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/pulse_bottom_nav.dart';
import 'package:pulse/core/widgets/pulse_logo.dart';
import 'package:pulse/core/widgets/state_views.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('NeonButton', () {
    testWidgets('calls onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpApp(NeonButton(label: 'Bora', onPressed: () => taps++));
      await tester.tap(find.text('Bora'));
      expect(taps, 1);
    });

    testWidgets('ignores taps while loading', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        NeonButton(label: 'Bora', isLoading: true, onPressed: () => taps++),
      );
      await tester.tap(find.byType(NeonButton));
      expect(taps, 0);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('GenreChip toggles its selection', (tester) async {
    bool? value;
    await tester.pumpApp(
      GenreChip(label: 'Techno', onSelected: (v) => value = v),
    );
    await tester.tap(find.text('Techno'));
    expect(value, isTrue);
  });

  testWidgets('PulseBottomNav reports the tapped index', (tester) async {
    int? selected;
    await tester.pumpApp(
      PulseBottomNav(
        currentIndex: 0,
        onSelected: (i) => selected = i,
        items: const [
          PulseNavItem(icon: Icons.home, selectedIcon: Icons.home, label: 'A'),
          PulseNavItem(icon: Icons.chat, selectedIcon: Icons.chat, label: 'B'),
        ],
      ),
    );
    await tester.tap(find.text('B'));
    expect(selected, 1);
    expect(find.bySemanticsLabel('B'), findsOneWidget);
  });

  testWidgets('ErrorView shows a friendly message and retries', (tester) async {
    var retries = 0;
    await tester.pumpApp(
      ErrorView(error: const NetworkFailure(), onRetry: () => retries++),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Sem conexão'), findsOneWidget);
    await tester.tap(find.text('Tentar de novo'));
    expect(retries, 1);
  });

  testWidgets('the logo shows the mark and the wordmark', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(const PulseLogo(vertical: true, beating: true));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(PulseMark), findsOneWidget);
    expect(find.text('PULSE'), findsOneWidget);
    expect(find.bySemanticsLabel('Pulse'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the empty-state pulse keeps looping', (tester) async {
    LoopingAnimations.enabled = true;
    addTearDown(() => LoopingAnimations.enabled = false);

    await tester.pumpApp(
      const EmptyView(icon: Icons.chat_bubble_outline, title: 'Nada aqui'),
    );
    // Well past the old 3 cycles (~5 s): still animating.
    await tester.pump(const Duration(seconds: 12));
    expect(tester.binding.hasScheduledFrame, isTrue);

    // Disposing stops it (no ticker left running).
    await tester.pumpWidget(const SizedBox());
  });
}
