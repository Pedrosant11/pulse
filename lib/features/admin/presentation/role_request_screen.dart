import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/admin/presentation/role_request_providers.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Ask to become curator or producer (SPEC 4). An admin reviews it.
class RoleRequestScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<RoleRequestScreen> createState() => _RoleRequestScreenState();
}

class _RoleRequestScreenState extends ConsumerState<RoleRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _justification = TextEditingController();
  final _links = TextEditingController();
  UserRole _role = UserRole.curator;

  @override
  void dispose() {
    _justification.dispose();
    _links.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final links = _links.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .take(5)
        .toList();
    final sent = await ref
        .read(roleRequestEditorProvider.notifier)
        .submit(role: _role, justification: _justification.text, links: links);
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.roleRequestSent)));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final role = ref.watch(currentRoleProvider);
    final requests = ref.watch(myRoleRequestsProvider);
    final editor = ref.watch(roleRequestEditorProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.roleRequestTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: requests,
          onRetry: () => ref.invalidate(myRoleRequestsProvider),
          data: (requests) {
            final pending = requests
                .where((r) => r.status == RequestStatus.pending)
                .firstOrNull;
            final lastRejected =
                requests.firstOrNull?.status == RequestStatus.rejected;

            return ListView(
              padding: EdgeInsets.all(spacing.md),
              children: [
                Text(
                  l10n.roleCurrent(l10n.role(role)),
                  style: context.textTheme.titleMedium,
                ),
                SizedBox(height: spacing.md),
                if (role != UserRole.user)
                  const SizedBox.shrink()
                else if (pending != null)
                  GlassCard(
                    child: Text(
                      l10n.roleRequestPending(l10n.role(pending.requestedRole)),
                    ),
                  )
                else
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (lastRejected) ...[
                          Text(
                            l10n.roleRequestRejected,
                            style: context.textTheme.bodySmall,
                          ),
                          SizedBox(height: spacing.md),
                        ],
                        RadioGroup<UserRole>(
                          groupValue: _role,
                          onChanged: (v) =>
                              setState(() => _role = v ?? UserRole.curator),
                          child: Column(
                            children: [
                              RadioListTile<UserRole>(
                                value: UserRole.curator,
                                contentPadding: EdgeInsets.zero,
                                title: Text(l10n.roleCurator),
                                subtitle: Text(l10n.roleCuratorDescription),
                              ),
                              RadioListTile<UserRole>(
                                value: UserRole.producer,
                                contentPadding: EdgeInsets.zero,
                                title: Text(l10n.roleProducer),
                                subtitle: Text(l10n.roleProducerDescription),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        TextFormField(
                          controller: _justification,
                          maxLength: 1000,
                          minLines: 3,
                          maxLines: 6,
                          decoration: InputDecoration(
                            labelText: l10n.roleJustification,
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
                            hintText: l10n.roleLinksHint,
                            alignLabelWithHint: true,
                          ),
                        ),
                        SizedBox(height: spacing.lg),
                        FormErrorText(error: editor.error),
                        NeonButton(
                          label: l10n.roleSubmit,
                          isLoading: editor.isLoading,
                          onPressed: _submit,
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
