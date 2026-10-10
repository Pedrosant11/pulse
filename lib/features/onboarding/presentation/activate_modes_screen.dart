import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/onboarding/presentation/onboarding_screen.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/edit_profile_screen.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_forms.dart';

enum _ActivationStep { photos, basics, modes }

/// "Events only" → Date/Crew: asks only what is missing (2 photos, gender
/// and the rest of the basics), then the modes. The database checks both
/// requirements when the modes are saved.
class ActivateModesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ActivateModesScreen> createState() =>
      _ActivateModesScreenState();
}

class _ActivateModesScreenState extends ConsumerState<ActivateModesScreen> {
  /// Fixed when the screen opens, so adding photos doesn't reshuffle steps.
  List<_ActivationStep>? _steps;
  int _index = 0;

  void _next() => setState(() => _index++);

  Future<void> _saveBasics(Map<String, Object?> fields) async {
    final saved = await ref.read(profileEditorProvider.notifier).save(fields);
    if (saved == true && mounted) _next();
  }

  Future<void> _saveModes(Map<String, Object?> fields) async {
    final saved = await ref.read(profileEditorProvider.notifier).save(fields);
    if (saved != true || !mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.activateModesDone)));
    context.go(AppRoutes.discover);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(myProfileProvider);
    final photos = ref.watch(myPhotosProvider);
    final notNow = TextButton(
      onPressed: () => context.pop(),
      child: Text(l10n.notNow),
    );

    if (profile.value == null || photos.value == null) {
      return FlowScaffold(
        title: l10n.activateModesTitle,
        actions: [notNow],
        children: [
          if (profile.error ?? photos.error case final error?)
            ErrorView(
              error: error,
              onRetry: () => ref
                ..invalidate(myProfileProvider)
                ..invalidate(myPhotosProvider),
            )
          else
            const LoadingView(itemCount: 2),
        ],
      );
    }

    final me = profile.value!;
    final steps = _steps ??= [
      if (photos.value!.length < 2) _ActivationStep.photos,
      if (me.gender == null) _ActivationStep.basics,
      _ActivationStep.modes,
    ];
    final step = steps[_index];
    final (title, subtitle) = switch (step) {
      _ActivationStep.photos => (
        l10n.onboardingPhotosTitle,
        l10n.onboardingPhotosSubtitle,
      ),
      _ActivationStep.basics => (
        l10n.onboardingBasicsTitle,
        l10n.onboardingBasicsSubtitle,
      ),
      _ActivationStep.modes => (
        l10n.activateModesTitle,
        l10n.onboardingModesSubtitle,
      ),
    };

    return FlowScaffold(
      key: ValueKey(step),
      title: title,
      subtitle: subtitle,
      step: steps.length > 1 ? _index + 1 : null,
      totalSteps: steps.length,
      onBack: _index == 0
          ? () => context.pop()
          : () => setState(() => _index--),
      actions: [notNow],
      children: [
        switch (step) {
          _ActivationStep.photos => PhotosStep(onContinue: _next),
          _ActivationStep.basics => BasicsForm(
            initial: me,
            submitLabel: l10n.continueButton,
            onSubmit: _saveBasics,
          ),
          _ActivationStep.modes => ModesForm(
            initial: me,
            submitLabel: l10n.activateModesButton,
            onSubmit: _saveModes,
          ),
        },
      ],
    );
  }
}

/// Where "turn a mode on" leads: the short activation flow for "events
/// only" profiles, the modes section otherwise.
void openEnableModes(BuildContext context, MyProfile? profile) {
  unawaited(
    context.push(
      (profile?.modes.isEmpty ?? false)
          ? AppRoutes.activateModes
          : AppRoutes.editProfileSection(ProfileSection.modes.name),
    ),
  );
}
