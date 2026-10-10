import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/auth/domain/session_status.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:pulse/features/legal/presentation/widgets/markdown_view.dart';
import 'package:pulse/l10n/app_localizations.dart';

import '../../../tool/build_site.dart' as site_tool;
import '../../../tool/site_builder.dart';

void main() {
  test('every legal document is bundled and listed on the site', () {
    for (final doc in LegalDocument.values) {
      expect(File(doc.assetPath).existsSync(), isTrue, reason: doc.slug);
      expect(site_tool.slugs, contains(doc.slug));
    }
  });

  test('site/ is up to date with assets/legal (run tool/build_site.dart)', () {
    final generated = buildSite({
      for (final slug in site_tool.slugs)
        slug: File('assets/legal/$slug.md').readAsStringSync(),
    });
    for (final MapEntry(key: path, value: content) in generated.entries) {
      final file = File('site/$path');
      expect(file.existsSync(), isTrue, reason: 'falta site/$path');
      expect(
        file.readAsStringSync(),
        content,
        reason: 'site/$path desatualizado: rode dart run tool/build_site.dart',
      );
    }
  });

  test('legal documents open in any session state', () {
    for (final status in SessionStatus.values) {
      expect(
        resolveRedirect(
          status: status,
          location: AppRoutes.legal(LegalDocument.privacy),
        ),
        isNull,
        reason: status.name,
      );
    }
  });

  testWidgets('the Markdown view renders headings, lists, tables and links', (
    tester,
  ) async {
    final opened = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: MarkdownView(
                markdown: '''
# Política

## Dados

- **Cadastro:** nome e e-mail.

| Fornecedor | Onde |
|---|---|
| Supabase | Brasil |

O selo "Oficial" & outros.

Veja os [Termos](termos-de-uso).
''',
                onLink: opened.add,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Política'), findsOneWidget);
    expect(find.text('Dados'), findsOneWidget);
    expect(find.textContaining('nome e e-mail', findRichText: true), findsOne);
    // Table row as a card: first cell as title, others labelled.
    expect(find.text('Supabase', findRichText: true), findsOneWidget);
    expect(
      find.textContaining('Onde: Brasil', findRichText: true),
      findsOneWidget,
    );

    // Quotes and ampersands are not HTML-escaped (no &quot;).
    expect(
      find.textContaining('O selo "Oficial" & outros.', findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text('Termos'));
    expect(opened, ['termos-de-uso']);
  });
}
