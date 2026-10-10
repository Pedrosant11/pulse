import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/presentation/widgets/requester_header.dart';
import 'package:pulse/features/badges/domain/badge_models.dart';
import 'package:pulse/features/badges/presentation/badges_providers.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/plans/presentation/widgets/admin_plan_section.dart';

/// Admin panel → Selos (SPEC 6.4): pending requests and granting badges to
/// anyone found by name.
class AdminBadgesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AdminBadgesScreen> createState() => _AdminBadgesScreenState();
}

class _AdminBadgesScreenState extends ConsumerState<AdminBadgesScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => setState(() => _query = text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final requests = ref.watch(pendingBadgeRequestsProvider);
    final results = ref.watch(adminUserSearchProvider(_query));
    final editor = ref.watch(badgeEditorProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.adminBadges.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            Text(
              l10n.adminBadgeRequests.toUpperCase(),
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: spacing.sm),
            FormErrorText(error: editor.error),
            AsyncValueView(
              value: requests,
              onRetry: () => ref.invalidate(pendingBadgeRequestsProvider),
              loading: const LoadingView(itemCount: 1),
              data: (requests) => requests.isEmpty
                  ? Text(l10n.adminNoBadgeRequests)
                  : Column(
                      children: [
                        for (final request in requests)
                          Padding(
                            padding: EdgeInsets.only(bottom: spacing.sm),
                            child: _RequestCard(request: request),
                          ),
                      ],
                    ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              l10n.adminGiveBadge.toUpperCase(),
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _search,
              onChanged: _onSearch,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.adminSearchPeople,
                prefixIcon: const Icon(Icons.person_search_outlined),
              ),
            ),
            SizedBox(height: spacing.sm),
            AsyncValueView(
              value: results,
              onRetry: () => ref.invalidate(adminUserSearchProvider(_query)),
              loading: const LoadingView(itemCount: 1),
              data: (people) => Column(
                children: [
                  for (final person in people)
                    Padding(
                      padding: EdgeInsets.only(bottom: spacing.xs),
                      child: GlassCard(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: ChatAvatar(
                            photoPath: person.photoPath,
                            size: 40,
                          ),
                          title: Text(person.fullName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (person.city != null)
                                Text('${person.city}, ${person.state}'),
                              ProfileBadges(userId: person.userId, dense: true),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => showManageBadges(
                            context,
                            userId: person.userId,
                            name: person.fullName,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends ConsumerWidget {
  const new({required this.request});

  final BadgeRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final editor = ref.watch(badgeEditorProvider);
    final notifier = ref.read(badgeEditorProvider.notifier);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RequesterHeader(
            userId: request.userId,
            name: request.requesterName,
            trailing: BadgeChip(
              badge: UserBadge(badge: request.badge),
              dense: true,
            ),
          ),
          Text(request.justification),
          for (final link in request.links)
            Text(
              link,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.cyan,
              ),
            ),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: editor.isLoading
                    ? null
                    : () => notifier.review(request, approve: false),
                child: Text(l10n.reject),
              ),
              FilledButton(
                onPressed: editor.isLoading
                    ? null
                    : () => notifier.review(request, approve: true),
                child: Text(l10n.approve),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Give, retitle or remove someone's badges (admins).
Future<void> showManageBadges(
  BuildContext context, {
  required String userId,
  required String name,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    builder: (_) => _ManageBadgesSheet(userId: userId, name: name),
  );
}

class _ManageBadgesSheet extends ConsumerStatefulWidget {
  const new({required this.userId, required this.name});

  final String userId;
  final String name;

  @override
  ConsumerState<_ManageBadgesSheet> createState() => _ManageBadgesSheetState();
}

class _ManageBadgesSheetState extends ConsumerState<_ManageBadgesSheet> {
  final Map<ProfileBadgeType, TextEditingController> _titles = {
    for (final badge in ProfileBadgeType.grantable)
      badge: TextEditingController(),
  };
  bool _filled = false;

  @override
  void dispose() {
    for (final controller in _titles.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final badges = ref.watch(userBadgesProvider(widget.userId));
    final editor = ref.watch(badgeEditorProvider);
    final notifier = ref.read(badgeEditorProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AsyncValueView(
        value: badges,
        onRetry: () => ref.invalidate(userBadgesProvider(widget.userId)),
        data: (current) {
          final owned = {for (final b in current) b.badge: b};
          if (!_filled) {
            _filled = true;
            for (final MapEntry(key: badge, value: controller)
                in _titles.entries) {
              controller.text = owned[badge]?.title ?? '';
            }
          }
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(spacing.md),
            children: [
              Text(
                l10n.adminBadgesOf(widget.name).toUpperCase(),
                style: context.textTheme.titleLarge,
              ),
              if (owned.containsKey(ProfileBadgeType.producer)) ...[
                SizedBox(height: spacing.xs),
                Text(
                  l10n.adminProducerFromRole,
                  style: context.textTheme.bodySmall,
                ),
              ],
              SizedBox(height: spacing.sm),
              FormErrorText(error: editor.error),
              for (final badge in ProfileBadgeType.grantable)
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.sm),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: owned.containsKey(badge),
                          activeThumbColor: badgeColor(context, badge),
                          secondary: Icon(
                            badgeIcon(badge),
                            color: badgeColor(context, badge),
                          ),
                          title: Text(badgeLabel(l10n, badge)),
                          onChanged: editor.isLoading
                              ? null
                              : (on) => on
                                    ? notifier.grant(
                                        userId: widget.userId,
                                        badge: badge,
                                        title: _titles[badge]!.text,
                                      )
                                    : notifier.revoke(
                                        userId: widget.userId,
                                        badge: badge,
                                      ),
                        ),
                        TextField(
                          controller: _titles[badge],
                          maxLength: 40,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: l10n.adminBadgeTitle,
                            hintText: badge == ProfileBadgeType.team
                                ? l10n.adminBadgeTitleTeamHint
                                : l10n.adminBadgeTitleHint,
                            suffixIcon: owned.containsKey(badge)
                                ? IconButton(
                                    tooltip: l10n.saveButton,
                                    icon: const Icon(Icons.check),
                                    onPressed: editor.isLoading
                                        ? null
                                        : () => notifier.grant(
                                            userId: widget.userId,
                                            badge: badge,
                                            title: _titles[badge]!.text,
                                          ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Plan and packs (tests, partners, support).
              AdminPlanSection(userId: widget.userId),
            ],
          );
        },
      ),
    );
  }
}
