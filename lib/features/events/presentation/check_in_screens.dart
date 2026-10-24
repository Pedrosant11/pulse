import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/domain/check_in.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Reads the producer's check-in QR (or takes the code typed by hand) and
/// pops with the code. The server checks it (`check_in_qr`).
class CheckInScanScreen extends StatefulWidget {
  const new({required this.eventId, super.key});

  final String eventId;

  @override
  State<CheckInScanScreen> createState() => _CheckInScanScreenState();
}

class _CheckInScanScreenState extends State<CheckInScanScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  final _code = TextEditingController();
  var _done = false;
  String? _wrong;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    _code.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null) continue;
      final code = parseCheckInQr(raw, widget.eventId);
      if (code != null) {
        _finish(code);
        return;
      }
      if (_wrong != raw) setState(() => _wrong = raw);
    }
  }

  void _submitTyped() {
    final code = parseCheckInQr(_code.text, widget.eventId);
    if (code == null) {
      setState(() => _wrong = _code.text);
      return;
    }
    _finish(code);
  }

  void _finish(String code) {
    _done = true;
    context.pop(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.checkInScanTitle.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            Text(l10n.checkInScanHint, style: context.textTheme.bodyMedium),
            SizedBox(height: spacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(context.radii.lg),
              child: AspectRatio(
                aspectRatio: 1,
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
              ),
            ),
            if (_wrong != null) ...[
              SizedBox(height: spacing.sm),
              Text(
                l10n.checkInScanWrong,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.error,
                ),
              ),
            ],
            SizedBox(height: spacing.lg),
            TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              maxLength: 8,
              decoration: InputDecoration(labelText: l10n.checkInCodeLabel),
              onSubmitted: (_) => _submitTyped(),
            ),
            SizedBox(height: spacing.sm),
            FilledButton(
              onPressed: _submitTyped,
              child: Text(l10n.checkInCodeSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

/// For who runs the party: the check-in QR to show at the door. The code
/// changes every minute, so a screenshot shared in a group doesn't work.
class CheckInQrScreen extends ConsumerStatefulWidget {
  const new({required this.eventId, super.key});

  final String eventId;

  @override
  ConsumerState<CheckInQrScreen> createState() => _CheckInQrScreenState();
}

class _CheckInQrScreenState extends ConsumerState<CheckInQrScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Fetches the next code right when this one expires.
  void _schedule(CheckInCode code) {
    _timer?.cancel();
    final wait = code.expiresAt.difference(DateTime.now());
    _timer = Timer(
      wait.isNegative ? const Duration(seconds: 1) : wait,
      () => ref.invalidate(checkInCodeProvider(widget.eventId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final code = ref.watch(checkInCodeProvider(widget.eventId));
    final event = ref.watch(eventDetailProvider(widget.eventId)).value;
    ref.listen(checkInCodeProvider(widget.eventId), (_, next) {
      if (next case AsyncData(:final value)) _schedule(value);
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.checkInQrTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: code,
          onRetry: () => ref.invalidate(checkInCodeProvider(widget.eventId)),
          data: (data) {
            if (_timer == null) _schedule(data);
            return ListView(
              padding: EdgeInsets.all(spacing.md),
              children: [
                if (event != null)
                  Text(
                    event.name,
                    style: context.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: spacing.md),
                if (!data.open)
                  GlassCard(
                    child: Text(
                      l10n.checkInQrClosed,
                      style: context.textTheme.bodyMedium,
                    ),
                  )
                else ...[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(spacing.md),
                      decoration: BoxDecoration(
                        color: colors.textPrimary,
                        borderRadius: BorderRadius.circular(context.radii.lg),
                      ),
                      child: QrImageView(
                        data: checkInQrPayload(widget.eventId, data.code),
                        size: 260,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: colors.background,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: colors.background,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  SelectableText(
                    data.code,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                      letterSpacing: 6,
                      color: colors.lime,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    l10n.checkInQrHint,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmall,
                  ),
                ],
                SizedBox(height: spacing.lg),
                Text(
                  l10n.checkInQrCount(data.checkedIn),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleSmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
