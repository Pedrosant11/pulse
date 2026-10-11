import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/referral/domain/referral_models.dart';
import 'package:pulse/features/referral/presentation/referral_providers.dart';
import 'package:share_plus/share_plus.dart';

/// "Indique e ganhe": the person's code to share and a field for a
/// friend's code (until the first match).
class ReferralScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final referral = ref.watch(myReferralProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.referralTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: referral,
          onRetry: () => ref.invalidate(myReferralProvider),
          data: (info) => ListView(
            padding: EdgeInsets.all(spacing.md),
            children: [
              Text(l10n.referralHeadline, style: context.textTheme.titleLarge),
              SizedBox(height: spacing.xs),
              Text(
                l10n.referralExplainer(
                  info.referrerSuperlikes,
                  info.referrerBoosts,
                  info.referredSuperlikes,
                ),
                style: context.textTheme.bodyMedium,
              ),
              SizedBox(height: spacing.md),
              _CodeCard(info: info),
              SizedBox(height: spacing.md),
              // Same height for both tiles.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _Stat(
                        value: info.invited,
                        label: l10n.referralInvited(info.invited),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: _Stat(
                        value: info.rewarded,
                        label: l10n.referralRewarded(info.rewarded),
                      ),
                    ),
                  ],
                ),
              ),
              if (info.canRedeem) ...[
                SizedBox(height: spacing.lg),
                _RedeemCard(superlikes: info.referredSuperlikes),
              ],
              SizedBox(height: spacing.md),
              Text(l10n.referralFinePrint, style: context.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const new({required this.info});

  final ReferralInfo info;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    return GlassCard(
      borderGradient: colors.blackGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.referralYourCode,
            textAlign: TextAlign.center,
            style: context.textTheme.labelLarge,
          ),
          SizedBox(height: spacing.xs),
          SelectableText(
            info.code,
            textAlign: TextAlign.center,
            style: context.textTheme.displaySmall?.copyWith(
              color: colors.lime,
              letterSpacing: 6,
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: info.code));
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.referralCopied)));
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(l10n.referralCopy),
            ),
          ),
          SizedBox(height: spacing.sm),
          NeonButton(
            label: l10n.referralShare,
            icon: Icons.share_rounded,
            gradient: colors.blackGradient,
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: l10n.referralShareText(
                  info.code,
                  info.referredSuperlikes,
                ),
                subject: l10n.referralTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A number with its caption (count of friends).
class _Stat extends StatelessWidget {
  const new({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$value', style: context.textTheme.headlineMedium),
          Text(label, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _RedeemCard extends ConsumerStatefulWidget {
  const new({required this.superlikes});

  final int superlikes;

  @override
  ConsumerState<_RedeemCard> createState() => _RedeemCardState();
}

class _RedeemCardState extends ConsumerState<_RedeemCard> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _redeem() async {
    final code = _code.text.trim();
    if (code.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final done = await ref
        .read(referralControllerProvider.notifier)
        .redeem(code);
    if (done == true) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.referralRedeemed(widget.superlikes))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(referralControllerProvider);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.referralGotCode, style: context.textTheme.titleMedium),
          SizedBox(height: spacing.xs),
          Text(
            l10n.referralGotCodeHint(widget.superlikes),
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _code,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: l10n.referralCodeLabel,
              counterText: '',
            ),
            onSubmitted: (_) => _redeem(),
          ),
          FormErrorText(error: state.error),
          SizedBox(height: spacing.sm),
          FilledButton(
            onPressed: state.isLoading ? null : _redeem,
            child: Text(l10n.referralRedeem),
          ),
        ],
      ),
    );
  }
}
