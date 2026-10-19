import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/features/admin/presentation/reports_screen.dart';
import 'package:pulse/features/admin/presentation/restricted_users_screen.dart';
import 'package:pulse/features/admin_web/presentation/admin_login_screen.dart';
import 'package:pulse/features/admin_web/presentation/admin_settings_screen.dart';
import 'package:pulse/features/admin_web/presentation/admin_shell.dart';
import 'package:pulse/features/admin_web/presentation/dashboard_screen.dart';
import 'package:pulse/features/admin_web/presentation/role_requests_screen.dart';
import 'package:pulse/features/ads/presentation/ad_form_screen.dart';
import 'package:pulse/features/ads/presentation/admin_ads_screen.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/presentation/admin_badges_screen.dart';
import 'package:pulse/features/events/presentation/admin_featured_screen.dart';
import 'package:pulse/features/events/presentation/event_detail_screen.dart';
import 'package:pulse/features/events/presentation/event_form_screen.dart';
import 'package:pulse/features/events/presentation/event_insights_screen.dart';
import 'package:pulse/features/events/presentation/moderation_queue_screen.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/verification/presentation/admin_verifications_screen.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_web_app.g.dart';

/// Console paths. The reused admin screens push the app's own paths
/// (event detail, ad form), so those exist here too.
abstract final class ConsoleRoutes {
  static const login = '/login';
  static const denied = '/denied';
  static const dashboard = '/admin';
  static const events = '/admin/events';
  static const reports = '/admin/reports';
  static const restricted = '/admin/restricted';
  static const people = '/admin/people';
  static const verifications = '/admin/verifications';
  static const roles = '/admin/roles';
  static const featured = '/admin/featured';
  static const ads = '/admin/ads';
  static const settings = '/admin/settings';
}

/// Signed-in state for the console: null while loading.
enum ConsoleAccess { signedOut, notAdmin, admin }

@Riverpod(keepAlive: true)
ConsoleAccess? consoleAccess(Ref ref) {
  final auth = ref.watch(authChangesProvider);
  if (!auth.hasValue) return null;
  if (auth.requireValue.session == null) return ConsoleAccess.signedOut;
  final profile = ref.watch(myProfileProvider);
  if (profile.isLoading && !profile.hasValue) return null;
  return profile.value?.role == UserRole.admin
      ? ConsoleAccess.admin
      : ConsoleAccess.notAdmin;
}

@Riverpod(keepAlive: true)
GoRouter consoleRouter(Ref ref) {
  final refresh = ValueNotifier(0);
  ref
    ..listen(consoleAccessProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  String? redirect(BuildContext _, GoRouterState state) {
    final access = ref.read(consoleAccessProvider);
    final at = state.matchedLocation;
    if (access == null) return null;
    return switch (access) {
      ConsoleAccess.signedOut =>
        at == ConsoleRoutes.login ? null : ConsoleRoutes.login,
      ConsoleAccess.notAdmin =>
        at == ConsoleRoutes.denied ? null : ConsoleRoutes.denied,
      ConsoleAccess.admin =>
        at == ConsoleRoutes.login || at == ConsoleRoutes.denied || at == '/'
            ? ConsoleRoutes.dashboard
            : null,
    };
  }

  GoRoute page(
    String path,
    Widget child, {
    List<RouteBase> routes = const [],
  }) => GoRoute(
    path: path,
    pageBuilder: (_, state) =>
        NoTransitionPage(key: state.pageKey, child: child),
    routes: routes,
  );

  final router = GoRouter(
    initialLocation: ConsoleRoutes.dashboard,
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => ConsoleRoutes.dashboard),
      GoRoute(
        path: ConsoleRoutes.login,
        builder: (_, _) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: ConsoleRoutes.denied,
        builder: (_, _) => const AdminDeniedScreen(),
      ),
      ShellRoute(
        builder: (_, state, child) =>
            AdminShell(location: state.matchedLocation, child: child),
        routes: [
          page(ConsoleRoutes.dashboard, const DashboardScreen()),
          page(ConsoleRoutes.events, const ModerationQueueScreen()),
          page(ConsoleRoutes.reports, const ReportsScreen()),
          page(ConsoleRoutes.restricted, const RestrictedUsersScreen()),
          page(ConsoleRoutes.people, const AdminBadgesScreen()),
          page(ConsoleRoutes.verifications, const AdminVerificationsScreen()),
          page(ConsoleRoutes.roles, const RoleRequestsScreen()),
          page(ConsoleRoutes.featured, const AdminFeaturedScreen()),
          page(
            ConsoleRoutes.ads,
            const AdminAdsScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                redirect: (_, state) =>
                    state.extra is AdFormArgs ? null : ConsoleRoutes.ads,
                builder: (_, state) =>
                    AdFormScreen(args: state.extra! as AdFormArgs),
              ),
            ],
          ),
          page(ConsoleRoutes.settings, const AdminSettingsScreen()),
          // Opened from the queue, highlights and ads.
          GoRoute(
            path: '${AppRoutes.events}/:eventId',
            builder: (_, state) =>
                EventDetailScreen(eventId: state.pathParameters['eventId']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, state) =>
                    EventFormScreen(eventId: state.pathParameters['eventId']),
              ),
              GoRoute(
                path: 'insights',
                builder: (_, state) => EventInsightsScreen(
                  eventId: state.pathParameters['eventId']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

class AdminWebApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Pulse · Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      locale: const Locale('pt', 'BR'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      // Same bridge as the app (packages on package:flutter/material.dart).
      // ignore: deprecated_member_use
      builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
      routerConfig: ref.watch(consoleRouterProvider),
    );
  }
}
