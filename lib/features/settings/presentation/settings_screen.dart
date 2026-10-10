import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:pulse/features/legal/presentation/legal_document_screen.dart';
import 'package:pulse/features/legal/presentation/privacy_providers.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/plans/presentation/widgets/plans_prompt.dart';

class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final signOut = ref.watch(signOutControllerProvider);
    final controller = ref.read(signOutControllerProvider.notifier);
    final role = ref.watch(currentRoleProvider);
    final dataExport = ref.watch(dataExportProvider);
    final plan = ref.watch(entitlementsProvider).value;

    Widget section(String title, List<Widget> tiles) => Padding(
      padding: EdgeInsets.only(bottom: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title.toUpperCase(), style: context.textTheme.titleLarge),
          SizedBox(height: spacing.sm),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(children: tiles),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.settingsTitle.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            section(l10n.settingsPlanSection, [
              ListTile(
                leading: Icon(
                  Icons.workspace_premium_rounded,
                  color: colors.lime,
                ),
                title: Text(l10n.settingsMyPlan),
                subtitle: Text(switch (plan?.tier) {
                  final tier? => l10n.planName(tier.name),
                  null => l10n.planFree,
                }),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.plans),
              ),
              // Incognito works with Black; others see the plans.
              SwitchListTile(
                secondary: const Icon(Icons.visibility_off_outlined),
                title: Text(l10n.incognitoTitle),
                subtitle: Text(l10n.incognitoSubtitle),
                value: (plan?.isBlack ?? false) && plan!.incognito,
                onChanged: plan == null
                    ? null
                    : (enabled) => plan.isBlack
                          ? ref
                                .read(planActionsProvider.notifier)
                                .setIncognito(enabled: enabled)
                          : showPlansPrompt(context, PlanFeature.incognito),
              ),
            ]),
            section(l10n.settingsAccountSection, [
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(l10n.roleRequestEntry),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.roleRequest),
              ),
              ListTile(
                leading: const Icon(Icons.verified_outlined),
                title: Text(l10n.badgeRequestEntry),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.badgeRequest),
              ),
              if (role.isModerator)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: Text(l10n.openAdmin),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.admin),
                ),
            ]),
            section(l10n.settingsSafetySection, [
              ListTile(
                leading: const Icon(Icons.block_outlined),
                title: Text(l10n.blockedUsersTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.blockedUsers),
              ),
              ListTile(
                leading: const Icon(Icons.health_and_safety_outlined),
                title: Text(l10n.safetyTipsTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.safetyTips),
              ),
            ]),
            // LGPD: documents and the right to access/port the data.
            section(l10n.settingsPrivacySection, [
              for (final (doc, icon) in const [
                (LegalDocument.terms, Icons.description_outlined),
                (LegalDocument.privacy, Icons.privacy_tip_outlined),
                (LegalDocument.guidelines, Icons.groups_outlined),
              ])
                ListTile(
                  leading: Icon(icon),
                  title: Text(legalTitle(l10n, doc)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.legal(doc)),
                ),
              ListTile(
                leading: dataExport.isLoading
                    ? const SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                title: Text(l10n.exportDataEntry),
                subtitle: Text(l10n.exportDataHint),
                enabled: !dataExport.isLoading,
                onTap: ref.read(dataExportProvider.notifier).export,
              ),
            ]),
            FormErrorText(error: dataExport.error),
            section(l10n.settingsSessionSection, [
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: Text(l10n.signOut),
                enabled: !signOut.isLoading,
                onTap: controller.signOut,
              ),
              ListTile(
                leading: const Icon(Icons.devices_outlined),
                title: Text(l10n.signOutAllDevices),
                subtitle: Text(l10n.signOutAllDevicesHint),
                enabled: !signOut.isLoading,
                onTap: () => controller.signOut(allDevices: true),
              ),
            ]),
            FormErrorText(error: signOut.error),
            section(l10n.settingsDangerSection, [
              ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: colors.error,
                ),
                title: Text(
                  l10n.deleteAccountEntry,
                  style: TextStyle(color: colors.error),
                ),
                onTap: () => context.push(AppRoutes.deleteAccount),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
