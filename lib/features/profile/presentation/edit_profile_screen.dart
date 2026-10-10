import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/onboarding/presentation/activate_modes_screen.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/photo_grid_editor.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_forms.dart';

/// Editable sections — the same widgets as the onboarding steps.
enum ProfileSection { photos, basics, about, music, modes }

class EditProfileScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final me = ref.watch(myProfileProvider).value;
    final sections = [
      (
        ProfileSection.photos,
        Icons.photo_library_outlined,
        l10n.editSectionPhotos,
      ),
      (ProfileSection.basics, Icons.badge_outlined, l10n.editSectionBasics),
      (ProfileSection.about, Icons.person_outline, l10n.editSectionAbout),
      (ProfileSection.music, Icons.headphones_outlined, l10n.editSectionMusic),
      (ProfileSection.modes, Icons.tune, l10n.editSectionModes),
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.profileEdit.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            for (final (section, icon, label) in sections)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: Icon(icon, color: context.colors.magenta),
                    title: Text(label),
                    trailing: const Icon(Icons.chevron_right),
                    // "Events only" turns a mode on through the short
                    // activation flow (photos and gender first).
                    onTap: section == ProfileSection.modes
                        ? () => openEnableModes(context, me)
                        : () => context.push(
                            AppRoutes.editProfileSection(section.name),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EditProfileSectionScreen extends ConsumerWidget {
  const new({required this.section, super.key});

  final ProfileSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final title = switch (section) {
      ProfileSection.photos => l10n.editSectionPhotos,
      ProfileSection.basics => l10n.editSectionBasics,
      ProfileSection.about => l10n.editSectionAbout,
      ProfileSection.music => l10n.editSectionMusic,
      ProfileSection.modes => l10n.editSectionModes,
    };

    Future<void> save(Map<String, Object?> fields) async {
      final saved = await ref.read(profileEditorProvider.notifier).save(fields);
      if (saved == true && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.savedMessage)));
        context.pop();
      }
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(title.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: ref.watch(myProfileProvider),
          onRetry: () => ref.invalidate(myProfileProvider),
          data: (profile) => SingleChildScrollView(
            padding: EdgeInsets.all(context.spacing.md),
            child: switch (section) {
              ProfileSection.photos => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.onboardingPhotosSubtitle,
                    style: context.textTheme.bodySmall,
                  ),
                  SizedBox(height: context.spacing.md),
                  const PhotoGridEditor(),
                  SizedBox(height: context.spacing.lg),
                  NeonButton(label: l10n.saveButton, onPressed: context.pop),
                ],
              ),
              ProfileSection.basics => BasicsForm(
                initial: profile,
                submitLabel: l10n.saveButton,
                onSubmit: save,
              ),
              ProfileSection.about => AboutForm(
                initial: profile,
                submitLabel: l10n.saveButton,
                onSubmit: save,
              ),
              ProfileSection.music => MusicForm(
                initial: profile,
                submitLabel: l10n.saveButton,
                onSubmit: save,
              ),
              ProfileSection.modes => ModesForm(
                initial: profile,
                allowNone: true,
                submitLabel: l10n.saveButton,
                onSubmit: save,
              ),
            },
          ),
        ),
      ),
    );
  }
}
