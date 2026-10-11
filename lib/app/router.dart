import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/home_shell.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/features/admin/presentation/admin_screen.dart';
import 'package:pulse/features/admin/presentation/reports_screen.dart';
import 'package:pulse/features/admin/presentation/restricted_users_screen.dart';
import 'package:pulse/features/admin/presentation/role_request_screen.dart';
import 'package:pulse/features/auth/presentation/account_setup_screen.dart';
import 'package:pulse/features/auth/presentation/check_email_screen.dart';
import 'package:pulse/features/auth/presentation/forgot_password_screen.dart';
import 'package:pulse/features/auth/presentation/login_screen.dart';
import 'package:pulse/features/auth/presentation/reset_password_screen.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/auth/presentation/signup_screen.dart';
import 'package:pulse/features/auth/presentation/splash_screen.dart';
import 'package:pulse/features/badges/presentation/admin_badges_screen.dart';
import 'package:pulse/features/badges/presentation/badge_request_screen.dart';
import 'package:pulse/features/chat/presentation/chats_screen.dart';
import 'package:pulse/features/chat/presentation/conversation_screen.dart';
import 'package:pulse/features/crews/presentation/crew_form_screen.dart';
import 'package:pulse/features/crews/presentation/crew_screen.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/discover_screen.dart';
import 'package:pulse/features/discover/presentation/match_screen.dart';
import 'package:pulse/features/events/presentation/event_detail_screen.dart';
import 'package:pulse/features/events/presentation/event_form_screen.dart';
import 'package:pulse/features/events/presentation/events_screen.dart';
import 'package:pulse/features/events/presentation/moderation_queue_screen.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:pulse/features/legal/presentation/legal_document_screen.dart';
import 'package:pulse/features/onboarding/presentation/activate_modes_screen.dart';
import 'package:pulse/features/onboarding/presentation/onboarding_screen.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/likes_you_screen.dart';
import 'package:pulse/features/plans/presentation/plans_screen.dart';
import 'package:pulse/features/profile/presentation/edit_profile_screen.dart';
import 'package:pulse/features/profile/presentation/profile_screen.dart';
import 'package:pulse/features/safety/presentation/account_restricted_screen.dart';
import 'package:pulse/features/safety/presentation/blocked_users_screen.dart';
import 'package:pulse/features/safety/presentation/safety_tips_screen.dart';
import 'package:pulse/features/settings/presentation/delete_account_screen.dart';
import 'package:pulse/features/settings/presentation/settings_screen.dart';
import 'package:pulse/features/verification/presentation/admin_verifications_screen.dart';
import 'package:pulse/features/verification/presentation/verification_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Bridges the session provider into GoRouter's refreshListenable so the
  // router instance is created once and only re-runs its redirect.
  final session = ValueNotifier(ref.read(sessionStatusProvider));
  ref
    ..listen(sessionStatusProvider, (_, next) => session.value = next)
    ..onDispose(session.dispose);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: session,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) => resolveRedirect(
      status: session.value,
      location: state.uri.path,
      home: (ref.read(accountProvider).value?.eventsOnly ?? false)
          ? AppRoutes.events
          : AppRoutes.discover,
    ),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.signup, builder: (_, _) => const SignupScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkEmail,
        builder: (_, state) =>
            CheckEmailScreen(email: state.uri.queryParameters['email'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, _) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountSetup,
        builder: (_, _) => const AccountSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                builder: (_, _) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.events,
                builder: (_, _) => const EventsScreen(),
                routes: [
                  // Declared before ':eventId' so "new" is not an id.
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) => const EventFormScreen(),
                  ),
                  GoRoute(
                    path: 'queue',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) => const ModerationQueueScreen(),
                  ),
                  GoRoute(
                    path: ':eventId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => EventDetailScreen(
                      eventId: state.pathParameters['eventId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (_, state) => EventFormScreen(
                          eventId: state.pathParameters['eventId'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chats,
                builder: (_, _) => const ChatsScreen(),
                routes: [
                  GoRoute(
                    path: ':conversationId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => ConversationScreen(
                      conversationId: state.pathParameters['conversationId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) => const EditProfileScreen(),
                    routes: [
                      GoRoute(
                        path: ':section',
                        parentNavigatorKey: _rootNavigatorKey,
                        redirect: (_, state) =>
                            ProfileSection.values.asNameMap().containsKey(
                              state.pathParameters['section'],
                            )
                            ? null
                            : AppRoutes.editProfile,
                        builder: (_, state) => EditProfileSectionScreen(
                          section: ProfileSection.values.byName(
                            state.pathParameters['section']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.crews,
        redirect: (_, state) =>
            state.uri.path == AppRoutes.crews ? AppRoutes.chats : null,
        routes: [
          // Declared before ':crewId' so "new" is not an id.
          GoRoute(
            path: 'new',
            builder: (_, state) {
              final query = state.uri.queryParameters;
              return CrewFormScreen(
                eventId: query['event'],
                eventName: query['event_name'],
                inviteUserId: query['invite'],
                inviteName: query['invite_name'],
              );
            },
          ),
          GoRoute(
            path: ':crewId',
            builder: (_, state) =>
                CrewScreen(crewId: state.pathParameters['crewId']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, state) =>
                    CrewFormScreen(crewId: state.pathParameters['crewId']),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.match,
        parentNavigatorKey: _rootNavigatorKey,
        // Opened right after a swipe; without its data (e.g. a deep link) it
        // falls back to Discover.
        redirect: (_, state) =>
            state.extra is MatchArgs ? null : AppRoutes.discover,
        pageBuilder: (_, state) => CustomTransitionPage(
          fullscreenDialog: true,
          child: MatchScreen(args: state.extra! as MatchArgs),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'role-request',
            builder: (_, _) => const RoleRequestScreen(),
          ),
          GoRoute(
            path: 'badge-request',
            builder: (_, _) => const BadgeRequestScreen(),
          ),
          GoRoute(
            path: 'verification',
            builder: (_, _) => const VerificationScreen(),
          ),
          GoRoute(
            path: 'blocked',
            builder: (_, _) => const BlockedUsersScreen(),
          ),
          GoRoute(
            path: 'delete-account',
            builder: (_, _) => const DeleteAccountScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.legalPrefix}/:doc',
        redirect: (_, state) =>
            LegalDocument.fromSlug(state.pathParameters['doc']!) == null
            ? AppRoutes.legal(LegalDocument.terms)
            : null,
        builder: (_, state) => LegalDocumentScreen(
          document: LegalDocument.fromSlug(state.pathParameters['doc']!)!,
        ),
      ),
      GoRoute(
        path: AppRoutes.activateModes,
        builder: (_, _) => const ActivateModesScreen(),
      ),
      GoRoute(
        path: AppRoutes.plans,
        builder: (_, state) => PlansScreen(
          feature: PlanFeature.values
              .asNameMap()[state.uri.queryParameters['feature']],
        ),
      ),
      GoRoute(
        path: AppRoutes.likesYou,
        builder: (_, _) => const LikesYouScreen(),
      ),
      GoRoute(
        path: AppRoutes.safetyTips,
        builder: (_, _) => const SafetyTipsScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountRestricted,
        builder: (_, _) => const AccountRestrictedScreen(),
      ),
      // The screens hide sections by role; the data is protected by RLS.
      GoRoute(
        path: AppRoutes.admin,
        builder: (_, _) => const AdminScreen(),
        routes: [
          GoRoute(path: 'reports', builder: (_, _) => const ReportsScreen()),
          GoRoute(path: 'badges', builder: (_, _) => const AdminBadgesScreen()),
          GoRoute(
            path: 'verifications',
            builder: (_, _) => const AdminVerificationsScreen(),
          ),
          GoRoute(
            path: 'restricted',
            builder: (_, _) => const RestrictedUsersScreen(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
