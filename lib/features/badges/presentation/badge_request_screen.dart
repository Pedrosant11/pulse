import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/domain/badge_models.dart';
import 'package:pulse/features/badges/presentation/badges_providers.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';

/// Ask for a DJ or Figura pública badge (SPEC 6.4). An admin reviews it.
class BadgeRequestScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BadgeRequestScreen> createState() => _BadgeRequestScreenState();
}

class _BadgeRequestScreenState extends ConsumerState<BadgeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _justification = TextEditingController();
  final _links = TextEditingController();
  ProfileBadgeType? _badge;

  @override
  void dispose() {
    _justification.dispose();
    _links.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final badge = _badge;
    if (badge == null || !_formKey.currentState!.validate()) return;
    final links = _links.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .take(5)
        .toList();
    final sent = await ref
        .read(badgeEditorProvider.notifier)
        .request(
          badge: badge,
          justification: _justification.text,
          links: links,
        );
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.badgeRequestSent)));
      await Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final userId = ref.watch(currentUserIdProvider);
    final mine = userId == null
        ? const <UserBadge>[]
        : ref.watch(userBadgesProvider(userId)).value ?? const [];
    final requests = ref.watch(myBadgeRequestsProvider);
    final editor = ref.watch(badgeEditorProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.badgeRequestTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: requests,
          onRetry: () => ref.invalidate(myBadgeRequestsProvider),
          data: (requests) {
            final pending = {
              for (final r in requests)
                if (r.status == RequestStatus.pending) r.badge,
            };
            final owned = {for (final b in mine) b.badge};
            final available = [
              for (final b in ProfileBadgeType.requestable)
                if (!owned.contains(b) && !pending.contains(b)) b,
            ];
            if (_badge != null && !available.contains(_badge)) _badge = null;

            return ListView(
              padding: EdgeInsets.all(spacing.md),
              children: [
                Text(
                  l10n.badgeRequestIntro,
                  style: context.textTheme.bodyLarge,
                ),
                if (mine.isNotEmpty) ...[
                  SizedBox(height: spacing.md),
                  Text(l10n.badgeYours, style: context.textTheme.labelLarge),
                  SizedBox(height: spacing.xs),
                  Wrap(
                    spacing: spacing.xs,
                    children: [for (final b in mine) BadgeChip(badge: b)],
                  ),
                ],
                for (final badge in pending) ...[
                  SizedBox(height: spacing.sm),
                  GlassCard(
                    child: Text(
                      l10n.badgeRequestPending(badgeLabel(l10n, badge)),
                    ),
                  ),
                ],
                SizedBox(height: spacing.md),
                if (available.isEmpty)
                  Text(l10n.badgeNothingToRequest)
                else
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: spacing.xs,
                          children: [
                            for (final badge in available)
                              ChoiceChip(
                                avatar: Icon(badgeIcon(badge), size: 18),
                                label: Text(badgeLabel(l10n, badge)),
                                selected: _badge == badge,
                                onSelected: (_) =>
                                    setState(() => _badge = badge),
                              ),
                          ],
                        ),
                        SizedBox(height: spacing.md),
                        TextFormField(
                          controller: _justification,
                          maxLength: 1000,
                          minLines: 3,
                          maxLines: 6,
                          decoration: InputDecoration(
                            labelText: l10n.badgeJustification,
                            hintText: l10n.badgeJustificationHint,
                            alignLabelWithHint: true,
                          ),
                          validator: (v) => (v ?? '').trim().length < 10
                              ? l10n.validationJustification
                              : null,
                        ),
                        SizedBox(height: spacing.sm),
                        TextFormField(
                          controller: _links,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: l10n.roleLinks,
                            hintText: l10n.badgeLinksHint,
                            alignLabelWithHint: true,
                          ),
                        ),
                        SizedBox(height: spacing.lg),
                        FormErrorText(error: editor.error),
                        NeonButton(
                          label: l10n.roleSubmit,
                          isLoading: editor.isLoading,
                          onPressed: _badge == null ? null : _submit,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
