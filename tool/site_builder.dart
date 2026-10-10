import 'package:markdown/markdown.dart' as md;

/// Builds the public legal site (GitHub Pages) from the same Markdown the
/// app bundles (`assets/legal/`). Pure function so a test can check that
/// `site/` is up to date.
///
/// [sources] maps a slug ("termos-de-uso") to its Markdown. Returns the
/// files to write under `site/`, keyed by relative path.
Map<String, String> buildSite(Map<String, String> sources) {
  final titles = {
    for (final MapEntry(key: slug, value: text) in sources.entries)
      slug: _title(text),
  };
  return {
    'index.html': _page(
      title: 'Pulse',
      depth: 0,
      body: [
        '<h1>Pulse</h1>',
        '<p>Documentos legais e de privacidade do app Pulse.</p>',
        '<ul class="docs">',
        for (final slug in sources.keys)
          '<li><a href="$slug/">${_escape(titles[slug]!)}</a></li>',
        '</ul>',
      ].join('\n'),
    ),
    for (final MapEntry(key: slug, value: text) in sources.entries)
      '$slug/index.html': _page(
        title: titles[slug]!,
        depth: 1,
        body: _render(text, sources.keys.toSet()),
      ),
    // GitHub Pages: serve files as they are (no Jekyll).
    '.nojekyll': '',
  };
}

String _title(String markdown) {
  final line = markdown
      .split('\n')
      .firstWhere((l) => l.startsWith('# '), orElse: () => '# Pulse');
  return line.substring(2).trim();
}

/// Markdown → HTML; links to other documents ("politica-de-privacidade")
/// become "../politica-de-privacidade/".
String _render(String markdown, Set<String> slugs) {
  final html = md.markdownToHtml(
    markdown,
    extensionSet: md.ExtensionSet.gitHubFlavored,
  );
  return html.replaceAllMapped(
    RegExp('href="([a-z0-9-]+)"'),
    (m) => slugs.contains(m[1]) ? 'href="../${m[1]}/"' : m[0]!,
  );
}

String _escape(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

String _page({
  required String title,
  required int depth,
  required String body,
}) {
  final home = depth == 0 ? './' : '../';
  return '''
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${_escape(title)}</title>
<style>
:root {
  --bg: #0A0A0F; --surface: #14141C; --text: #F5F5F7; --muted: #9A9AB0;
  --magenta: #FF2BD6; --cyan: #00E5FF; --violet: #7B2CFF; --border: #2A2A38;
}
* { box-sizing: border-box; }
body {
  margin: 0; background: var(--bg); color: var(--text);
  font: 16px/1.6 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
}
header {
  padding: 16px; border-bottom: 1px solid var(--border);
  background: linear-gradient(90deg, rgba(123,44,255,.25), rgba(255,43,214,.15));
}
header a { color: var(--text); font-weight: 800; letter-spacing: .08em; text-decoration: none; }
main { max-width: 760px; margin: 0 auto; padding: 24px 16px 64px; }
h1 { font-size: 1.8rem; line-height: 1.25; }
h2 { margin-top: 2rem; font-size: 1.3rem; color: var(--text); }
h3 { margin-top: 1.5rem; font-size: 1.1rem; }
p, li { color: var(--text); }
strong { color: #fff; }
a { color: var(--cyan); }
ul.docs { list-style: none; padding: 0; }
ul.docs li { margin: 8px 0; padding: 14px 16px; background: var(--surface);
  border: 1px solid var(--border); border-radius: 12px; }
table { width: 100%; border-collapse: collapse; margin: 12px 0; font-size: .95rem; }
th, td { text-align: left; vertical-align: top; padding: 10px;
  border-bottom: 1px solid var(--border); }
th { color: var(--muted); font-weight: 600; }
.table-wrap { overflow-x: auto; }
footer { color: var(--muted); font-size: .85rem; text-align: center; padding: 24px 16px; }
</style>
</head>
<body>
<header><a href="$home">PULSE</a></header>
<main>
${body.replaceAll('<table>', '<div class="table-wrap"><table>').replaceAll('</table>', '</table></div>')}
</main>
<footer>Pulse · Esta página não usa cookies.</footer>
</body>
</html>
''';
}
