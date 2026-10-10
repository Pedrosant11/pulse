import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/domain/moderation_models.dart';
import 'package:pulse/features/admin/presentation/moderation_providers.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Admin panel → suspended and banned accounts, with reactivation.
class RestrictedUsersScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _reactivate(
    BuildContext context,
    WidgetRef ref,
    RestrictedUser user,
  ) async {
    final l10n = context.l10n;
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminReactivateTitle(user.firstName)),
        content: TextField(
          controller: reason,
          autofocus: true,
          maxLength: 1000,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.adminReactivateReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.adminReactivate),
          ),
        ],
      ),
    );
    final text = reason.text;
    reason.dispose();
    if ((confirmed ?? false) && text.trim().length >= 3) {
      await ref
          .read(moderationEditorProvider.notifier)
          .reactivate(user.userId, text);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final users = ref.watch(restrictedUsersProvider);
    final editor = ref.watch(moderationEditorProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.adminRestrictedUsers.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: users,
          onRetry: () => ref.invalidate(restrictedUsersProvider),
          data: (users) => users.isEmpty
              ? EmptyView(
                  icon: Icons.verified_user_outlined,
                  title: l10n.adminRestrictedEmpty,
                )
              : ListView(
                  padding: EdgeInsets.all(spacing.md),
                  children: [
                    FormErrorText(error: editor.error),
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
                            title: Row(
                              children: [
                                Flexible(child: Text(user.firstName)),
                                SizedBox(width: spacing.xs),
                                StatusPill(
                                  label: user.status == AccountStatus.banned
                                      ? l10n.accountStatusBanned
                                      : l10n.accountStatusSuspended,
                                  color: colors.error,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              [
                                ?user.reason,
                                if (user.expiresAt case final until?)
                                  l10n.restrictedUntil(
                                    formatEventDate(context, until),
                                  ),
                              ].join('\n'),
                            ),
                            trailing: TextButton(
                              onPressed: editor.isLoading
                                  ? null
                                  : () => _reactivate(context, ref, user),
                              child: Text(l10n.adminReactivate),
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
