import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:pulse/features/legal/presentation/privacy_providers.dart';
import 'package:pulse/features/legal/presentation/widgets/markdown_view.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

String legalTitle(AppLocalizations l10n, LegalDocument doc) => switch (doc) {
  LegalDocument.terms => l10n.legalTerms,
  LegalDocument.privacy => l10n.legalPrivacy,
  LegalDocument.guidelines => l10n.legalGuidelines,
  LegalDocument.deleteAccount => l10n.legalDeleteAccount,
};

/// Termos de Uso, Política de Privacidade, Diretrizes… inside the app.
class LegalDocumentScreen extends ConsumerWidget {
  const new({required this.document, super.key});

  final LegalDocument document;

  Future<void> _openLink(BuildContext context, String href) async {
    // Links between documents use their slugs ("politica-de-privacidade").
    final target = LegalDocument.fromSlug(href);
    if (target != null) {
      await context.push(AppRoutes.legal(target));
      return;
    }
    final uri = Uri.tryParse(href);
    if (uri != null && uri.hasScheme) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final text = ref.watch(legalTextProvider(document));

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(legalTitle(l10n, document).toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: text,
          onRetry: () => ref.invalidate(legalTextProvider(document)),
          data: (markdown) => ListView(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              spacing.md,
              spacing.md,
              spacing.xxl,
            ),
            children: [
              MarkdownView(
                markdown: markdown,
                onLink: (href) => _openLink(context, href),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
