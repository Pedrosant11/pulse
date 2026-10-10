import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';

/// "This is a plan benefit" sheet, shown where the limit was hit.
Future<void> showPlansPrompt(BuildContext context, PlanFeature feature) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;
      final spacing = sheetContext.spacing;
      return Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 48,
              color: sheetContext.colors.lime,
            ),
            SizedBox(height: spacing.md),
            Text(
              l10n.planFeatureHeadline(feature.name),
              textAlign: TextAlign.center,
              style: sheetContext.textTheme.titleLarge,
            ),
            SizedBox(height: spacing.sm),
            Text(
              l10n.planFeaturePitch(feature.name),
              textAlign: TextAlign.center,
              style: sheetContext.textTheme.bodyMedium,
            ),
            SizedBox(height: spacing.lg),
            NeonButton(
              label: l10n.plansSee,
              onPressed: () {
                Navigator.pop(sheetContext);
                unawaited(context.push(AppRoutes.plansFor(feature)));
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: Text(l10n.notNow),
            ),
          ],
        ),
      );
    },
  );
}
