import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/crews/domain/crew_models.dart';
import 'package:pulse/features/crews/presentation/crews_providers.dart';
import 'package:pulse/features/crews/presentation/widgets/crew_card.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/onboarding/presentation/activate_modes_screen.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/user_profile_sheet.dart';

/// A crew (SPEC 9.2): members, chat, requests/invites and owner actions.
class CrewScreen extends ConsumerWidget {
  const new({required this.crewId, super.key});

  final String crewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final crew = ref.watch(crewProvider(crewId));
    final isOwner = crew.value?.myStatus == CrewRelation.owner;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(l10n.crewTitle.toUpperCase()),
        actions: [
          if (isOwner)
            IconButton(
              tooltip: l10n.eventEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(AppRoutes.editCrew(crewId)),
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(crewProvider(crewId))
              ..invalidate(crewMembersProvider(crewId))
              ..invalidate(crewPendingProvider(crewId));
            await ref.read(crewProvider(crewId).future);
          },
          child: AsyncValueView(
            value: crew,
            onRetry: () => ref.invalidate(crewProvider(crewId)),
            data: (crew) => crew == null
                ? ListView(
                    children: [
                      EmptyView(
                        icon: Icons.group_off_outlined,
                        title: l10n.crewNotFound,
                      ),
                    ],
                  )
                : _CrewBody(crew: crew),
          ),
        ),
      ),
    );
  }
}

class _CrewBody extends ConsumerWidget {
  const new({required this.crew});

  final CrewDetail crew;

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String body,
    String action,
  ) async {
    final l10n = context.l10n;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final editor = ref.watch(crewEditorProvider);
    final notifier = ref.read(crewEditorProvider.notifier);
    final members = ref.watch(crewMembersProvider(crew.id));
    final userId = ref.watch(currentUserIdProvider);
    final status = crew.myStatus;
    final isOwner = status == CrewRelation.owner;
    final description = crew.description;
    final conversationId = crew.conversationId;
    final requestId = crew.myRequestId;

    Widget primaryAction() {
      switch (status) {
        case CrewRelation.owner || CrewRelation.member:
          return NeonButton(
            label: l10n.crewOpenChat,
            icon: Icons.forum_rounded,
            gradient: colors.crewGradient,
            onPressed: conversationId == null
                ? null
                : () => context.push(AppRoutes.conversation(conversationId)),
          );
        case CrewRelation.invited:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.crewHasInvite, style: context.textTheme.titleMedium),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: requestId == null || editor.isLoading
                          ? null
                          : () => notifier.answer(
                              requestId,
                              crewId: crew.id,
                              accept: false,
                            ),
                      child: Text(l10n.crewDeclineInvite),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: NeonButton(
                      label: l10n.crewAcceptInvite,
                      gradient: colors.crewGradient,
                      isLoading: editor.isLoading,
                      onPressed: requestId == null
                          ? null
                          : () async {
                              final ok = await notifier.answer(
                                requestId,
                                crewId: crew.id,
                                accept: true,
                              );
                              if (ok == true && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.crewJoined)),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ],
          );
        case CrewRelation.requested:
          return OutlinedButton.icon(
            onPressed: requestId == null || editor.isLoading
                ? null
                : () => notifier.cancel(requestId, crewId: crew.id),
            icon: const Icon(Icons.hourglass_top_rounded),
            label: Text('${l10n.crewRequested} · ${l10n.crewCancelRequest}'),
          );
        case null:
          if (!crew.isOpen || crew.isFull) {
            return Text(
              crew.isFull ? l10n.crewFull : l10n.crewInviteOnly,
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge,
            );
          }
          return NeonButton(
            label: l10n.crewAskToJoin,
            icon: Icons.waving_hand_rounded,
            gradient: colors.crewGradient,
            isLoading: editor.isLoading,
            onPressed: () =>
                notifier.requestToJoin(crew.id, eventId: crew.eventId),
          );
      }
    }

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Text(crew.name.toUpperCase(), style: context.textTheme.headlineMedium),
        SizedBox(height: spacing.xs),
        InkWell(
          onTap: () => context.push(AppRoutes.eventDetail(crew.eventId)),
          child: Text(
            [
              crew.eventName,
              formatEventDate(context, crew.eventStartsAt),
            ].join(' · '),
            style: context.textTheme.titleSmall?.copyWith(color: colors.cyan),
          ),
        ),
        SizedBox(height: spacing.xs),
        Wrap(
          spacing: spacing.xs,
          children: [
            StatusPill(
              label: l10n.crewMembersCount(crew.memberCount, crew.maxMembers),
              color: colors.cyan,
            ),
            StatusPill(
              label: crew.isOpen ? l10n.crewOpen : l10n.crewInviteOnly,
              color: colors.textSecondary,
            ),
            if (crew.sameGenderOnly)
              StatusPill(
                label: l10n.crewSameGenderLabel,
                color: colors.textSecondary,
              ),
          ],
        ),
        if (description != null) ...[
          SizedBox(height: spacing.md),
          Text(description, style: context.textTheme.bodyMedium),
        ],
        if (status == CrewRelation.owner || status == CrewRelation.member) ...[
          SizedBox(height: spacing.md),
          _MeetingPoint(crew: crew),
        ],
        SizedBox(height: spacing.lg),
        FormErrorText(error: editor.error),
        primaryAction(),
        if (isOwner) _OwnerPanel(crew: crew),
        SizedBox(height: spacing.xl),
        Text(
          l10n.crewMembers.toUpperCase(),
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.sm),
        AsyncValueView(
          value: members,
          onRetry: () => ref.invalidate(crewMembersProvider(crew.id)),
          loading: const LoadingView(itemCount: 1),
          data: (members) => Column(
            children: [
              for (final member in members)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () => showUserProfile(context, member.userId),
                  leading: ChatAvatar(photoPath: member.photoPath),
                  title: Row(
                    children: [
                      Flexible(child: Text(member.firstName ?? '')),
                      SizedBox(width: context.spacing.xs),
                      Flexible(
                        child: ProfileBadges(
                          userId: member.userId,
                          max: 1,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  subtitle: member.role == CrewRole.owner
                      ? Text(l10n.crewOwner)
                      : null,
                  trailing: isOwner && member.userId != userId
                      ? PopupMenuButton<String>(
                          onSelected: (action) async {
                            final name = member.firstName ?? '';
                            if (action == 'transfer') {
                              final ok = await _confirm(
                                context,
                                l10n.crewTransferTitle(name),
                                '',
                                l10n.crewMakeOwner,
                              );
                              if (ok) {
                                await notifier.transfer(crew.id, member.userId);
                              }
                            } else {
                              final ok = await _confirm(
                                context,
                                l10n.crewRemoveTitle(name),
                                '',
                                l10n.crewRemoveMember,
                              );
                              if (ok) {
                                await notifier.removeMember(
                                  crew.id,
                                  member.userId,
                                );
                              }
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'transfer',
                              child: Text(l10n.crewMakeOwner),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Text(l10n.crewRemoveMember),
                            ),
                          ],
                        )
                      : null,
                ),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        if (status == CrewRelation.member)
          TextButton.icon(
            onPressed: () async {
              final ok = await _confirm(
                context,
                l10n.crewLeaveTitle(crew.name),
                l10n.crewLeaveBody,
                l10n.crewLeave,
              );
              if (ok &&
                  await notifier.leave(crew.id, eventId: crew.eventId) ==
                      true &&
                  context.mounted) {
                context.pop();
              }
            },
            icon: Icon(Icons.logout_rounded, color: colors.error),
            label: Text(l10n.crewLeave, style: TextStyle(color: colors.error)),
          ),
        if (isOwner) ...[
          Text(l10n.crewOwnerLeaveHint, style: context.textTheme.bodySmall),
          TextButton.icon(
            onPressed: () async {
              final ok = await _confirm(
                context,
                l10n.crewDeleteTitle(crew.name),
                l10n.crewDeleteBody,
                l10n.crewDelete,
              );
              if (ok &&
                  await notifier.delete(crew.id, eventId: crew.eventId) ==
                      true &&
                  context.mounted) {
                context.pop();
              }
            },
            icon: Icon(Icons.delete_outline, color: colors.error),
            label: Text(l10n.crewDelete, style: TextStyle(color: colors.error)),
          ),
        ],
      ],
    );
  }
}

/// Owner-only: pending requests/invites and inviting Crew matches.
class _OwnerPanel extends ConsumerWidget {
  const new({required this.crew});

  final CrewDetail crew;

  Future<void> _openInvite(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      builder: (_) => _InviteSheet(crewId: crew.id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final pending = ref.watch(crewPendingProvider(crew.id)).value ?? const [];
    final notifier = ref.read(crewEditorProvider.notifier);
    final requests = pending
        .where((p) => p.kind == CrewRequestKind.request)
        .toList();
    final invites = pending
        .where((p) => p.kind == CrewRequestKind.invite)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: spacing.sm),
        OutlinedButton.icon(
          onPressed: crew.isFull ? null : () => _openInvite(context),
          icon: const Icon(Icons.person_add_alt_1),
          label: Text(l10n.crewInvite),
        ),
        if (requests.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            l10n.crewPendingRequests.toUpperCase(),
            style: context.textTheme.labelLarge,
          ),
          for (final request in requests)
            GlassCard(
              padding: EdgeInsets.symmetric(horizontal: spacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => showUserProfile(context, request.userId),
                leading: ChatAvatar(photoPath: request.photoPath),
                title: Text(request.firstName ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l10n.reject,
                      icon: const Icon(Icons.close),
                      onPressed: () => notifier.answer(
                        request.requestId,
                        crewId: crew.id,
                        accept: false,
                      ),
                    ),
                    IconButton.filled(
                      tooltip: l10n.approve,
                      icon: const Icon(Icons.check),
                      onPressed: crew.isFull
                          ? null
                          : () => notifier.answer(
                              request.requestId,
                              crewId: crew.id,
                              accept: true,
                            ),
                    ),
                  ],
                ),
              ),
            ),
        ],
        if (invites.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            l10n.crewPendingInvites.toUpperCase(),
            style: context.textTheme.labelLarge,
          ),
          for (final invite in invites)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ChatAvatar(photoPath: invite.photoPath),
              title: Text(invite.firstName ?? ''),
              trailing: TextButton(
                onPressed: () =>
                    notifier.cancel(invite.requestId, crewId: crew.id),
                child: Text(l10n.crewCancelInvite),
              ),
            ),
        ],
      ],
    );
  }
}

class _InviteSheet extends ConsumerWidget {
  const new({required this.crewId});

  final String crewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final candidates = ref.watch(crewInviteCandidatesProvider(crewId));
    final editor = ref.watch(crewEditorProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.crewInviteTitle, style: context.textTheme.titleLarge),
            SizedBox(height: spacing.sm),
            FormErrorText(error: editor.error),
            Expanded(
              child: AsyncValueView(
                value: candidates,
                onRetry: () =>
                    ref.invalidate(crewInviteCandidatesProvider(crewId)),
                data: (people) => people.isEmpty
                    ? EmptyView(icon: Icons.bolt, title: l10n.crewInviteEmpty)
                    : ListView(
                        controller: scrollController,
                        children: [
                          for (final person in people)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ChatAvatar(photoPath: person.photoPath),
                              title: Text(person.firstName ?? ''),
                              trailing: FilledButton(
                                onPressed: editor.isLoading
                                    ? null
                                    : () async {
                                        final ok = await ref
                                            .read(crewEditorProvider.notifier)
                                            .invite(crewId, person.userId);
                                        if (ok == true && context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n.crewInviteSent,
                                                  ),
                                                ),
                                              );
                                        }
                                      },
                                child: Text(l10n.crewInvite),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact crews list for the event screen (SPEC 7.3 "Crews deste evento").
class EventCrewsSection extends ConsumerWidget {
  const new({
    required this.eventId,
    required this.eventName,
    required this.isGoing,
    super.key,
  });

  final String eventId;
  final String eventName;
  final bool isGoing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    if (!isGoing) {
      return Text(
        l10n.crewsSectionNotGoing,
        style: context.textTheme.bodySmall,
      );
    }
    // Crews are part of Crew mode ("events only" stays invisible).
    final me = ref.watch(myProfileProvider).value;
    if (me != null && !me.modes.contains(AppMode.crew)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.crewsSectionNeedsMode, style: context.textTheme.bodySmall),
          TextButton(
            onPressed: () => openEnableModes(context, me),
            child: Text(l10n.crewsSectionEnableMode),
          ),
        ],
      );
    }
    final crews = ref.watch(eventCrewsProvider(eventId));
    final hasOwnCrew =
        crews.value?.any(
          (c) =>
              c.myStatus == CrewRelation.owner ||
              c.myStatus == CrewRelation.member,
        ) ??
        false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AsyncValueView(
          value: crews,
          onRetry: () => ref.invalidate(eventCrewsProvider(eventId)),
          loading: const LoadingView(itemCount: 1),
          data: (crews) => crews.isEmpty
              ? Text(l10n.crewsSectionEmpty, style: context.textTheme.bodySmall)
              : Column(
                  children: [
                    for (final crew in crews)
                      Padding(
                        padding: EdgeInsets.only(bottom: spacing.sm),
                        child: CrewCard(
                          crew: crew,
                          onTap: () => context.push(AppRoutes.crew(crew.id)),
                        ),
                      ),
                  ],
                ),
        ),
        if (!hasOwnCrew) ...[
          SizedBox(height: spacing.sm),
          OutlinedButton.icon(
            onPressed: () => context.push(
              AppRoutes.newCrew(eventId: eventId, eventName: eventName),
            ),
            icon: const Icon(Icons.groups_rounded),
            label: Text(l10n.crewCreate),
          ),
        ],
      ],
    );
  }
}

/// Where the crew meets at the party; any member edits it.
class _MeetingPoint extends ConsumerWidget {
  const new({required this.crew});

  final CrewDetail crew;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: crew.meetingPoint);
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.crewMeetingPoint),
        content: TextField(
          controller: controller,
          maxLength: 120,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.crewMeetingPointHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null) return;
    await ref.read(crewEditorProvider.notifier).setMeetingPoint(crew.id, text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final point = crew.meetingPoint;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(Icons.place_rounded, color: colors.cyan),
        title: Text(l10n.crewMeetingPoint),
        subtitle: Text(
          point ?? l10n.crewMeetingPointEmpty,
          style: point == null
              ? null
              : context.textTheme.titleMedium?.copyWith(color: colors.cyan),
        ),
        trailing: IconButton(
          tooltip: l10n.crewMeetingPointEdit,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _edit(context, ref),
        ),
      ),
    );
  }
}
