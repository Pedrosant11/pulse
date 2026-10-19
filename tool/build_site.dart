// Regenerates the public site in `site/` from `assets/legal/*.md`, the
// templates in `tool/site_template/` (styles, scripts, three.js) and the
// app's fonts and icon.
//
//   dart run tool/build_site.dart
//
// Run it after editing any legal document or template (a test fails while
// `site/` is out of date). GitHub Pages publishes `site/`
// (.github/workflows/pages.yml).
import 'dart:io';

import 'site_builder.dart';

/// Order of the documents on the index page.
const slugs = [
  'termos-de-uso',
  'politica-de-privacidade',
  'diretrizes-da-comunidade',
  'excluir-conta',
];

/// Copied as they are, `source` → `site/assets/target`.
const staticFiles = {
  'tool/site_template/site.css': 'site.css',
  'tool/site_template/site.js': 'site.js',
  'tool/site_template/scene.js': 'scene.js',
  'tool/site_template/vendor/three.module.min.js': 'vendor/three.module.min.js',
  'tool/site_template/vendor/THREE-LICENSE.txt': 'vendor/THREE-LICENSE.txt',
  'assets/brand/icon.png': 'icon.png',
  // Same fonts as the app (SIL Open Font License).
  'assets/fonts/Unbounded-Bold.ttf': 'fonts/Unbounded-Bold.ttf',
  'assets/fonts/Unbounded-ExtraBold.ttf': 'fonts/Unbounded-ExtraBold.ttf',
  'assets/fonts/Inter-Regular.ttf': 'fonts/Inter-Regular.ttf',
  'assets/fonts/Inter-SemiBold.ttf': 'fonts/Inter-SemiBold.ttf',
  'assets/fonts/OFL-Unbounded.txt': 'fonts/OFL-Unbounded.txt',
  'assets/fonts/OFL-Inter.txt': 'fonts/OFL-Inter.txt',
};

void main() {
  final sources = {
    for (final slug in slugs)
      slug: File('assets/legal/$slug.md').readAsStringSync(),
  };
  final site = Directory('site');
  if (site.existsSync()) site.deleteSync(recursive: true);
  for (final MapEntry(key: path, value: content) in buildSite(
    sources,
  ).entries) {
    File('site/$path')
      ..createSync(recursive: true)
      ..writeAsStringSync(content);
  }
  for (final MapEntry(key: source, value: target) in staticFiles.entries) {
    File('site/assets/$target').createSync(recursive: true);
    File(source).copySync('site/assets/$target');
  }
  stdout.writeln(
    'site/ atualizado (${sources.length} documentos, '
    '${staticFiles.length} arquivos fixos).',
  );
}
