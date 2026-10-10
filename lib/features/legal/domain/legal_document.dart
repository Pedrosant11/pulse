/// Legal documents (Termos, Privacidade, Diretrizes, exclusão de conta).
/// The Markdown files in `assets/legal/` are the single source: the app
/// shows them and `tool/build_site.dart` turns them into the public site.
enum LegalDocument {
  terms('termos-de-uso'),
  privacy('politica-de-privacidade'),
  guidelines('diretrizes-da-comunidade'),
  deleteAccount('excluir-conta');

  new(this.slug);

  /// File name and public URL path (`<site>/<slug>/`).
  final String slug;

  String get assetPath => 'assets/legal/$slug.md';

  static LegalDocument? fromSlug(String slug) {
    for (final doc in values) {
      if (doc.slug == slug) return doc;
    }
    return null;
  }
}
