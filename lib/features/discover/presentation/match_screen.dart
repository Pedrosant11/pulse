import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/neon_backdrop.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/rive_slot.dart';
import 'package:pulse/core/widgets/shader_effects.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';

/// Full-screen match celebration (SPEC 8.3): `match_burst.frag` light burst,
/// optional Rive animation and the photos of both people.
class MatchScreen extends ConsumerWidget {
  const new({required this.args, super.key});

  final MatchArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final other = args.other;
    final accent = colors.accentOf(args.mode);
    final reduceMotion = context.reduceMotion;
    final myPhoto = ref.watch(myPhotosProvider).value?.firstOrNull?.storagePath;
    final event = other.commonEvents.firstOrNull;
    final isDate = args.mode == AppMode.date;
    final conversationId = args.conversationId;

    Widget avatar(String? path, double angle) => Transform.rotate(
      angle: angle,
      child: Container(
        width: 132,
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.radii.lg),
          border: Border.all(color: accent, width: 3),
          boxShadow: [
            BoxShadow(color: accent.withValues(alpha: 0.6), blurRadius: 28),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.radii.lg - 3),
          child: path == null
              ? ColoredBox(color: colors.surfaceElevated)
              : ProfilePhotoImage(path, decodeWidth: 132),
        ),
      ),
    );

    // Static glow: reduced motion, and while the shader loads.
    final glow = RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              accent.withValues(alpha: 0.55),
              colors.violet.withValues(alpha: 0.25),
              colors.background.withValues(alpha: 0),
            ],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
    final burst = AnimatedShader(
      asset: Shaders.matchBurst,
      fallback: glow,
      setUniforms: (shader, size, seconds) {
        var i = shader.setSize(0, size);
        shader
          ..setFloat(i++, seconds)
          // Grows during the first 0.9 s, then keeps turning.
          ..setFloat(i++, (seconds / 0.9).clamp(0, 1));
        i = shader.setColor(i, accent);
        shader.setColor(i, colors.violet);
      },
    );

    Widget title = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: colors.gradientOf(args.mode).createShader,
      child: Text(
        isDate ? l10n.matchTitleDate : l10n.matchTitleCrew,
        textAlign: TextAlign.center,
        style: context.textTheme.displayMedium,
      ),
    );
    Widget photos = SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 110,
            child: Center(child: avatar(myPhoto, -0.12)),
          ),
          Positioned(
            left: 110,
            right: 0,
            child: Center(child: avatar(other.photoPaths.firstOrNull, 0.12)),
          ),
        ],
      ),
    );
    if (!reduceMotion) {
      title = title
          .animate()
          .fadeIn(delay: 250.ms, duration: 300.ms)
          .scaleXY(begin: 1.4, curve: Curves.easeOutBack);
      photos = photos
          .animate()
          .fadeIn(delay: 150.ms, duration: 300.ms)
          .slideY(begin: 0.2, curve: Curves.easeOut);
    }

    return NeonBackdrop(
      // The burst is the animated layer here.
      animated: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            burst,
            // Optional Rive celebration (docs/RIVE.md).
            const IgnorePointer(
              child: RiveSlot(
                asset: RiveAssets.match,
                fallback: SizedBox.shrink(),
              ),
            ),
            SafeArea(
              // Scrolls only when the screen is too short; the spacers
              // center the content otherwise.
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: EdgeInsets.all(spacing.lg),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - spacing.lg * 2,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),
                          title,
                          SizedBox(height: spacing.sm),
                          Text(
                            isDate
                                ? l10n.matchSubtitleDate(other.firstName)
                                : l10n.matchSubtitleCrew(other.firstName),
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge,
                          ),
                          SizedBox(height: spacing.xl),
                          photos,
                          if (event != null) ...[
                            SizedBox(height: spacing.lg),
                            Text(
                              l10n.discoverGoingTo(event.name),
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: accent,
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Crew: the main action is building a crew for the
                          // common event, inviting this person (SPEC 9.2).
                          if (!isDate && event != null) ...[
                            NeonButton(
                              label: l10n.matchBuildCrew(event.name),
                              icon: Icons.groups_rounded,
                              gradient: colors.crewGradient,
                              onPressed: () => context.pushReplacement(
                                AppRoutes.newCrew(
                                  eventId: event.id,
                                  eventName: event.name,
                                  inviteUserId: other.id,
                                  inviteName: other.firstName,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing.sm),
                          ],
                          if (!isDate && event != null)
                            OutlinedButton.icon(
                              onPressed: conversationId == null
                                  ? null
                                  : () => context.pushReplacement(
                                      AppRoutes.conversation(conversationId),
                                    ),
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: Text(l10n.matchSendMessage),
                            )
                          else
                            NeonButton(
                              label: l10n.matchSendMessage,
                              icon: Icons.chat_bubble_rounded,
                              gradient: colors.gradientOf(args.mode),
                              onPressed: conversationId == null
                                  ? null
                                  : () => context.pushReplacement(
                                      AppRoutes.conversation(conversationId),
                                    ),
                            ),
                          SizedBox(height: spacing.sm),
                          TextButton(
                            onPressed: context.pop,
                            child: Text(l10n.matchContinue),
                          ),
                          // SPEC 10: safety tips at the moment people may meet.
                          TextButton.icon(
                            onPressed: () => context.push(AppRoutes.safetyTips),
                            icon: const Icon(Icons.health_and_safety_outlined),
                            label: Text(l10n.matchSafetyTips),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
