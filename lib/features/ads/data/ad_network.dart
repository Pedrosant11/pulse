import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ad_network.g.dart';

/// Google ads (AdMob) that fill the ad slots when there's no own ad.
abstract interface class AdNetwork {
  bool get isAvailable;

  /// A loaded native ad, or null when none came (no fill, offline...).
  Future<NativeAd?> loadNative(NativeTemplateStyle style);
}

/// No ad unit id (local dev, tests, before the AdMob account exists).
class UnavailableAdNetwork implements AdNetwork {
  const new();

  @override
  bool get isAvailable => false;

  @override
  Future<NativeAd?> loadNative(NativeTemplateStyle style) async => null;
}

class GoogleAdNetwork implements AdNetwork {
  const new(this.unitId);

  /// Google's test native units, used when the id is "test".
  static const Map<TargetPlatform, String> _testUnits = {
    TargetPlatform.android: 'ca-app-pub-3940256099942544/2247696110',
    TargetPlatform.iOS: 'ca-app-pub-3940256099942544/3986624511',
  };

  final String unitId;

  /// Asks for consent where the law requires it (Google's consent form),
  /// then starts the SDK. Returns the network, or null when ads can't run.
  static Future<GoogleAdNetwork?> start(String unitId) async {
    final consent = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      consent.complete,
      (_) => consent.complete(),
    );
    await consent.future;
    final form = Completer<void>();
    unawaited(
      ConsentForm.loadAndShowConsentFormIfRequired((_) => form.complete()),
    );
    await form.future;
    if (!await ConsentInformation.instance.canRequestAds()) return null;
    await MobileAds.instance.initialize();
    final unit = unitId == 'test' ? _testUnits[defaultTargetPlatform] : unitId;
    return unit == null ? null : GoogleAdNetwork(unit);
  }

  @override
  bool get isAvailable => true;

  @override
  Future<NativeAd?> loadNative(NativeTemplateStyle style) {
    final loaded = Completer<NativeAd?>();
    unawaited(
      NativeAd(
        adUnitId: unitId,
        request: const AdRequest(),
        nativeTemplateStyle: style,
        listener: NativeAdListener(
          onAdLoaded: (ad) => loaded.complete(ad as NativeAd),
          onAdFailedToLoad: (ad, _) {
            unawaited(ad.dispose());
            loaded.complete(null);
          },
        ),
      ).load(),
    );
    return loaded.future;
  }
}

/// Unavailable by default; `main.dart` swaps in AdMob when a unit id is set.
@Riverpod(keepAlive: true)
AdNetwork adNetwork(Ref ref) => const UnavailableAdNetwork();
