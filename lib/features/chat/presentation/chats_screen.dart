import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/crews/presentation/crews_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Inbox (SPEC 9.1): Date / Crew / Grupos tabs; new matches in a horizontal
/// strip on top.
class ChatsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final conversations = ref.watch(conversationsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: Text(l10n.chatsTitle.toUpperCase()),
          bottom: TabBar(
            indicatorColor: colors.magenta,
            labelStyle: context.textTheme.labelLarge,
            tabs: [
              Tab(text: l10n.modeDate),
              Tab(text: l10n.modeCrew),
              Tab(text: l10n.chatsTabGroups),
            ],
          ),
        ),
        body: AsyncValueView(
          value: conversations,
          onRetry: () => ref.invalidate(conversationsProvider),
          data: (all) => TabBarView(
            children: [
              _DirectTab(
                mode: AppMode.date,
                conversations: [
                  for (final c in all)
                    if (c.type == ConversationType.direct &&
                        c.mode == AppMode.date)
                      c,
                ],
              ),
              _DirectTab(
                mode: AppMode.crew,
                conversations: [
                  for (final c in all)
                    if (c.type == ConversationType.direct &&
                        c.mode == AppMode.crew)
                      c,
                ],
              ),
              _GroupsTab(
                groups: [
                  for (final c in all)
                    if (c.type == ConversationType.crew) c,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DirectTab extends ConsumerWidget {
  const new({required this.mode, required this.conversations});

  final AppMode mode;
  final List<ConversationSummary> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final accent = context.colors.accentOf(mode);
    final newMatches = conversations.where((c) => c.isNewMatch).toList();
    final threads = conversations.where((c) => !c.isNewMatch).toList();

    if (conversations.isEmpty) {
      return EmptyView(
        icon: mode == AppMode.date ? Icons.favorite_border : Icons.bolt,
        title: l10n.chatsEmptyTitle,
        message: l10n.chatsEmptyBody,
        actionLabel: l10n.chatsGoDiscover,
        onAction: () => context.go(AppRoutes.discover),
      );
    }

    return RefreshIndicator(
      onRefresh: ref.read(conversationsProvider.notifier).refresh,
      child: ListView(
        padding: EdgeInsets.only(
          top: spacing.sm,
          bottom: MediaQuery.paddingOf(context).bottom + spacing.xl,
        ),
        children: [
          if (newMatches.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: Text(
                l10n.chatsNewMatches.toUpperCase(),
                style: context.textTheme.labelLarge,
              ),
            ),
            SizedBox(height: spacing.sm),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
                itemCount: newMatches.length,
                separatorBuilder: (_, _) => SizedBox(width: spacing.md),
                itemBuilder: (context, i) {
                  final match = newMatches[i];
                  return Semantics(
                    button: true,
                    label: match.otherFirstName,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(context.radii.md),
                      onTap: () =>
                          context.push(AppRoutes.conversation(match.id)),
                      child: Column(
                        children: [
                          ChatAvatar(
                            photoPath: match.otherPhotoPath,
                            size: 64,
                            ring: accent,
                          ),
                          SizedBox(height: spacing.xxs),
                          Text(
                            match.otherFirstName ?? '',
                            style: context.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: spacing.md),
          ],
          for (final (i, conversation) in threads.indexed)
            if (context.reduceMotion || i > 8)
              _ConversationTile(conversation: conversation, accent: accent)
            else
              _ConversationTile(
                conversation: conversation,
                accent: accent,
              ).animate(delay: (40 * i).ms).fadeIn(duration: 200.ms),
        ],
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  const new({required this.conversation, required this.accent});

  final ConversationSummary conversation;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final userId = ref.watch(currentUserIdProvider);
    final c = conversation;
    final unread = c.unreadCount > 0;
    final last = c.lastMessage ?? l10n.chatsSayHi;
    final preview = c.lastMessageSenderId == userId
        ? l10n.chatsYouPrefix(last)
        : last;
    final time = c.lastMessageAt;

    return ListTile(
      onTap: () => context.push(AppRoutes.conversation(c.id)),
      leading: ChatAvatar(photoPath: c.otherPhotoPath),
      title: Text(c.otherFirstName ?? '', style: context.textTheme.titleMedium),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(
          color: unread ? colors.textPrimary : colors.textSecondary,
          fontWeight: unread ? FontWeight.w600 : null,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (time != null)
            Text(
              formatChatTime(context, time, yesterday: l10n.chatYesterday),
              style: context.textTheme.labelSmall?.copyWith(
                color: unread ? accent : null,
              ),
            ),
          if (unread) ...[
            const SizedBox(height: 4),
            Semantics(
              label: l10n.unreadCount(c.unreadCount),
              child: ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(context.radii.pill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1,
                    ),
                    child: Text(
                      '${c.unreadCount}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: colors.background,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Crew group chats and pending crew invites (SPEC 9.2).
class _GroupsTab extends ConsumerWidget {
  const new({required this.groups});

  final List<ConversationSummary> groups;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final invites = ref.watch(myCrewInvitesProvider).value ?? const [];
    final editor = ref.watch(crewEditorProvider);
    final notifier = ref.read(crewEditorProvider.notifier);
    final userId = ref.watch(currentUserIdProvider);

    if (groups.isEmpty && invites.isEmpty) {
      return EmptyView(
        icon: Icons.groups_outlined,
        title: l10n.chatsGroupsEmptyTitle,
        message: l10n.chatsGroupsEmptyBody,
        actionLabel: l10n.discoverGoToEvents,
        onAction: () => context.go(AppRoutes.events),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myCrewInvitesProvider);
        await ref.read(conversationsProvider.notifier).refresh();
      },
      child: ListView(
        padding: EdgeInsets.only(
          top: spacing.sm,
          bottom: MediaQuery.paddingOf(context).bottom + spacing.xl,
        ),
        children: [
          if (invites.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: Text(
                l10n.crewInvitesTitle.toUpperCase(),
                style: context.textTheme.labelLarge,
              ),
            ),
            for (final invite in invites)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.md,
                  spacing.sm,
                  spacing.md,
                  0,
                ),
                child: GlassCard(
                  borderGradient: colors.crewGradient,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () =>
                            context.push(AppRoutes.crew(invite.crewId)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invite.crewName,
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              [
                                invite.eventName,
                                formatEventDate(context, invite.eventStartsAt),
                              ].join(' · '),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: colors.cyan,
                              ),
                            ),
                            Text(
                              l10n.crewInviteFrom(
                                invite.invitedByName ?? '',
                                invite.memberCount,
                              ),
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: editor.isLoading
                                ? null
                                : () => notifier.answer(
                                    invite.requestId,
                                    crewId: invite.crewId,
                                    accept: false,
                                  ),
                            child: Text(l10n.crewDeclineInvite),
                          ),
                          FilledButton(
                            onPressed: editor.isLoading
                                ? null
                                : () => notifier.answer(
                                    invite.requestId,
                                    crewId: invite.crewId,
                                    accept: true,
                                  ),
                            child: Text(l10n.crewAcceptInvite),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: spacing.md),
          ],
          for (final group in groups)
            ListTile(
              onTap: () => context.push(AppRoutes.conversation(group.id)),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: colors.crewGradient,
                ),
                child: Icon(Icons.groups_rounded, color: colors.textPrimary),
              ),
              title: Text(
                group.crewName ?? '',
                style: context.textTheme.titleMedium,
              ),
              subtitle: Text(
                group.lastMessage == null
                    ? '${group.eventName ?? ''} · '
                          '${l10n.crewMembersShort(group.memberCount ?? 0)}'
                    : group.lastMessageSenderId == userId
                    ? l10n.chatsYouPrefix(group.lastMessage!)
                    : group.lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall,
              ),
              trailing: group.unreadCount > 0
                  ? Badge(
                      label: Text('${group.unreadCount}'),
                      backgroundColor: colors.cyan,
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}
