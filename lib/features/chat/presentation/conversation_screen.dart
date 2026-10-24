import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/genre_chip.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_media.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_poll.dart';
import 'package:pulse/features/crews/presentation/widgets/start_crew_sheet.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:pulse/features/profile/presentation/widgets/user_profile_sheet.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';
import 'package:pulse/features/safety/presentation/widgets/night_safety.dart';

/// 1:1 conversation (SPEC 9.1): realtime messages, sent/read status,
/// typing indicator, icebreakers and the safety menu. Long-pressing someone
/// else's message reports it.
class ConversationScreen extends ConsumerWidget {
  const new({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final header = ref.watch(conversationHeaderProvider(conversationId));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: header.when(
        loading: () => const SafeArea(child: LoadingView(itemCount: 2)),
        error: (error, _) => SafeArea(
          child: Column(
            children: [
              const Align(alignment: Alignment.centerLeft, child: BackButton()),
              Expanded(
                child: ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(
                    conversationHeaderProvider(conversationId),
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (header) => header == null
            ? SafeArea(
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(),
                    ),
                    Expanded(
                      child: EmptyView(
                        icon: Icons.chat_bubble_outline,
                        title: l10n.chatUnavailable,
                      ),
                    ),
                  ],
                ),
              )
            : _Conversation(header: header),
      ),
    );
  }
}

class _Conversation extends ConsumerStatefulWidget {
  const new({required this.header});

  final ConversationHeader header;

  @override
  ConsumerState<_Conversation> createState() => _ConversationState();
}

class _ConversationState extends ConsumerState<_Conversation> {
  final _input = TextEditingController();

  /// The recording bar replaces the text field.
  bool _recording = false;

  Future<void> _sendPhoto() async {
    final picked = await pickChatPhoto(context, ref.read(photoPickerProvider));
    if (picked == null) return;
    final (bytes, caption) = picked;
    await _controller.sendMedia(MessageKind.image, bytes, caption: caption);
  }

  void _sendVoice(Uint8List bytes, Duration duration) {
    setState(() => _recording = false);
    unawaited(
      _controller.sendMedia(
        MessageKind.audio,
        bytes,
        durationMs: duration.inMilliseconds,
      ),
    );
  }

  ConversationHeader get _header => widget.header;
  ConversationController get _controller =>
      ref.read(conversationControllerProvider(_header.id).notifier);

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send([String? text]) async {
    final content = (text ?? _input.text).trim();
    if (content.isEmpty) return;
    _input.clear();
    setState(() {});
    await _controller.send(content);
  }

  Future<bool> _confirm(String title, String body, String action) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
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
    );
    return confirmed ?? false;
  }

  Future<void> _onMenu(_MenuAction action) async {
    final l10n = context.l10n;
    final name = _header.otherFirstName ?? '';
    final otherId = _header.otherUserId;
    final matchId = _header.matchId;
    final safety = ref.read(chatSafetyProvider.notifier);
    switch (action) {
      case _MenuAction.profile:
        await _openProfile();
      case _MenuAction.shareDate:
        // Safety: tell a trusted contact who you are meeting.
        final event = _header.commonEvents.firstOrNull;
        await shareMyNight(
          context,
          withName: name,
          eventName: event?.name,
          startsAt: event?.startsAt,
        );
      case _MenuAction.unmatch:
        if (matchId == null) return;
        final ok = await _confirm(
          l10n.chatUnmatchTitle(name),
          l10n.chatUnmatchBody,
          l10n.chatMenuUnmatch,
        );
        if (ok && await safety.unmatch(matchId) == true && mounted) {
          context.pop();
        }
      case _MenuAction.block:
        if (otherId == null) return;
        final blocked = await blockUser(
          context,
          ref,
          userId: otherId,
          name: name,
        );
        if (blocked && mounted) context.pop();
      case _MenuAction.viewCrew:
        final crewId = _header.crewId;
        if (crewId != null) await context.push(AppRoutes.crew(crewId));
      case _MenuAction.report:
        if (otherId == null) return;
        final blocked = await showReportSheet(
          context,
          target: ReportTarget.user,
          targetId: otherId,
          userId: otherId,
          userName: name,
        );
        if ((blocked ?? false) && mounted) context.pop();
    }
  }

  /// Leaves the conversation when the person is blocked from the sheet.
  Future<void> _openProfile() async {
    final otherId = _header.otherUserId;
    if (otherId == null) return;
    final blocked = await showUserProfile(context, otherId);
    if (blocked && mounted) context.pop();
  }

  /// Long-press on someone else's message (SPEC 10).
  Future<void> _reportMessage(ChatMessage message) async {
    final names = ref.read(conversationMembersProvider(_header.id)).value;
    final name =
        names?[message.senderId]?.firstName ?? _header.otherFirstName ?? '';
    final blocked = await showReportSheet(
      context,
      target: ReportTarget.message,
      targetId: message.id,
      userId: message.senderId,
      userName: name,
    );
    // A blocked person's messages disappear from group chats.
    if ((blocked ?? false) && mounted) {
      if (_header.isGroup) {
        ref.invalidate(conversationControllerProvider(_header.id));
      } else {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final header = _header;
    final isGroup = header.isGroup;
    final mode = isGroup ? AppMode.crew : header.mode ?? AppMode.date;
    final accent = colors.accentOf(mode);
    final conversation = ref.watch(conversationControllerProvider(header.id));
    final safety = ref.watch(chatSafetyProvider);
    final typing = conversation.value?.otherTyping ?? false;
    final otherId = header.otherUserId;
    final crewId = header.crewId;
    // Group chats name each sender.
    final names = isGroup
        ? ref.watch(conversationMembersProvider(header.id)).value ??
              const <String, ConversationMember>{}
        : const <String, ConversationMember>{};
    final typingName = names[conversation.value?.typingUserId]?.firstName;
    final subtitle = typing
        ? (isGroup && typingName != null
              ? l10n.typingNamed(typingName)
              : l10n.chatTyping)
        : isGroup
        ? '${header.eventName ?? ''} · '
              '${l10n.crewMembersShort(header.memberCount ?? 0)}'
        : mode == AppMode.crew
        ? l10n.modeCrew
        : l10n.modeDate;

    return SafeArea(
      child: Column(
        children: [
          // Header.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.xs),
            child: Row(
              children: [
                const BackButton(),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(context.radii.md),
                    onTap: isGroup
                        ? (crewId == null
                              ? null
                              : () => context.push(AppRoutes.crew(crewId)))
                        : otherId == null
                        ? null
                        : _openProfile,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing.xs),
                      child: Row(
                        children: [
                          if (isGroup)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: colors.crewGradient,
                              ),
                              child: Icon(
                                Icons.groups_rounded,
                                color: colors.textPrimary,
                              ),
                            )
                          else
                            ChatAvatar(
                              photoPath: header.otherPhotoPath,
                              size: 40,
                            ),
                          SizedBox(width: spacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        (isGroup
                                                ? header.crewName
                                                : header.otherFirstName) ??
                                            '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ),
                                    if (!isGroup && otherId != null) ...[
                                      SizedBox(width: spacing.xs),
                                      Flexible(
                                        child: ProfileBadges(
                                          userId: otherId,
                                          max: 1,
                                          dense: true,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    subtitle,
                                    key: ValueKey(subtitle),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(
                                          color: typing ? accent : null,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Crew match: start a crew for a party you both go to.
                if (!isGroup && mode == AppMode.crew && otherId != null)
                  IconButton(
                    tooltip: l10n.startCrewAction,
                    onPressed: () => showStartCrewSheet(
                      context,
                      userId: otherId,
                      name: header.otherFirstName ?? '',
                    ),
                    icon: Icon(Icons.group_add_rounded, color: accent),
                  ),
                PopupMenuButton<_MenuAction>(
                  onSelected: _onMenu,
                  itemBuilder: (_) => [
                    if (isGroup)
                      PopupMenuItem(
                        value: _MenuAction.viewCrew,
                        child: Text(l10n.chatMenuViewCrew),
                      ),
                    if (!isGroup) ...[
                      PopupMenuItem(
                        value: _MenuAction.profile,
                        child: Text(l10n.chatMenuProfile),
                      ),
                      PopupMenuItem(
                        value: _MenuAction.shareDate,
                        child: Text(l10n.chatMenuShareDate),
                      ),
                      PopupMenuItem(
                        value: _MenuAction.unmatch,
                        child: Text(l10n.chatMenuUnmatch),
                      ),
                      PopupMenuItem(
                        value: _MenuAction.block,
                        child: Text(l10n.chatMenuBlock),
                      ),
                      PopupMenuItem(
                        value: _MenuAction.report,
                        child: Text(l10n.chatMenuReport),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.glassBorder),
          if (safety.hasError)
            Padding(
              padding: EdgeInsets.all(spacing.sm),
              child: FormErrorText(error: safety.error),
            ),
          Expanded(
            child: AsyncValueView(
              value: conversation,
              onRetry: () =>
                  ref.invalidate(conversationControllerProvider(header.id)),
              data: (state) => state.messages.isEmpty && state.pending.isEmpty
                  ? _Icebreakers(header: header, accent: accent, onPick: _send)
                  : _MessageList(
                      state: state,
                      accent: accent,
                      gradient: colors.gradientOf(mode),
                      senderNames: isGroup
                          ? {
                              for (final m in names.values)
                                m.userId: m.firstName ?? '',
                            }
                          : null,
                      onLoadMore: _controller.loadMore,
                      onRetry: _controller.retry,
                      onDelete: (message) async {
                        final ok = await _confirm(
                          l10n.chatDeleteTitle,
                          l10n.chatDeleteBody,
                          l10n.chatDeleteMessage,
                        );
                        if (ok) await _controller.delete(message);
                      },
                      onReport: _reportMessage,
                    ),
            ),
          ),
          // Composer.
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.sm,
              spacing.xs,
              spacing.sm,
              spacing.sm,
            ),
            child: _recording
                ? VoiceRecorderBar(
                    onDone: _sendVoice,
                    onCancel: () {
                      if (mounted) setState(() => _recording = false);
                    },
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: l10n.chatSendPhoto,
                        onPressed: _sendPhoto,
                        icon: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: colors.textSecondary,
                        ),
                      ),
                      if (isGroup)
                        IconButton(
                          tooltip: l10n.pollCreateTitle,
                          onPressed: () =>
                              showCreatePollSheet(context, header.id),
                          icon: Icon(
                            Icons.poll_outlined,
                            color: colors.textSecondary,
                          ),
                        ),
                      Expanded(
                        child: TextField(
                          controller: _input,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: AppConstants.maxMessageLength,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) {
                            _controller.userTyping();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: l10n.chatInputHint,
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                context.radii.lg,
                              ),
                              borderSide: BorderSide(color: colors.glassBorder),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      // Empty field: record a voice message instead.
                      if (_input.text.trim().isEmpty)
                        IconButton.filled(
                          tooltip: l10n.chatRecordVoice,
                          style: IconButton.styleFrom(backgroundColor: accent),
                          onPressed: () => setState(() => _recording = true),
                          icon: Icon(
                            Icons.mic_rounded,
                            color: colors.background,
                          ),
                        )
                      else
                        IconButton.filled(
                          tooltip: l10n.chatSend,
                          style: IconButton.styleFrom(backgroundColor: accent),
                          onPressed: _send,
                          icon: Icon(
                            Icons.send_rounded,
                            color: colors.background,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

enum _MenuAction { profile, shareDate, viewCrew, unmatch, block, report }

/// Shown while the chat is empty: suggestions based on the common event.
class _Icebreakers extends StatelessWidget {
  const new({required this.header, required this.accent, required this.onPick});

  final ConversationHeader header;
  final Color accent;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final event = header.commonEvents.firstOrNull?.name ?? header.eventName;
    final suggestions = event == null
        ? [l10n.icebreakerGenericParty, l10n.icebreakerGenericDj]
        : [
            l10n.icebreakerMeet(event),
            l10n.icebreakerLineup(event),
            l10n.icebreakerFirstTime(event),
          ];

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatAvatar(photoPath: header.otherPhotoPath, size: 96, ring: accent),
        SizedBox(height: spacing.md),
        Text(
          l10n.chatIcebreakersTitle.toUpperCase(),
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing.xs,
          runSpacing: spacing.xs,
          children: [
            for (final text in suggestions)
              GenreChip(
                label: text,
                accent: accent,
                onSelected: (_) => onPick(text),
              ),
          ],
        ),
      ],
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.lg),
        child: context.reduceMotion
            ? content
            : content.animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
      ),
    );
  }
}

class _MessageList extends ConsumerWidget {
  const new({
    required this.state,
    required this.accent,
    required this.gradient,
    required this.onLoadMore,
    required this.onRetry,
    required this.onDelete,
    required this.onReport,
    this.senderNames,
  });

  final ConversationState state;

  /// Group chats: names shown above other people's messages.
  final Map<String, String>? senderNames;
  final Color accent;
  final LinearGradient gradient;
  final VoidCallback onLoadMore;
  final ValueChanged<PendingMessage> onRetry;
  final ValueChanged<ChatMessage> onDelete;
  final ValueChanged<ChatMessage> onReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final spacing = context.spacing;
    // Newest first: pending (being sent), then delivered messages.
    final items = <Object>[...state.pending, ...state.messages];
    DateTime timeOf(Object item) => switch (item) {
      PendingMessage(:final createdAt) => createdAt.toLocal(),
      ChatMessage(:final createdAt) => createdAt.toLocal(),
      _ => DateTime.now(),
    };
    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      itemCount: items.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          // Reached the oldest loaded message: fetch the next page.
          WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final item = items[index];
        final time = timeOf(item);
        final older = index + 1 < items.length ? items[index + 1] : null;
        final showDay = older == null
            ? !state.hasMore
            : !sameDay(time, timeOf(older));

        final bubble = switch (item) {
          PendingMessage() => _Bubble.pending(
            pending: item,
            gradient: gradient,
            onRetry: () => onRetry(item),
          ),
          ChatMessage() => _Bubble.message(
            message: item,
            mine: item.senderId == userId,
            read:
                state.otherLastReadAt != null &&
                !state.otherLastReadAt!.isBefore(item.createdAt),
            accent: accent,
            gradient: gradient,
            onDelete: () => onDelete(item),
            onReport: () => onReport(item),
            senderName: item.senderId == userId
                ? null
                : senderNames?[item.senderId],
          ),
          _ => const SizedBox.shrink(),
        };

        return Column(children: [if (showDay) _DaySeparator(time), bubble]);
      },
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const new(this.day);

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(day.year, day.month, day.day);
    final label = d == today
        ? l10n.chatToday
        : d == today.subtract(const Duration(days: 1))
        ? l10n.chatYesterday
        : MaterialLocalizations.of(context).formatMediumDate(day);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
      child: Text(label, style: context.textTheme.labelSmall),
    );
  }
}

class _Bubble extends StatelessWidget {
  const new message({
    required ChatMessage this.message,
    required this.mine,
    required this.read,
    required this.accent,
    required this.gradient,
    required VoidCallback this.onDelete,
    required VoidCallback this.onReport,
    this.senderName,
  }) : pending = null,
       onRetry = null;

  const new pending({
    required PendingMessage this.pending,
    required this.gradient,
    required VoidCallback this.onRetry,
  }) : message = null,
       mine = true,
       read = false,
       accent = null,
       onDelete = null,
       onReport = null,
       senderName = null;

  final ChatMessage? message;
  final PendingMessage? pending;
  final bool mine;
  final bool read;
  final Color? accent;
  final LinearGradient gradient;
  final VoidCallback? onDelete;

  /// Someone else's message: report it (SPEC 10).
  final VoidCallback? onReport;
  final VoidCallback? onRetry;
  final String? senderName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final message = this.message;
    final pending = this.pending;
    final deleted = message?.deletedAt != null;
    final failed = pending?.failed ?? false;
    final text = deleted
        ? l10n.chatDeleted
        : message?.content ?? pending?.content ?? '';
    final kind = message?.kind ?? pending?.kind ?? MessageKind.text;
    final time = (message?.createdAt ?? pending?.createdAt)!;
    final radius = Radius.circular(context.radii.lg);

    final (
      IconData statusIcon,
      String statusLabel,
      Color? statusColor,
    ) = pending != null
        ? (
            failed ? Icons.error_outline : Icons.schedule,
            failed ? l10n.chatFailed : l10n.chatSending,
            failed ? colors.error : null,
          )
        : read
        ? (Icons.done_all, l10n.chatRead, colors.textPrimary)
        : (Icons.done, l10n.chatSent, null);

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.75,
      ),
      margin: EdgeInsets.symmetric(vertical: spacing.xxs),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: mine && !deleted ? gradient : null,
        color: mine && !deleted ? null : colors.surfaceElevated,
        borderRadius: BorderRadius.only(
          topLeft: radius,
          topRight: radius,
          bottomLeft: mine ? radius : Radius.zero,
          bottomRight: mine ? Radius.zero : radius,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (senderName case final name?)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: context.textTheme.labelSmall?.copyWith(
                  color: accent ?? colors.cyan,
                ),
              ),
            ),
          if (!deleted && kind == MessageKind.image) ...[
            ChatImage(path: message?.mediaPath, bytes: pending?.bytes),
            if (text.isNotEmpty) SizedBox(height: spacing.xs),
          ],
          if (!deleted && kind == MessageKind.poll && message?.pollId != null)
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.75 - spacing.sm * 2,
              child: PollCard(
                pollId: message!.pollId!,
                accent: accent ?? colors.cyan,
              ),
            ),
          if (!deleted && kind == MessageKind.audio)
            VoicePlayer(
              path: message?.mediaPath,
              duration: Duration(
                milliseconds:
                    message?.mediaDurationMs ?? pending?.durationMs ?? 0,
              ),
              color: colors.textPrimary,
            ),
          if (deleted || (text.isNotEmpty && kind != MessageKind.poll))
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontStyle: deleted ? FontStyle.italic : null,
                  color: deleted ? colors.textSecondary : colors.textPrimary,
                ),
              ),
            ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MaterialLocalizations.of(context).formatTimeOfDay(
                  TimeOfDay.fromDateTime(time.toLocal()),
                  alwaysUse24HourFormat: true,
                ),
                style: context.textTheme.labelSmall?.copyWith(
                  color: colors.textPrimary.withValues(alpha: 0.7),
                ),
              ),
              if (mine && !deleted) ...[
                const SizedBox(width: 4),
                Icon(
                  statusIcon,
                  size: 14,
                  semanticLabel: statusLabel,
                  color:
                      statusColor ?? colors.textPrimary.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: failed ? onRetry : null,
        onLongPress: deleted
            ? null
            : mine
            ? onDelete
            : onReport,
        child: bubble,
      ),
    );
  }
}
