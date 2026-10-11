import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/verification/domain/verification_models.dart';
import 'package:pulse/features/verification/presentation/verification_labels.dart';
import 'package:pulse/features/verification/presentation/verification_providers.dart';

/// Selfie verification: random pose → live selfie → admin review.
class VerificationScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(myProfileProvider);
    final request = ref.watch(myVerificationProvider);
    final photos = ref.watch(myPhotosProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.verificationTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: request,
          onRetry: () => ref.invalidate(myVerificationProvider),
          data: (request) {
            final verified = profile.value?.isVerified ?? false;
            if (verified) {
              return _StatusView(
                icon: Icons.verified_rounded,
                title: l10n.verificationApprovedTitle,
                body: l10n.verificationApprovedBody,
              );
            }
            if (request?.status == RequestStatus.pending) {
              return _StatusView(
                icon: Icons.hourglass_top_rounded,
                title: l10n.verificationPendingTitle,
                body: l10n.verificationPendingBody,
              );
            }
            if ((photos.value?.length ?? 2) < 2) {
              return EmptyView(
                icon: Icons.photo_library_outlined,
                title: l10n.verificationNeedsPhotos,
                actionLabel: l10n.verificationAddPhotos,
                onAction: () =>
                    context.push(AppRoutes.editProfileSection('photos')),
              );
            }
            return _SelfieFlow(
              rejectedReason: request?.status == RequestStatus.rejected
                  ? (request?.rejectionReason ?? '')
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const new({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: context.colors.lime),
            SizedBox(height: spacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall,
            ),
            SizedBox(height: spacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfieFlow extends ConsumerStatefulWidget {
  const new({this.rejectedReason});

  /// Set when the last try was rejected (may be empty).
  final String? rejectedReason;

  @override
  ConsumerState<_SelfieFlow> createState() => _SelfieFlowState();
}

class _SelfieFlowState extends ConsumerState<_SelfieFlow> {
  final _random = Random();
  late VerificationPose _pose = _draw();
  bool _consent = false;
  Uint8List? _selfie;

  VerificationPose _draw([VerificationPose? not]) {
    final options = [
      for (final pose in VerificationPose.values)
        if (pose != not) pose,
    ];
    return options[_random.nextInt(options.length)];
  }

  Future<void> _takeSelfie() async {
    final jpeg = await ref.read(photoPickerProvider).selfie();
    if (jpeg != null && mounted) setState(() => _selfie = jpeg);
  }

  Future<void> _send() async {
    final selfie = _selfie;
    if (selfie == null) return;
    final sent = await ref
        .read(verificationControllerProvider.notifier)
        .submit(_pose, selfie);
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.verificationSent)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final state = ref.watch(verificationControllerProvider);
    final selfie = _selfie;
    final reason = widget.rejectedReason;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        if (reason != null) ...[
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.verificationRejectedTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.error,
                  ),
                ),
                if (reason.isNotEmpty)
                  Text(l10n.verificationRejectedReason(reason)),
              ],
            ),
          ),
          SizedBox(height: spacing.md),
        ],
        Text(l10n.verificationIntro, style: context.textTheme.bodyMedium),
        SizedBox(height: spacing.xs),
        Text(l10n.verificationPrivacy, style: context.textTheme.bodySmall),
        SizedBox(height: spacing.lg),
        GlassCard(
          borderGradient: colors.primaryGradient,
          child: Column(
            children: [
              Text(
                l10n.verificationPoseTitle.toUpperCase(),
                style: context.textTheme.labelLarge,
              ),
              SizedBox(height: spacing.sm),
              Text(poseEmoji(_pose), style: const TextStyle(fontSize: 64)),
              SizedBox(height: spacing.sm),
              Text(
                poseLabel(l10n, _pose),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
              ),
              if (selfie == null)
                TextButton.icon(
                  onPressed: () => setState(() => _pose = _draw(_pose)),
                  icon: const Icon(Icons.casino_outlined, size: 18),
                  label: Text(l10n.verificationOtherPose),
                ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        if (selfie != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(context.radii.lg),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.memory(selfie, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: spacing.sm),
        ],
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _consent,
          title: Text(
            l10n.verificationConsent,
            style: context.textTheme.bodySmall,
          ),
          onChanged: (v) => setState(() => _consent = v ?? false),
        ),
        FormErrorText(error: state.error),
        if (selfie == null)
          NeonButton(
            label: l10n.verificationTakeSelfie,
            icon: Icons.photo_camera_front_rounded,
            onPressed: _consent ? _takeSelfie : null,
          )
        else ...[
          NeonButton(
            label: l10n.verificationSend,
            isLoading: state.isLoading,
            onPressed: _consent ? _send : null,
          ),
          TextButton(
            onPressed: state.isLoading ? null : _takeSelfie,
            child: Text(l10n.verificationRetake),
          ),
        ],
      ],
    );
  }
}
