import 'package:markdown/markdown.dart' as md;
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';

/// Renders the small Markdown subset used by the legal documents: headings,
/// paragraphs, bold/italic, links, bullet and numbered lists, and tables
/// (shown as one card per row, which reads better on a phone).
class MarkdownView extends StatelessWidget {
  const new({required this.markdown, required this.onLink, super.key});

  final String markdown;

  /// Called with the link target (relative slug or absolute URL).
  final ValueChanged<String> onLink;

  @override
  Widget build(BuildContext context) {
    // No HTML escaping: this goes to Text widgets, not a browser (quotes
    // would show up as &quot;).
    final document = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    );
    final nodes = document.parseLines(markdown.split('\n'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final node in nodes) ?_block(context, node)],
    );
  }

  Widget? _block(BuildContext context, md.Node node) {
    if (node is! md.Element) return null;
    final spacing = context.spacing;
    final text = context.textTheme;

    Widget padded(Widget child, {double top = 0, double bottom = 0}) => Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: child,
    );

    switch (node.tag) {
      case 'h1':
        return padded(
          _rich(context, node, text.headlineSmall),
          bottom: spacing.sm,
        );
      case 'h2':
        return padded(
          Semantics(header: true, child: _rich(context, node, text.titleLarge)),
          top: spacing.lg,
          bottom: spacing.xs,
        );
      case 'h3':
        return padded(
          Semantics(
            header: true,
            child: _rich(context, node, text.titleMedium),
          ),
          top: spacing.md,
          bottom: spacing.xs,
        );
      case 'p':
        return padded(
          _rich(context, node, text.bodyMedium),
          bottom: spacing.sm,
        );
      case 'ul':
      case 'ol':
        final items = node.children?.whereType<md.Element>().toList() ?? [];
        return padded(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.xxs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          node.tag == 'ol' ? '${i + 1}.' : '•',
                          style: text.bodyMedium?.copyWith(
                            color: context.colors.magenta,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _rich(context, items[i], text.bodyMedium),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          bottom: spacing.sm,
        );
      case 'table':
        return padded(_table(context, node), bottom: spacing.sm);
      case 'hr':
        return const Divider();
      default:
        return padded(_rich(context, node, text.bodyMedium));
    }
  }

  /// Table → one card per row: the first cell as title, the others as
  /// "Header: value" lines.
  Widget _table(BuildContext context, md.Element table) {
    final spacing = context.spacing;
    final text = context.textTheme;
    List<md.Element> rowsOf(String section) => [
      for (final part in table.children!.whereType<md.Element>())
        if (part.tag == section)
          ...part.children!.whereType<md.Element>().where((r) => r.tag == 'tr'),
    ];
    List<md.Element> cells(md.Element row) =>
        row.children!.whereType<md.Element>().toList();

    final headers = rowsOf('thead').map(cells).firstOrNull ?? const [];
    final rows = rowsOf('tbody');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.xs),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, cell) in cells(row).indexed)
                    if (i == 0)
                      _rich(context, cell, text.titleSmall)
                    else
                      Padding(
                        padding: EdgeInsets.only(top: spacing.xxs),
                        child: _rich(
                          context,
                          cell,
                          text.bodySmall,
                          label: i < headers.length
                              ? headers[i].textContent
                              : null,
                        ),
                      ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _rich(
    BuildContext context,
    md.Element element,
    TextStyle? style, {
    String? label,
  }) {
    final colors = context.colors;
    final spans = <InlineSpan>[
      if (label != null)
        TextSpan(
          text: '$label: ',
          style: TextStyle(color: colors.textSecondary),
        ),
    ];

    void walk(md.Node node, TextStyle current) {
      if (node is md.Text) {
        spans.add(TextSpan(text: node.text, style: current));
        return;
      }
      if (node is! md.Element) return;
      final children = node.children ?? const <md.Node>[];
      switch (node.tag) {
        case 'strong':
          for (final child in children) {
            walk(child, current.copyWith(fontWeight: FontWeight.w700));
          }
        case 'em':
          for (final child in children) {
            walk(child, current.copyWith(fontStyle: FontStyle.italic));
          }
        case 'a':
          final href = node.attributes['href'] ?? '';
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Semantics(
                link: true,
                child: GestureDetector(
                  onTap: () => onLink(href),
                  child: Text(
                    node.textContent,
                    style: current.copyWith(
                      color: colors.cyan,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.cyan,
                    ),
                  ),
                ),
              ),
            ),
          );
        case 'br':
          spans.add(const TextSpan(text: '\n'));
        default:
          for (final child in children) {
            walk(child, current);
          }
      }
    }

    final base = style ?? const TextStyle();
    for (final child in element.children ?? const <md.Node>[]) {
      walk(child, base);
    }
    return Text.rich(TextSpan(style: base, children: spans));
  }
}
