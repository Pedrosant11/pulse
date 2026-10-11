import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';
import 'package:pulse/features/verification/domain/verification_models.dart';
import 'package:pulse/features/verification/presentation/verification_labels.dart';
import 'package:pulse/features/verification/presentation/verification_providers.dart';

/// Admins compare each selfie (with the requested pose) with the profile
/// photos and approve or reject. The selfie is deleted on decision.
class AdminVerificationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pending = ref.watch(pendingVerificationsProvider);

    ref.listen(verificationControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.adminVerifications.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: pending,
          onRetry: () => ref.invalidate(pendingVerificationsProvider),
          data: (items) => items.isEmpty
              ? EmptyView(
                  icon: Icons.verified_outlined,
                  title: l10n.adminVerificationEmpty,
                )
              : ListView.separated(
                  padding: EdgeInsets.all(context.spacing.md),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(height: context.spacing.md),
                  itemBuilder: (_, index) =>
                      _VerificationCard(item: items[index]),
                ),
        ),
      ),
    );
  }
}

class _VerificationCard extends ConsumerWidget {
  const new({required this.item});

  final PendingVerification item;

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reject),
        content: TextField(
          controller: reason,
          maxLength: 300,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: l10n.adminVerificationRejectHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.reject),
          ),
        ],
      ),
    );
    final text = reason.text;
    reason.dispose();
    if (confirmed != true) return;
    await ref
        .read(verificationControllerProvider.notifier)
        .review(item.id, approve: false, reason: text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final busy = ref.watch(verificationControllerProvider).isLoading;
    final selfiePath = item.selfiePath;
    final radius = BorderRadius.circular(context.radii.md);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.profileNameAge(item.firstName, item.age),
            style: context.textTheme.titleLarge,
          ),
          Text(
            l10n.adminVerificationPose(
              '${poseEmoji(item.pose)} ${poseLabel(l10n, item.pose)}',
            ),
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: spacing.sm),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The selfie, bigger, then the profile photos to compare.
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: radius,
                    child: selfiePath == null
                        ? const SizedBox.shrink()
                        : _Selfie(path: selfiePath),
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  flex: 2,
                  child: ListView.separated(
                    itemCount: item.photoPaths.length,
                    separatorBuilder: (_, _) => SizedBox(height: spacing.xs),
                    itemBuilder: (_, index) => ClipRRect(
                      borderRadius: radius,
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: ProfilePhotoImage(
                          item.photoPaths[index],
                          decodeWidth: 160,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: busy ? null : () => _reject(context, ref),
                child: Text(l10n.reject),
              ),
              SizedBox(width: spacing.sm),
              FilledButton(
                onPressed: busy
                    ? null
                    : () => ref
                          .read(verificationControllerProvider.notifier)
                          .review(item.id, approve: true),
                child: Text(l10n.approve),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Selfie extends ConsumerWidget {
  const new({required this.path});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(verificationSelfieUrlProvider(path));
    return url.when(
      loading: () => const ShimmerBox(height: double.infinity, radius: 0),
      error: (_, _) => Icon(
        Icons.broken_image_outlined,
        color: context.colors.textSecondary,
      ),
      data: (url) => Image.network(url, fit: BoxFit.cover),
    );
  }
}
