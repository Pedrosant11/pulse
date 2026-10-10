import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Account deletion (SPEC 5.2, required by the stores). The password is
/// re-checked by the `delete-account` Edge Function.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountConfirmTitle),
        content: Text(l10n.deleteAccountConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteAccountButton,
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final deleted = await ref
        .read(deleteAccountControllerProvider.notifier)
        .delete(_password.text);
    // The sign-out sends the router to the login screen.
    if (deleted == true) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteAccountDone)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final state = ref.watch(deleteAccountControllerProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.deleteAccountTitle.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            GlassCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: colors.error),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.deleteAccountWarning,
                          style: context.textTheme.bodyLarge,
                        ),
                        SizedBox(height: spacing.xs),
                        Text(
                          l10n.deleteAccountCrewsNote,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.lg),
            PasswordField(
              controller: _password,
              label: l10n.deleteAccountPassword,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: spacing.md),
            FormErrorText(error: state.error),
            NeonButton(
              label: l10n.deleteAccountButton,
              icon: Icons.delete_forever_outlined,
              gradient: LinearGradient(colors: [colors.error, colors.magenta]),
              isLoading: state.isLoading,
              onPressed: _password.text.isEmpty ? null : _delete,
            ),
          ],
        ),
      ),
    );
  }
}
