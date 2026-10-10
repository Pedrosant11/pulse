import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/plans/presentation/widgets/plans_prompt.dart';
import 'package:pulse/features/profile/presentation/widgets/city_picker.dart';

/// Travel mode (plan): discover around another city, e.g. a festival trip.
Future<void> showTravelSheet(BuildContext context, Entitlements me) {
  if (!me.hasPlan) return showPlansPrompt(context, PlanFeature.travel);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    builder: (_) => const _TravelSheet(),
  );
}

class _TravelSheet extends ConsumerWidget {
  const new();

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final city = await showCityPicker(context);
    if (city == null) return;
    final saved = await ref.read(planActionsProvider.notifier).setTravel(city);
    if (saved == true && context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final me = ref.watch(entitlementsProvider).value;
    final actions = ref.watch(planActionsProvider);
    final traveling = me?.isTraveling ?? false;

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.flight_takeoff_rounded,
            size: 40,
            color: context.colors.lime,
          ),
          SizedBox(height: spacing.sm),
          Text(
            l10n.travelTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.xs),
          Text(
            traveling
                ? l10n.travelActive('${me!.travelCity}, ${me.travelState}')
                : l10n.travelExplain,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.lg),
          FormErrorText(error: actions.error),
          NeonButton(
            label: traveling ? l10n.travelChange : l10n.travelPick,
            isLoading: actions.isLoading,
            onPressed: () => _pick(context, ref),
          ),
          if (traveling)
            TextButton(
              onPressed: actions.isLoading
                  ? null
                  : () async {
                      final done = await ref
                          .read(planActionsProvider.notifier)
                          .setTravel(null);
                      if (done == true && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              child: Text(l10n.travelBackHome),
            ),
        ],
      ),
    );
  }
}
