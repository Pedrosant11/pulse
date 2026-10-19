import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/ads/data/ad_network.dart';
import 'package:pulse/features/ads/data/ads_repository.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:url_launcher/url_launcher.dart';

/// One ad slot: an own ad when there is one (taking turns by [index]),
/// else a Google native ad, else nothing. [expand] fills the space given
/// (Discover card) instead of sizing itself (event list).
class SponsoredSlot extends ConsumerWidget {
  const new({
    required this.placement,
    required this.index,
    this.expand = false,
    this.onUnavailable,
    super.key,
  });

  final AdPlacement placement;
  final int index;
  final bool expand;

  /// Called when nothing could be shown (no own ad and no Google fill).
  final VoidCallback? onUnavailable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(adsConfigProvider).value;
    if (config == null || !config.enabled) return const SizedBox.shrink();
    final own = config.adsFor(placement);
    if (own.isNotEmpty) {
      final ad = own[index % own.length];
      return HouseAdView(key: ValueKey(ad.id), ad: ad, expand: expand);
    }
    final network = ref.watch(adNetworkProvider);
    if (network.isAvailable) {
      return _NativeAdView(
        network: network,
        expand: expand,
        onUnavailable: onUnavailable,
      );
    }
    return const SizedBox.shrink();
  }
}

/// "Patrocinado" tag on every ad.
class SponsoredTag extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(context.radii.pill),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xxs,
        ),
        child: Text(
          context.l10n.adSponsored,
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// An own ad (party or partner). Counts a view when shown and a tap.
class HouseAdView extends ConsumerStatefulWidget {
  const new({required this.ad, this.expand = false, super.key});

  final HouseAd ad;
  final bool expand;

  @override
  ConsumerState<HouseAdView> createState() => _HouseAdViewState();
}

class _HouseAdViewState extends ConsumerState<HouseAdView> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(adsRepositoryProvider).log(widget.ad.id, click: false));
  }

  Future<void> _open() async {
    final ad = widget.ad;
    unawaited(ref.read(adsRepositoryProvider).log(ad.id, click: true));
    if (ad.eventId case final eventId?) {
      await context.push(AppRoutes.eventDetail(eventId));
    } else if (ad.linkUrl case final url?) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ad = widget.ad;
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radii.lg;
    final imageUrl = switch (ad.imagePath) {
      final path? => ref.watch(adsRepositoryProvider).imageUrl(path),
      null => null,
    };

    final image = imageUrl == null
        ? DecoratedBox(
            decoration: BoxDecoration(gradient: colors.blackGradient),
            child: Center(
              child: Icon(
                Icons.campaign_rounded,
                size: 48,
                color: colors.textPrimary,
              ),
            ),
          )
        : CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover);

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(ad.title, style: context.textTheme.titleLarge),
        if (ad.body case final body?) ...[
          SizedBox(height: spacing.xxs),
          Text(body, style: context.textTheme.bodyMedium),
        ],
        SizedBox(height: spacing.sm),
        FilledButton(onPressed: _open, child: Text(ad.cta ?? l10n.adLearnMore)),
      ],
    );

    if (widget.expand) {
      return GestureDetector(
        onTap: _open,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.background.withValues(alpha: 0),
                    colors.background.withValues(alpha: 0.9),
                  ],
                  stops: const [0.45, 1],
                ),
              ),
            ),
            Positioned(
              top: spacing.md,
              left: spacing.md,
              child: const SponsoredTag(),
            ),
            Positioned(
              left: spacing.md,
              right: spacing.md,
              bottom: spacing.md,
              child: texts,
            ),
          ],
        ),
      );
    }

    // Same surface as the event cards around it (a blurred glass card
    // misrenders inside the scrolling list).
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _open,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  image,
                  Positioned(
                    top: spacing.sm,
                    left: spacing.sm,
                    child: const SponsoredTag(),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(spacing.md), child: texts),
          ],
        ),
      ),
    );
  }
}

/// A Google native ad in the app's colors.
class _NativeAdView extends StatefulWidget {
  const new({required this.network, required this.expand, this.onUnavailable});

  final AdNetwork network;
  final bool expand;
  final VoidCallback? onUnavailable;

  @override
  State<_NativeAdView> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<_NativeAdView> {
  NativeAd? _ad;
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested) return;
    _requested = true;
    final colors = context.colors;
    final style = NativeTemplateStyle(
      templateType: TemplateType.medium,
      mainBackgroundColor: colors.surface,
      cornerRadius: context.radii.lg,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: colors.background,
        backgroundColor: colors.magenta,
      ),
      primaryTextStyle: NativeTemplateTextStyle(textColor: colors.textPrimary),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: colors.textSecondary,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: colors.textSecondary,
      ),
    );
    unawaited(
      widget.network.loadNative(style).then((ad) {
        if (!mounted) {
          unawaited(ad?.dispose());
          return;
        }
        if (ad == null) {
          widget.onUnavailable?.call();
          return;
        }
        setState(() => _ad = ad);
      }),
    );
  }

  @override
  void dispose() {
    unawaited(_ad?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null) return const SizedBox.shrink();
    final view = AdWidget(ad: ad);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        const SponsoredTag(),
        SizedBox(height: context.spacing.xs),
        if (widget.expand)
          Expanded(
            child: Center(child: SizedBox(height: 360, child: view)),
          )
        else
          SizedBox(height: 340, child: view),
      ],
    );
    // Inside the Discover card, keep off its rounded border.
    return widget.expand
        ? Padding(padding: EdgeInsets.all(context.spacing.md), child: content)
        : content;
  }
}
