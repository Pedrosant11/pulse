import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:record/record.dart';

/// Longest voice message (also checked by the database).
const maxVoiceDuration = Duration(minutes: 2);

String formatClock(Duration d) =>
    '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

/// A photo in a bubble: the uploaded file (by [path]) or the local bytes
/// while it is being sent. Tapping opens it full screen.
class ChatImage extends ConsumerWidget {
  const new({this.path, this.bytes, super.key});

  final String? path;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radius = BorderRadius.circular(context.radii.md);
    final url = switch (path) {
      final path? when bytes == null =>
        ref.watch(chatMediaUrlProvider(path)).value,
      _ => null,
    };
    Widget image(BoxFit fit) {
      if (bytes case final bytes?) return Image.memory(bytes, fit: fit);
      if (url == null) return ColoredBox(color: context.colors.surface);
      return CachedNetworkImage(
        imageUrl: url,
        cacheKey: path,
        fit: fit,
        errorWidget: (_, _, _) => Icon(
          Icons.broken_image_outlined,
          color: context.colors.textSecondary,
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => _PhotoViewer(child: image(BoxFit.contain)),
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(width: 220, height: 260, child: image(BoxFit.cover)),
      ),
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  const new({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(backgroundColor: Colors.black),
    body: Center(
      child: InteractiveViewer(
        maxScale: 4,
        child: SizedBox.expand(child: child),
      ),
    ),
  );
}

/// A voice message: play/pause, progress and length.
class VoicePlayer extends ConsumerStatefulWidget {
  const new({
    required this.duration,
    required this.color,
    this.path,
    super.key,
  });

  /// Null while it is still being sent.
  final String? path;
  final Duration duration;
  final Color color;

  @override
  ConsumerState<VoicePlayer> createState() => _VoicePlayerState();
}

class _VoicePlayerState extends ConsumerState<VoicePlayer> {
  AudioPlayer? _player;
  StreamSubscription<Object?>? _subscription;
  Duration _position = Duration.zero;
  bool _playing = false;
  bool _loading = false;

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_player?.dispose());
    super.dispose();
  }

  Future<void> _toggle() async {
    final path = widget.path;
    if (path == null) return;
    var player = _player;
    if (player == null) {
      setState(() => _loading = true);
      try {
        final url = await ref.read(chatMediaUrlProvider(path).future);
        player = AudioPlayer();
        await player.setUrl(url);
      } on Object {
        if (mounted) setState(() => _loading = false);
        return;
      }
      if (!mounted) {
        unawaited(player.dispose());
        return;
      }
      _player = player;
      _subscription = player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      player.playerStateStream.listen((state) {
        if (!mounted) return;
        if (state.processingState == ProcessingState.completed) {
          unawaited(player!.pause());
          unawaited(player.seek(Duration.zero));
        }
        setState(
          () => _playing =
              state.playing &&
              state.processingState != ProcessingState.completed,
        );
      });
      setState(() => _loading = false);
    }
    _playing ? await player.pause() : await player.play();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = widget.duration;
    final progress = total.inMilliseconds == 0
        ? 0.0
        : (_position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    return SizedBox(
      width: 220,
      child: Row(
        children: [
          IconButton(
            tooltip: _playing ? l10n.chatVoicePause : l10n.chatVoicePlay,
            onPressed: widget.path == null || _loading ? null : _toggle,
            icon: _loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: widget.color,
                  ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              color: widget.color,
              backgroundColor: widget.color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: context.spacing.sm),
          Text(
            formatClock(
              _playing || _position > Duration.zero ? _position : total,
            ),
            style: context.textTheme.labelSmall?.copyWith(color: widget.color),
          ),
        ],
      ),
    );
  }
}

/// Recording bar that replaces the text field: timer, cancel and send.
/// Stops by itself at [maxVoiceDuration].
class VoiceRecorderBar extends StatefulWidget {
  const new({required this.onDone, required this.onCancel, super.key});

  final void Function(Uint8List bytes, Duration duration) onDone;
  final VoidCallback onCancel;

  @override
  State<VoiceRecorderBar> createState() => _VoiceRecorderBarState();
}

class _VoiceRecorderBarState extends State<VoiceRecorderBar> {
  final _recorder = AudioRecorder();
  final _watch = Stopwatch();
  Timer? _ticker;
  String? _file;
  bool _stopping = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    if (!await _recorder.hasPermission()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.chatVoiceNoPermission)),
      );
      widget.onCancel();
      return;
    }
    final dir = await getTemporaryDirectory();
    final file =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(bitRate: 64000, numChannels: 1),
      path: file,
    );
    _file = file;
    _watch.start();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      if (_watch.elapsed >= maxVoiceDuration) unawaited(_finish());
      setState(() {});
    });
  }

  Future<void> _finish() async {
    if (_stopping) return;
    _stopping = true;
    _ticker?.cancel();
    _watch.stop();
    final path = await _recorder.stop() ?? _file;
    final elapsed = _watch.elapsed;
    if (path == null || elapsed < const Duration(milliseconds: 500)) {
      widget.onCancel();
      return;
    }
    final bytes = await File(path).readAsBytes();
    unawaited(File(path).delete().catchError((_) => File(path)));
    widget.onDone(
      bytes,
      elapsed > maxVoiceDuration ? maxVoiceDuration : elapsed,
    );
  }

  Future<void> _cancel() async {
    _stopping = true;
    _ticker?.cancel();
    await _recorder.cancel();
    widget.onCancel();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    unawaited(_recorder.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Row(
      children: [
        IconButton(
          tooltip: l10n.chatVoiceCancel,
          onPressed: _cancel,
          icon: Icon(Icons.delete_outline_rounded, color: colors.error),
        ),
        Icon(Icons.fiber_manual_record_rounded, color: colors.error, size: 14),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(
            l10n.chatVoiceRecording(formatClock(_watch.elapsed)),
            style: context.textTheme.bodyMedium,
          ),
        ),
        IconButton.filled(
          tooltip: l10n.chatSend,
          style: IconButton.styleFrom(backgroundColor: colors.magenta),
          onPressed: _finish,
          icon: Icon(Icons.send_rounded, color: colors.background),
        ),
      ],
    );
  }
}

/// Camera or gallery, then a preview with an optional caption. Returns the
/// photo and caption, or null when cancelled.
Future<(Uint8List, String)?> pickChatPhoto(
  BuildContext context,
  PhotoPicker picker,
) async {
  final l10n = context.l10n;
  final source = await showModalBottomSheet<PhotoSource>(
    context: context,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined),
          title: Text(l10n.chatPhotoCamera),
          onTap: () => Navigator.pop(context, PhotoSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: Text(l10n.chatPhotoGallery),
          onTap: () => Navigator.pop(context, PhotoSource.gallery),
        ),
      ],
    ),
  );
  if (source == null) return null;
  final bytes = await picker.chatPhoto(source);
  if (bytes == null || !context.mounted) return null;
  return await Navigator.of(
    context,
    rootNavigator: true,
  ).push<(Uint8List, String)>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _PhotoPreview(bytes: bytes),
    ),
  );
}

class _PhotoPreview extends StatefulWidget {
  const new({required this.bytes});

  final Uint8List bytes;

  @override
  State<_PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<_PhotoPreview> {
  final _caption = TextEditingController();

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Center(child: Image.memory(widget.bytes))),
            Padding(
              padding: EdgeInsets.all(context.spacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _caption,
                      maxLength: 2000,
                      minLines: 1,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: l10n.chatPhotoCaption,
                        counterText: '',
                      ),
                    ),
                  ),
                  SizedBox(width: context.spacing.xs),
                  IconButton.filled(
                    tooltip: l10n.chatSend,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.magenta,
                    ),
                    onPressed: () =>
                        Navigator.pop(context, (widget.bytes, _caption.text)),
                    icon: Icon(Icons.send_rounded, color: colors.background),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
