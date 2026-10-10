import 'package:flutter/services.dart';
import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/legal/data/privacy_repository.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_providers.g.dart';

/// "Baixar meus dados" (LGPD art. 18: access and portability).
@riverpod
class DataExport extends _$DataExport {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> export() => runAction(ref, (s) => state = s, () async {
    final repository = ref.read(privacyRepositoryProvider);
    final data = await repository.exportMyData();
    await repository.shareExport(data);
    return true;
  });
}

/// Bundled text of a legal document (works offline and matches the version
/// the user accepts).
@riverpod
Future<String> legalText(Ref ref, LegalDocument document) =>
    rootBundle.loadString(document.assetPath);
