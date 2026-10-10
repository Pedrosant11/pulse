// Regenerates the public legal site in `site/` from `assets/legal/*.md`.
//
//   dart run tool/build_site.dart
//
// Run it after editing any legal document (a test fails while `site/` is
// out of date). GitHub Pages publishes `site/` (.github/workflows/pages.yml).
import 'dart:io';

import 'site_builder.dart';

/// Order of the documents on the index page.
const slugs = [
  'termos-de-uso',
  'politica-de-privacidade',
  'diretrizes-da-comunidade',
  'excluir-conta',
];

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
  stdout.writeln('site/ atualizado (${sources.length} documentos).');
}
