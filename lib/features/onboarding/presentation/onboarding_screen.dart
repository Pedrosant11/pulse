import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_attend_tile.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/photo_grid_editor.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_forms.dart';

/// Profile onboarding (SPEC 6.2): photos → basics → about me → music →
/// modes and preferences → first event. Progress is saved after each step,
/// so the user resumes where they stopped.
class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  OnboardingStep? _step;

  static final OnboardingStep _lastStep = OnboardingStep.values.last;

  OnboardingStep _resumeStep(MyProfile profile) {
    final saved = profile.onboardingStep.clamp(0, _lastStep.index);
    return OnboardingStep.values[saved];
  }

  Future<void> _saveAndAdvance(
    OnboardingStep current,
    Map<String, Object?> fields,
  ) async {
    final next = OnboardingStep.values[current.index + 1];
    final saved = await ref
        .read(profileEditorProvider.notifier)
        .save(fields, nextStep: next);
    if (saved == true && mounted) setState(() => _step = next);
  }

  void _back(OnboardingStep current) {
    if (current.index == 0) return;
    setState(() => _step = OnboardingStep.values[current.index - 1]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(myProfileProvider);
    final signOut = TextButton(
      onPressed: () => ref.read(signOutControllerProvider.notifier).signOut(),
      child: Text(l10n.signOut),
    );

    return profile.when(
      loading: () => FlowScaffold(
        title: l10n.onboardingTitle,
        actions: [signOut],
        children: const [LoadingView(itemCount: 2)],
      ),
      error: (error, _) => FlowScaffold(
        title: l10n.onboardingTitle,
        actions: [signOut],
        children: [
          ErrorView(
            error: error,
            onRetry: () => ref.invalidate(myProfileProvider),
          ),
        ],
      ),
      data: (profile) {
        final step = _step ??= _resumeStep(profile);
        final (title, subtitle) = switch (step) {
          OnboardingStep.photos => (
            l10n.onboardingPhotosTitle,
            l10n.onboardingPhotosSubtitle,
          ),
          OnboardingStep.basics => (
            l10n.onboardingBasicsTitle,
            l10n.onboardingBasicsSubtitle,
          ),
          OnboardingStep.about => (
            l10n.onboardingAboutTitle,
            l10n.onboardingAboutSubtitle,
          ),
          OnboardingStep.music => (
            l10n.onboardingMusicTitle,
            l10n.onboardingMusicSubtitle,
          ),
          OnboardingStep.modes => (
            l10n.onboardingModesTitle,
            l10n.onboardingModesSubtitle,
          ),
          OnboardingStep.firstEvent => (
            l10n.onboardingFirstEventTitle,
            l10n.onboardingFirstEventSubtitle,
          ),
        };
        Future<void> submit(Map<String, Object?> fields) =>
            _saveAndAdvance(step, fields);

        return FlowScaffold(
          key: ValueKey(step),
          title: title,
          subtitle: subtitle,
          step: step.index + 1,
          totalSteps: OnboardingStep.values.length,
          onBack: step.index == 0 ? null : () => _back(step),
          actions: [signOut],
          children: [
            switch (step) {
              OnboardingStep.photos => _PhotosStep(
                onContinue: () => submit(const {}),
              ),
              OnboardingStep.basics => BasicsForm(
                initial: profile,
                submitLabel: l10n.continueButton,
                onSubmit: submit,
              ),
              OnboardingStep.about => AboutForm(
                initial: profile,
                submitLabel: l10n.continueButton,
                onSubmit: submit,
              ),
              OnboardingStep.music => MusicForm(
                initial: profile,
                submitLabel: l10n.continueButton,
                onSubmit: submit,
              ),
              OnboardingStep.modes => ModesForm(
                initial: profile,
                submitLabel: l10n.continueButton,
                onSubmit: submit,
              ),
              OnboardingStep.firstEvent => _FirstEventStep(
                state: profile.state,
              ),
            },
          ],
        );
      },
    );
  }
}

class _PhotosStep extends ConsumerWidget {
  const new({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final count = ref.watch(myPhotosProvider).value?.length ?? 0;
    final enough = count >= AppConstants.minProfilePhotos;
    final saving = ref.watch(profileEditorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PhotoGridEditor(),
        if (!enough)
          Text(
            l10n.photosMinHint(AppConstants.minProfilePhotos),
            style: context.textTheme.bodySmall,
          ),
        SizedBox(height: context.spacing.lg),
        FormErrorText(error: saving.error),
        NeonButton(
          label: l10n.continueButton,
          isLoading: saving.isLoading,
          onPressed: enough ? onContinue : null,
        ),
      ],
    );
  }
}

class _FirstEventStep extends ConsumerWidget {
  const new({required this.state});

  /// User's UF: same-state events are listed first.
  final String? state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final events = ref.watch(upcomingEventsProvider(state: state));
    final attendingIds = {
      for (final e
          in ref.watch(myAttendingEventsProvider).value ??
              const <EventSummary>[])
        e.id,
    };
    final attendance = ref.watch(attendanceEditorProvider);
    final completion = ref.watch(profileEditorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AsyncValueView(
          value: events,
          onRetry: () => ref.invalidate(upcomingEventsProvider),
          loading: const LoadingView(itemCount: 2),
          data: (events) => events.isEmpty
              ? EmptyView(
                  icon: Icons.event_busy_outlined,
                  title: l10n.noUpcomingEvents,
                )
              : Column(
                  children: [
                    for (final event in events)
                      Padding(
                        padding: EdgeInsets.only(bottom: spacing.sm),
                        child: EventAttendTile(
                          event: event,
                          attending: attendingIds.contains(event.id),
                          busy: attendance.isLoading,
                          onToggle: () => ref
                              .read(attendanceEditorProvider.notifier)
                              .setAttending(
                                event.id,
                                attending: !attendingIds.contains(event.id),
                              ),
                        ),
                      ),
                  ],
                ),
        ),
        FormErrorText(error: attendance.error ?? completion.error),
        SizedBox(height: spacing.md),
        NeonButton(
          label: attendingIds.isEmpty ? l10n.skipForNow : l10n.finishOnboarding,
          isLoading: completion.isLoading,
          onPressed: () =>
              ref.read(profileEditorProvider.notifier).completeOnboarding(),
        ),
      ],
    );
  }
}
