import 'package:markdown/markdown.dart' as md;

/// Builds the public site (GitHub Pages) from the same Markdown the app
/// bundles (`assets/legal/`). Pure function so a test can check that `site/`
/// is up to date. Styles, scripts, fonts and three.js are copied as they are
/// by `tool/build_site.dart` (from `tool/site_template/` and `assets/`).
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
      title: 'Pulse — match nas mesmas festas',
      depth: 0,
      hero: true,
      slugs: sources.keys,
      titles: titles,
      body: _home(sources.keys, titles),
    ),
    for (final MapEntry(key: slug, value: text) in sources.entries)
      '$slug/index.html': _page(
        title: '${titles[slug]!} · Pulse',
        depth: 1,
        hero: false,
        slugs: sources.keys,
        titles: titles,
        body: [
          '<header class="doc-hero">',
          '<span class="eyebrow">Pulse · Documento</span>',
          '<h1>${_escape(titles[slug]!)}</h1>',
          '</header>',
          '<article class="doc">',
          _render(text, sources.keys.toSet()),
          '</article>',
        ].join('\n'),
      ),
    // The admin console (site/admin) stays out of search engines.
    'robots.txt': 'User-agent: *\nDisallow: /admin/\n',
    // GitHub Pages: serve files as they are (no Jekyll).
    '.nojekyll': '',
  };
}

/// One line about each document, for the home cards.
const _blurbs = {
  'termos-de-uso': 'As regras para usar o Pulse, os planos e as compras.',
  'politica-de-privacidade':
      'Quais dados tratamos, por quê e como você controla tudo.',
  'diretrizes-da-comunidade': 'O combinado para a pista ficar segura e boa.',
  'excluir-conta': 'Como apagar sua conta e seus dados, no app ou por aqui.',
};

/// Simple line icons (24px), one per document.
const _icons = <String, List<String>>{
  'termos-de-uso': [
    '<path d="M7 3h7l5 5v13H7z"/>',
    '<path d="M14 3v5h5M10 13h6M10 17h6"/>',
  ],
  'politica-de-privacidade': [
    '<path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6z"/>',
    '<path d="M9.5 12l2 2 3.5-4"/>',
  ],
  'diretrizes-da-comunidade': [
    '<circle cx="9" cy="9" r="3"/>',
    '<circle cx="17" cy="10" r="2.5"/>',
    '<path d="M3.5 19c.8-3 3-4.5 5.5-4.5s4.7 1.5 5.5 4.5"/>',
    '<path d="M15 15.2c2.6-.4 4.6.9 5.5 3.8"/>',
  ],
  'excluir-conta': [
    '<path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>',
  ],
};

/// App screenshots for "Como funciona", in order:
/// `tool/site_template/screens/<name>.jpg` → `site/assets/screens/`.
const List<({String name, String title, String text})> siteScreens = [
  (
    name: 'eventos',
    title: 'Ache as festas',
    text: 'Techno, house, psy, DnB: filtre por estilo, data e distância.',
  ),
  (
    name: 'evento',
    title: 'Marque "Eu vou"',
    text: 'Confirme presença, compre o ingresso e use o cupom do promoter.',
  ),
  (
    name: 'evento-crews',
    title: 'Veja quem vai',
    text: 'Quantas pessoas vão e as crews já montadas para a festa.',
  ),
  (
    name: 'crew',
    title: 'Ache sua galera',
    text:
        'No Crew, aparece só quem vai ao mesmo evento. Ninguém precisa ir '
        'sozinho.',
  ),
  (
    name: 'criar-crew',
    title: 'Monte a crew',
    text: 'Crie o grupo da festa, aberto ou só por convite.',
  ),
  (
    name: 'crew-grupo',
    title: 'Combine o encontro',
    text: 'Ponto de encontro, membros e convites no mesmo lugar.',
  ),
  (
    name: 'crew-chat',
    title: 'Chat do grupo',
    text: 'Fotos e áudios para combinar o esquenta e não se perder na pista.',
  ),
  (
    name: 'date',
    title: 'E ainda tem o Date',
    text:
        'Quem está perto de você, e quem vai às mesmas festas aparece '
        'primeiro.',
  ),
];

String _screens() => [
  '<section class="section" id="como-funciona">',
  '<span class="eyebrow">Como funciona</span>',
  '<h2>Ache a festa, monte a crew</h2>',
  '<ol class="screens">',
  for (final (i, s) in siteScreens.indexed)
    [
      '<li class="screen reveal">',
      '<div class="phone"><img src="assets/screens/${s.name}.jpg"',
      'alt="Tela do app: ${_escape(s.title)}" loading="lazy"',
      'width="532" height="1156"></div>',
      '<span class="step">${i + 1}</span>',
      '<h3>${_escape(s.title)}</h3>',
      '<p>${_escape(s.text)}</p>',
      '</li>',
    ].join('\n'),
  '</ol>',
  '<p class="note">Imagens ilustrativas: pessoas geradas por IA;',
  'perfis, crews e conversas fictícios.</p>',
  '</section>',
].join('\n');

String _home(Iterable<String> slugs, Map<String, String> titles) => [
  '<section class="hero">',
  '<div>',
  '<h1 class="glitch" data-text="PULSE">PULSE</h1>',
  '<p class="tagline">Date e Crew para quem vive a pista.',
  '<em>Ache sua galera nas mesmas festas.</em></p>',
  '<div class="pills">',
  '<a class="pill primary" href="#como-funciona">Como funciona</a>',
  '<span class="pill">Em breve no Google Play e na App Store</span>',
  '</div>',
  '</div>',
  '<span class="scroll-hint" aria-hidden="true">',
  '<svg width="28" height="28" viewBox="0 0 24 24" fill="none"',
  'stroke="currentColor" stroke-width="2" stroke-linecap="round"',
  'stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg></span>',
  '</section>',
  _screens(),
  '<section class="section" id="documentos">',
  '<span class="eyebrow">Transparência</span>',
  '<h2>Documentos legais e de privacidade</h2>',
  '<div class="cards">',
  for (final slug in slugs)
    [
      '<a class="card reveal" href="$slug/">',
      '<span class="icon">',
      '<svg width="24" height="24" viewBox="0 0 24 24" fill="none"',
      'stroke="currentColor" stroke-width="1.8" stroke-linecap="round"',
      'stroke-linejoin="round" aria-hidden="true">',
      ...?_icons[slug],
      '</svg></span>',
      '<h3>${_escape(titles[slug]!)}</h3>',
      if (_blurbs[slug] case final blurb?) '<p>$blurb</p>',
      '<span class="go">Ler →</span>',
      '</a>',
    ].join('\n'),
  '</div>',
  '</section>',
].join('\n');

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
  return html
      .replaceAllMapped(
        RegExp('href="([a-z0-9-]+)"'),
        (m) => slugs.contains(m[1]) ? 'href="../${m[1]}/"' : m[0]!,
      )
      .replaceAll('<table>', '<div class="table-wrap"><table>')
      .replaceAll('</table>', '</table></div>');
}

String _escape(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

String _page({
  required String title,
  required int depth,
  required bool hero,
  required Iterable<String> slugs,
  required Map<String, String> titles,
  required String body,
}) {
  final root = depth == 0 ? './' : '../';
  final assets = '${root}assets';
  return '''
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${_escape(title)}</title>
<meta name="description" content="Pulse: date e crew para quem vive a música eletrônica. Ache sua galera nas mesmas festas.">
<meta name="theme-color" content="#0A0A0F">
<link rel="icon" href="$assets/icon.png">
<link rel="preload" href="$assets/fonts/Unbounded-ExtraBold.ttf" as="font" type="font/ttf" crossorigin>
<link rel="stylesheet" href="$assets/site.css">
<script>document.documentElement.classList.add('js')</script>
</head>
<body>
<canvas class="scene" data-mode="${hero ? 'hero' : 'banner'}" aria-hidden="true"></canvas>
<header class="bar">
<a class="brand" href="$root"><img src="$assets/icon.png" alt=""><span>PULSE</span></a>
<nav><a class="wide-only" href="$root#como-funciona">Como funciona</a><a href="$root#documentos">Documentos</a></nav>
</header>
<main>
$body
</main>
<footer>
<nav>
${[for (final slug in slugs) '<a href="$root$slug/">${_escape(titles[slug]!)}</a>'].join('\n')}
</nav>
Pulse · Esta página não usa cookies.
</footer>
<script type="module" src="$assets/scene.js"></script>
<script src="$assets/site.js" defer></script>
</body>
</html>
''';
}
