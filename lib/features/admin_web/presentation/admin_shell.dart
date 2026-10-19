import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/admin_web/presentation/admin_console_providers.dart';
import 'package:pulse/features/admin_web/presentation/admin_login_screen.dart';
import 'package:pulse/features/admin_web/presentation/admin_web_app.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';

/// Side menu (wide screens) or drawer (narrow) around each console page.
class AdminShell extends ConsumerWidget {
  const new({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  static const _wide = 900.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final pending = ref.watch(adminDashboardProvider).value?.pending;
    final items = [
      (
        ConsoleRoutes.dashboard,
        Icons.space_dashboard_outlined,
        l10n.consoleDashboard,
        null,
      ),
      (
        ConsoleRoutes.events,
        Icons.fact_check_outlined,
        l10n.moderationQueue,
        pending?.events,
      ),
      (
        ConsoleRoutes.reports,
        Icons.flag_outlined,
        l10n.adminReports,
        pending?.reports,
      ),
      (
        ConsoleRoutes.verifications,
        Icons.face_retouching_natural_outlined,
        l10n.adminVerifications,
        pending?.verifications,
      ),
      (
        ConsoleRoutes.people,
        Icons.manage_accounts_outlined,
        l10n.consolePeople,
        pending?.badges,
      ),
      (
        ConsoleRoutes.roles,
        Icons.workspace_premium_outlined,
        l10n.adminRoleRequests,
        pending?.roles,
      ),
      (
        ConsoleRoutes.restricted,
        Icons.person_off_outlined,
        l10n.adminRestrictedUsers,
        null,
      ),
      (
        ConsoleRoutes.featured,
        Icons.rocket_launch_outlined,
        l10n.adminFeatured,
        pending?.featured,
      ),
      (ConsoleRoutes.ads, Icons.campaign_outlined, l10n.adminAds, null),
      (ConsoleRoutes.settings, Icons.tune_rounded, l10n.consoleSettings, null),
    ];
    bool selected(String path) => path == ConsoleRoutes.dashboard
        ? location == path
        : location.startsWith(path);

    Widget menu({required bool inDrawer}) => ListView(
      padding: EdgeInsets.symmetric(vertical: context.spacing.md),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.spacing.md,
            0,
            context.spacing.md,
            context.spacing.md,
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: ConsoleBrand(),
          ),
        ),
        for (final (path, icon, label, count) in items)
          ListTile(
            selected: selected(path),
            selectedColor: colors.textPrimary,
            selectedTileColor: colors.magenta.withValues(alpha: 0.16),
            leading: Icon(icon),
            title: Text(label),
            trailing: (count ?? 0) > 0
                ? Badge(label: Text('$count'), backgroundColor: colors.magenta)
                : null,
            onTap: () {
              if (inDrawer) Navigator.of(context).pop();
              context.go(path);
            },
          ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: Text(l10n.signOut),
          onTap: () => ref.read(signOutControllerProvider.notifier).signOut(),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _wide) {
          return Scaffold(
            backgroundColor: colors.background,
            body: Row(
              children: [
                SizedBox(
                  width: 260,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      border: Border(
                        right: BorderSide(color: colors.glassBorder),
                      ),
                    ),
                    child: menu(inDrawer: false),
                  ),
                ),
                // Pages stay readable on large monitors.
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          backgroundColor: colors.background,
          drawer: Drawer(
            backgroundColor: colors.surface,
            child: menu(inDrawer: true),
          ),
          appBar: AppBar(title: const ConsoleBrand()),
          body: child,
        );
      },
    );
  }
}
