import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Text followed by a small icon (verified, official) that sits right after
/// the last word, on the same line, even when the text wraps.
class TextWithBadge extends StatelessWidget {
  const new(
    this.text, {
    required this.style,
    this.badge,
    this.maxLines,
    super.key,
  });

  final String text;
  final TextStyle? style;

  /// Shown after the text; null shows only the text.
  final Widget? badge;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: text,
      children: [
        if (badge case final badge?)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: context.spacing.xs),
              child: badge,
            ),
          ),
      ],
    ),
    style: style,
    maxLines: maxLines,
    overflow: maxLines == null ? null : TextOverflow.ellipsis,
  );
}
