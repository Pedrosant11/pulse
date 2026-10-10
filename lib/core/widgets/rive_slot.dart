import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:rive/rive.dart' as rive;

/// Rive files (SPEC 12). They are optional: until a file is added to
/// `assets/rive/`, [RiveSlot] shows its Flutter fallback. See
/// `docs/RIVE.md` for names and what each animation should do.
abstract final class RiveAssets {
  /// Celebration on the match screen, over the light burst.
  static const match = 'assets/rive/match.riv';

  /// Icon of the "Eu vou" button once the user is going.
  static const attend = 'assets/rive/attend.riv';
}

/// Plays a Rive file (default artboard and state machine) when it is
/// bundled; otherwise, while loading, on errors and with reduced motion it
/// shows [fallback].
class RiveSlot extends StatefulWidget {
  const new({
    required this.asset,
    required this.fallback,
    this.fit = rive.Fit.contain,
    super.key,
  });

  final String asset;
  final Widget fallback;
  final rive.Fit fit;

  @override
  State<RiveSlot> createState() => _RiveSlotState();
}

class _RiveSlotState extends State<RiveSlot> {
  static Future<List<String>>? _bundledAssets;

  rive.FileLoader? _loader;

  @override
  void initState() {
    super.initState();
    unawaited(_prepare());
  }

  Future<void> _prepare() async {
    try {
      _bundledAssets ??= AssetManifest.loadFromAssetBundle(rootBundle)
          .then((manifest) => manifest.listAssets());
      final bundled = await _bundledAssets!;
      if (!bundled.contains(widget.asset)) return;
      if (!await rive.RiveNative.init() || !mounted) return;
      setState(() {
        _loader = rive.FileLoader.fromAsset(
          widget.asset,
          riveFactory: rive.Factory.rive,
        );
      });
    } on Object catch (error) {
      debugPrint('Rive ${widget.asset} unavailable: $error');
    }
  }

  @override
  void dispose() {
    _loader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loader = _loader;
    if (loader == null || context.reduceMotion) return widget.fallback;
    return rive.RiveWidgetBuilder(
      fileLoader: loader,
      builder: (context, state) => switch (state) {
        rive.RiveLoaded(:final controller) => rive.RiveWidget(
          controller: controller,
          fit: widget.fit,
        ),
        _ => widget.fallback,
      },
    );
  }
}
