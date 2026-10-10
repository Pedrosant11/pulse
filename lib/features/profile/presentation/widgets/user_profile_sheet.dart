import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/presentation/admin_badges_screen.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_view.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';

/// Someone's public profile in a bottom sheet (e.g. from a chat), with
/// Report / Block. Returns true when the person was blocked from it.
Future<bool> showUserProfile(BuildContext context, String userId) async {
  final blocked = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.background,
    builder: (_) => _UserProfileSheet(userId: userId),
  );
  return blocked ?? false;
}

class _UserProfileSheet extends ConsumerWidget {
  const new({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(publicProfileProvider(userId));
    final photos = ref.watch(profilePhotosProvider(userId)).value ?? const [];
    final isMe = ref.watch(currentUserIdProvider) == userId;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      maxChildSize: 0.95,
      builder: (context, scrollController) => AsyncValueView(
        value: profile,
        onRetry: () => ref.invalidate(publicProfileProvider(userId)),
        data: (profile) => ListView(
          controller: scrollController,
          padding: EdgeInsets.all(context.spacing.md),
          children: [
            if (!isMe)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Admins manage badges right from the profile (SPEC 6.4).
                  if (ref.watch(currentRoleProvider).isAdmin)
                    IconButton(
                      tooltip: context.l10n.adminManageBadges,
                      icon: const Icon(Icons.verified_outlined),
                      onPressed: () => showManageBadges(
                        context,
                        userId: userId,
                        name: profile.firstName,
                      ),
                    ),
                  UserSafetyMenu(
                    userId: userId,
                    name: profile.firstName,
                    onBlocked: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ProfileView(profile: profile, photos: photos),
          ],
        ),
      ),
    );
  }
}
