import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_providers.dart';

/// Settings → Bloqueados: people the user blocked, with unblock.
class BlockedUsersScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    BlockedUser user,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unblockTitle(user.firstName)),
        content: Text(l10n.blockedUsersHint),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.unblockAction),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(safetyActionsProvider.notifier).unblock(user.userId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final blocked = ref.watch(blockedUsersProvider);
    final actions = ref.watch(safetyActionsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.blockedUsersTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: blocked,
          onRetry: () => ref.invalidate(blockedUsersProvider),
          data: (users) => users.isEmpty
              ? EmptyView(
                  icon: Icons.block_outlined,
                  title: l10n.blockedUsersEmpty,
                )
              : ListView(
                  padding: EdgeInsets.all(spacing.md),
                  children: [
                    Text(
                      l10n.blockedUsersHint,
                      style: context.textTheme.bodySmall,
                    ),
                    SizedBox(height: spacing.sm),
                    FormErrorText(error: actions.error),
                    for (final user in users)
                      Padding(
                        padding: EdgeInsets.only(bottom: spacing.sm),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            leading: ChatAvatar(
                              photoPath: user.photoPath,
                              size: 40,
                            ),
                            title: Text(user.firstName),
                            trailing: TextButton(
                              onPressed: actions.isLoading
                                  ? null
                                  : () => _unblock(context, ref, user),
                              child: Text(l10n.unblockAction),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
